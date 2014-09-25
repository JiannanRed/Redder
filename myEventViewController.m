//
//  myEventViewController.m
//  Redder
//
//  Created by Jiannan on 9/17/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "myEventViewController.h"

@interface myEventViewController ()

@end

@implementation myEventViewController

@synthesize activityIndicator;

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
    [self.myEventCollectionView addSubview:_refreshControl];
    [self selfViewDidLoad];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    NSString *fromWhere=[[NSUserDefaults standardUserDefaults]stringForKey:@"fromWhere"];
    if ([fromWhere isEqualToString:@"myAccountViewLogout"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"myEventView" forKey:@"fromWhere"];
    [self refreshStart];
}

-(void)selfViewDidLoad{
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    activityIndicator.hidden=NO;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    _phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
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
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *myAccountButton=[[UIBarButtonItem alloc]initWithTitle:@"Me" style:UIBarButtonItemStyleBordered target:self action:@selector(clickMyAccountButton)];
    //UIBarButtonItem *logoutButton=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLougoutButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My  Events"];
    navigItem.rightBarButtonItem=myAccountButton;
    //navigItem.leftBarButtonItem=logoutButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}

-(void)refreshStart{
    NSLog(@"Start to refresh my event collection view.");
    _orderIndex=[[NSMutableArray alloc]init];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self selfViewDidLoad];
    [self.myEventCollectionView reloadData];
    [self.refreshControl endRefreshing];
}

-(NSInteger)loadEventData{
    _eventTitle=[[NSMutableArray alloc]init];
    _eventTime=[[NSMutableArray alloc]init];
    _eventContentAttribute=[[NSMutableArray alloc]init];
    _isAvailableAttribute=[[NSMutableArray alloc]init];
    _waitList=[[NSMutableArray alloc]init];
    _confirmUserList=[[NSMutableArray alloc]init];
    _eventType=[[NSMutableArray alloc]init];
    _eventPhoneNumber=[[NSMutableArray alloc]init];
    _eventId=[[NSMutableArray alloc]init];
    NSLog(@"Start to load event information from database in my events collection view.\n\n");
    
    NSString *domainName=[[NSString alloc]initWithFormat:@"eventTable"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select activeStatusAttribute,eventContentAttribute,waitListAttribute,eventDateAttribute,eventTitleAttribute,eventTypeAttribute,confirmUsersAttribute,postUsernameAttribute from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    //selectRequest1.nextToken=nextToken;
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    for (SimpleDBItem *item in select1Response.items){
        if ([_phoneNumber isEqualToString:[item.name substringWithRange:NSMakeRange(0, 10)]]) {
            [_eventId addObject:(id)item.name];
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
                if([attri.name isEqualToString:@"waitListAttribute"]){
                    [_waitList addObject:(id)attri.value];
                }
                if([attri.name isEqualToString:@"activeStatusAttribute"]){
                    [_isAvailableAttribute addObject:(id)attri.value];
                }
                if([attri.name isEqualToString:@"eventTypeAttribute"]){
                    [_eventType addObject:(id)attri.value];
                }
                if([attri.name isEqualToString:@"confirmUsersAttribute"]){
                    [_confirmUserList addObject:(id)attri.value];
                }
            }
        }
    }
    NSLog(@"Finish load data from dataBase in Collection View");
    return _eventTime.count;
}

-(void)sortEventByDate:(NSInteger *)orderedIndex{
    NSLog(@"Start sort Event by date in My Event View");
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
    NSLog(@"Finish sort Event by date in My Event View");
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
    static NSString *CellIdentifier=@"myEventCollectionCell";
    myEventCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    long row=[indexPath row];
    NSString *waitUsers=[_waitList objectAtIndex:[_orderIndex[row] intValue]];
    NSString *confirmUsers=[_confirmUserList objectAtIndex:[_orderIndex[row] intValue]];
    cell.eventInfoLabel.text=[NSString stringWithFormat:@"%lu application",waitUsers.length/13];
    cell.eventInfoLabel1.text=[NSString stringWithFormat:@"%lu confirmed users",confirmUsers.length/13];
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


-(void)clickLougoutButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickMyAccountButton{
    myAccountViewController *myAccountViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"myAccountViewController"];
    [self presentViewController:myAccountViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Start to turn to myEventDetailViewController");
    NSLog(@"%@",[segue identifier]);
    if([[segue identifier] isEqualToString:@"showMyEventDetail"]){
        myEventDetailViewController *detailViewController=[segue destinationViewController];
        NSIndexPath *myIndexPath=[[self.myEventCollectionView indexPathsForSelectedItems] lastObject];
        long row=[myIndexPath row];
        detailViewController.eventDetailInfo=@[_eventTitle[[_orderIndex[row] intValue]],_eventTime[[_orderIndex[row] intValue]],_eventContentAttribute[[_orderIndex[row] intValue]],_isAvailableAttribute[[_orderIndex[row] intValue]],_eventType[[_orderIndex[row] intValue]],_eventId[[_orderIndex[row] intValue]]];
    }
}

@end
