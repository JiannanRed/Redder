//
//  myRelativeEventViewController.m
//  Redder
//
//  Created by Jiannan on 9/15/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "myRelativeEventViewController.h"

@interface myRelativeEventViewController (){
    NSInteger contactEventNumber;
    NSInteger confirmEventNumber;
}

@end

@implementation myRelativeEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"myRelativeEventView" forKey:@"fromWhere"];
    [self refreshStart];
}

- (void)viewDidLoad
{
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.tintColor=[UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refreshStart) forControlEvents:UIControlEventValueChanged];
    [self.myRelativeCollectionView addSubview:_refreshControl];
    
    _contactEventList=[[NSMutableArray alloc]init];
    _confirmEventList=[[NSMutableArray alloc]init];
    _phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _contactEventString=[self getAttibuteValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute"];
    _contactEventList=[self parseEventString:_contactEventString];
    _confirmEventString=[self getAttibuteValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"confirmEventsAttribute"];
    _confirmEventList=[self parseEventString:_confirmEventString];
    
    _orderIndex=[[NSMutableArray alloc]init];
    NSInteger count;
    count=_contactEventList.count+_confirmEventList.count;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self loadEventData];
    NSInteger orderedIndex[count];
    for (NSInteger i=0; i<count; ++i) {
        orderedIndex[i]=i;
    }
    [self sortEventByDate:orderedIndex];
    for (NSInteger i=0; i<count; ++i) {
        [_orderIndex addObject:(id)[NSString stringWithFormat:@"%ld",(long)orderedIndex[i]]];
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    // Do any additional setup after loading the view.
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    //UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My Active Events"];
    //navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [super viewDidLoad];
}

-(void)sortEventByDate:(NSInteger *)orderedIndex{
    NSLog(@"Start sort Event by date in Collection View");
    NSInteger t,count=_eventTime.count;
    NSDate *date1,*date2;
    for (NSInteger i=0; i<count-1; ++i) {
        date1=[self getDateInFormat:_eventTime[orderedIndex[i]]];
        for (NSInteger j=i+1; j<count; ++j) {
            date2=[self getDateInFormat:_eventTime[orderedIndex[j]]];
            if([date2 compare:date1]==NSOrderedAscending){
                t=orderedIndex[i];
                orderedIndex[i]=orderedIndex[j];
                orderedIndex[j]=t;
                date1=[self getDateInFormat:_eventTime[orderedIndex[i]]];
            }
        }
    }
    NSLog(@"Finish sort Event by date in Collection View");
}

-(NSDate *)getDateInFormat:(NSString *)dateString{
    //NSLog(@"Start getDateInFormat by date in Collection View");
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *day,*hour,*minutes,*amOrPm,*finalDateString;
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yy/MM/dd HH:mm"];
    day=[dateString substringWithRange:NSMakeRange(5, 8)];
    if ([[dateString substringWithRange:NSMakeRange(15, 1)] isEqualToString:@":"]) {
        hour=[dateString substringWithRange:NSMakeRange(14, 1)];
        minutes=[dateString substringWithRange:NSMakeRange(16, 2)];
        amOrPm=[dateString substringWithRange:NSMakeRange(19, 2)];
    }else{
        hour=[dateString substringWithRange:NSMakeRange(14, 2)];
        minutes=[dateString substringWithRange:NSMakeRange(17, 2)];
        amOrPm=[dateString substringWithRange:NSMakeRange(20, 1)];
    }
    if ([amOrPm isEqualToString:@"PM"]) {
        hour=[NSString stringWithFormat:@"%d",[hour intValue]+12];
    }
    finalDateString=[NSString stringWithFormat:@"%@ %@:%@",day,hour,minutes];
    NSDate *date;
    date=[dateFormatter dateFromString:finalDateString];
    return date;
}

