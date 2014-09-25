//
//  eventPoolViewController.m
//  Redder
//
//  Created by Jiannan on 9/16/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "eventPoolViewController.h"

@interface eventPoolViewController ()

@end

@implementation eventPoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.tintColor=[UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refreshStart) forControlEvents:UIControlEventValueChanged];
    [self.eventPoolCollectionView addSubview:_refreshControl];
    
    _orderIndex=[[NSMutableArray alloc]init];
    NSInteger count;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    count=[self loadEventData];
    NSInteger orderedIndex[count];
    for (NSInteger i=0; i<count; ++i) {
        orderedIndex[i]=i;
    }
    [self sortEventByDate:orderedIndex];
    for (NSInteger i=0; i<count; ++i) {
        [_orderIndex addObject:(id)[NSString stringWithFormat:@"%ld",(long)orderedIndex[i]]];
    }
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(clickAddButton:)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Events Pool"];
    navigItem.rightBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"eventPoolView" forKey:@"fromWhere"];
    [self refreshStart];
}

-(void)refreshStart{
    NSLog(@"Start to refresh collection view.");
    _orderIndex=[[NSMutableArray alloc]init];
    NSInteger count;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    count=[self loadEventData];
    NSInteger orderedIndex[count];
    for (NSInteger i=0; i<count; ++i) {
        orderedIndex[i]=i;
    }
    [self sortEventByDate:orderedIndex];
    for (NSInteger i=0; i<count; ++i) {
        [_orderIndex addObject:(id)[NSString stringWithFormat:@"%ld",(long)orderedIndex[i]]];
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [self.eventPoolCollectionView reloadData];
    [self.refreshControl endRefreshing];
}

-(NSInteger) loadEventData{
    _eventTitle=[[NSMutableArray alloc]init];
    _eventTime=[[NSMutableArray alloc]init];
    _eventContentAttribute=[[NSMutableArray alloc]init];
    _isAvailableAttribute=[[NSMutableArray alloc]init];
    _postUsernameAttribute=[[NSMutableArray alloc]init];
    _eventType=[[NSMutableArray alloc]init];
    _eventPhoneNumber=[[NSMutableArray alloc]init];
    NSLog(@"Start to load event information from database in collection view.\n\n");
    
    NSString *domainName=[[NSString alloc]initWithFormat:@"eventTable"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select activeStatusAttribute,eventContentAttribute,postUsernameAttribute,eventDateAttribute,eventTitleAttribute,eventTypeAttribute from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    //selectRequest1.nextToken=nextToken;
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    for (SimpleDBItem *item in select1Response.items){
        [_eventPhoneNumber addObject:(id)item.name];
        for(SimpleDBAttribute *attri in item.attributes){
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
    }
    NSLog(@"Finish load data from dataBase in Collection View");
    return _eventTime.count;
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.eventTime count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"eventPoolCell";
    eventPoolCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    long row=[indexPath row];
    cell.usernameLabel.text=_postUsernameAttribute[[_orderIndex[row] intValue]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickAddButton:(id)sender {
    addEventViewController *addEventView=[self.storyboard instantiateViewControllerWithIdentifier:@"addEventViewController"];
    [self presentViewController:addEventView animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showEventDetail"]){
        eventDetailViewController *detailViewController=[segue destinationViewController];
        NSIndexPath *myIndexPath=[[self.eventPoolCollectionView indexPathsForSelectedItems] lastObject];
        long row=[myIndexPath row];
        detailViewController.eventType=_eventType[[_orderIndex[row] intValue]];
        detailViewController.eventDetailInfo=@[_eventTitle[[_orderIndex[row] intValue]],_eventTime[[_orderIndex[row] intValue]],_eventContentAttribute[[_orderIndex[row] intValue]],_isAvailableAttribute[[_orderIndex[row] intValue]],_postUsernameAttribute[[_orderIndex[row] intValue]],_eventPhoneNumber[[_orderIndex[row] intValue]]];
    }
}

@end