-(void) loadEventData{
    _eventTitle=[[NSMutableArray alloc]init];
    _eventTime=[[NSMutableArray alloc]init];
    _eventContentAttribute=[[NSMutableArray alloc]init];
    _isAvailableAttribute=[[NSMutableArray alloc]init];
    _postUsernameAttribute=[[NSMutableArray alloc]init];
    _eventType=[[NSMutableArray alloc]init];
    _eventPhoneNumber=[[NSMutableArray alloc]init];
    NSLog(@"Start to load event information from database in my relative events collection view.\n\n");
    
    NSString *domainName=[[NSString alloc]initWithFormat:@"eventTable"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    if (_contactEventList.count>0) {
        for (NSInteger i=0; i<_contactEventList.count; ++i) {
            SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:[_contactEventList objectAtIndex:i]];
            SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
            [_eventPhoneNumber addObject:[_contactEventList objectAtIndex:i]];
            NSLog(@"contactEventPhoneNumber:%@",_eventPhoneNumber);
            if(getResponse.exception==nil){
                for(SimpleDBAttribute *attri in getResponse.attributes){
                    NSLog(@"%@,%@",attri.name,attri.value);
                    if([attri.name isEqualToString:@"eventTitleAttribute"]){
                        [_eventTitle addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventDateAttribute"]){
                        [_eventTime addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventContentAttribute"]){
                        [_eventContentAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"postUsernameAttribute"]){
                        [_postUsernameAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"activeStatusAttribute"]){
                        [_isAvailableAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventTypeAttribute"]){
                        [_eventType addObject:(id)attri.value];
                    }
                }
            }else{
                NSLog(@"error getting attributes:%@",getResponse.exception);
            }
        }
    }
    if (_confirmEventList.count>0) {
        for (NSInteger i=0; i<_confirmEventList.count; ++i) {
            SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:[_confirmEventList objectAtIndex:i]];
            SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
            [_eventPhoneNumber addObject:[[_confirmEventList objectAtIndex:i] substringWithRange:NSMakeRange(0, 10)]];
            NSLog(@"confirmEventPhoneNumber:%@",_eventPhoneNumber);
            if(getResponse.exception==nil){
                for(SimpleDBAttribute *attri in getResponse.attributes){
                    if([attri.name isEqualToString:@"eventTitleAttribute"]){
                        [_eventTitle addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventDateAttribute"]){
                        [_eventTime addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventContentAttribute"]){
                        [_eventContentAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"postUsernameAttribute"]){
                        [_postUsernameAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"activeStatusAttribute"]){
                        [_isAvailableAttribute addObject:(id)attri.value];
                    }
                    if([attri.name isEqualToString:@"eventTypeAttribute"]){
                        [_eventType addObject:(id)attri.value];
                    }
                }
            }else{
                NSLog(@"error getting attributes:%@",getResponse.exception);
            }
        }
    }
    NSLog(@"Finish load data from dataBase in Collection View");
}

-(NSInteger)collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"number of items in section: %lu",_contactEventList.count+_confirmEventList.count);
    return _contactEventList.count+_confirmEventList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    myRelativeEventViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"myRelativeEventViewCell" forIndexPath:indexPath];
    long row=[indexPath row];
    cell.userNameLabel.text=_postUsernameAttribute[[_orderIndex[row] intValue]];
    cell.eventTitleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    cell.eventTitleLabel.text=_eventTitle[[_orderIndex[row] intValue]];
    cell.eventTimeLabel.font=[UIFont italicSystemFontOfSize:13.0f];
    cell.eventTimeLabel.text=_eventTime[[_orderIndex[row] intValue]];
    if ([_eventType[[_orderIndex[row] intValue]] isEqualToString:@"driver"]) {
        cell.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
    }
    if ([_eventType[[_orderIndex[row] intValue]] isEqualToString:@"passenger"]){
        cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:137.0/255.0 blue:111.0/255.0 alpha:1.0];
    }
    if ([_eventType[[_orderIndex[row] intValue]] isEqualToString:@"undecided"]){
        cell.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0];
    }
    if([_isAvailableAttribute[[_orderIndex[row] intValue]] isEqualToString:@"inActive"]){
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    return cell;
}

-(NSMutableArray *)parseEventString:(NSString *)eventString{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    NSLog(@"Start to parse %@",eventString);
    NSInteger startPoint,subStringLength;
    startPoint=0;
    subStringLength=0;
    while (startPoint+subStringLength<eventString.length) {
        if ([[eventString substringWithRange:NSMakeRange(startPoint+subStringLength, 1)] isEqualToString:@"/"]) {
            [list addObject:[eventString substringWithRange:NSMakeRange(startPoint, subStringLength)]];
            startPoint=startPoint+subStringLength+1;
            subStringLength=0;
        } else {
            subStringLength++;
        }
    }
    return list;
}

-(void)clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshStart{
    NSLog(@"Start to refresh collection view.");
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _contactEventString=[self getAttibuteValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute"];
    _contactEventList=[self parseEventString:_contactEventString];
    _confirmEventString=[self getAttibuteValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"confirmEventsAttribute"];
    _confirmEventList=[self parseEventString:_confirmEventString];
    
    _orderIndex=[[NSMutableArray alloc]init];
    NSInteger count;
    count=_contactEventList.count+_confirmEventList.count;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self loadEventData];
    NSInteger orderedIndex[count];
    for (NSInteger i=0; i<count; ++i) {
        orderedIndex[i]=i;
    }
    [self sortEventByDate:orderedIndex];
    for (NSInteger i=0; i<count; ++i) {
        [_orderIndex addObject:(id)[NSString stringWithFormat:@"%ld",(long)orderedIndex[i]]];
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    // Do any additional setup after loading the view.
    /*UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My Relevant Events"];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];*/
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [self.myRelativeCollectionView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Start to turn to myRelativeEventDetailViewController");
    NSLog(@"%@",[segue identifier]);
    if([[segue identifier] isEqualToString:@"showRelativeEventDetails"]){
        
        myRelativeEventDetailViewController *detailViewController=[segue destinationViewController];
        NSIndexPath *myIndexPath=[[self.myRelativeCollectionView indexPathsForSelectedItems] lastObject];
        long row=[myIndexPath row];
        NSLog(@"%@",_eventPhoneNumber[[_orderIndex[row] intValue]]);
        detailViewController.eventType=_eventType[[_orderIndex[row] intValue]];
        detailViewController.eventDetailInfo=@[_eventTitle[[_orderIndex[row] intValue]],_eventTime[[_orderIndex[row] intValue]],_eventContentAttribute[[_orderIndex[row] intValue]],_isAvailableAttribute[[_orderIndex[row] intValue]],_postUsernameAttribute[[_orderIndex[row] intValue]],_eventPhoneNumber[[_orderIndex[row] intValue]]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value{
    NSMutableArray *attribList=[[NSMutableArray alloc]init];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:attrib.name andValue:attrib.value andReplace:YES];
            if ([attrib.name isEqualToString:attributeName]) {
                attrib1.value=value;
            }
            [attribList addObject:attrib1];
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        NSLog(@"Attributes updated");
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
}

-(NSString *)getAttibuteValue:(AmazonSimpleDBClient *)sdbClient domain:(NSString *)domainName item:(NSString *)itemName attribute:(NSString *)attributeName{
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            if ([attrib.name isEqualToString:attributeName]) {
                return attrib.value;
            }
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    return @"";
}

@end
