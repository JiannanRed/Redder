//
//  myEventDetailViewController.m
//  Redder
//
//  Created by Jiannan on 9/19/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "myEventDetailViewController.h"

@interface myEventDetailViewController ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UIColor *backgroundColor;
    UIButton *eventTitleButton,*eventDateButton,*eventTimeButton,*eventContentButton,*disableEventButton,*deleteEventButton,*applyUserButton,*confirmUserButton;
    NSString *eventDateString,*eventTimeString,*isAvailable,*contactUsersString;
    NSMutableArray *contactUserList,*contactUserIDList,*confirmUserList,*confirmUserIDList,*applyPassengerList,*applyDriverList,*confirmPassengerList,*confirmDriverList;
}

@end

NSInteger appliedUserNumber,comfirmedUserNumber;

@implementation myEventDetailViewController
@synthesize datepicker,picker,activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidden:NO];
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"myEventDetailView" forKey:@"fromWhere"];
    [self loadEventDate];
    if(appliedUserNumber==1){
        [applyUserButton setTitle:[NSString stringWithFormat:@"%lu person is applying to join.",(unsigned long)appliedUserNumber] forState:UIControlStateNormal];
    }
    if(appliedUserNumber>1){
        [applyUserButton setTitle:[NSString stringWithFormat:@"%lu people are applying to join.",(unsigned long)appliedUserNumber] forState:UIControlStateNormal];
    }
    if(appliedUserNumber==0){
        [applyUserButton setTitle:[NSString stringWithFormat:@"No one is applying to join."] forState:UIControlStateNormal];
    }
    if(comfirmedUserNumber==0){
        [confirmUserButton setTitle:[NSString stringWithFormat:@"No one has joined."] forState:UIControlStateNormal];
    }
    if(comfirmedUserNumber==1){
        [confirmUserButton setTitle:[NSString stringWithFormat:@"%lu person has joined.",(unsigned long)comfirmedUserNumber] forState:UIControlStateNormal];
    }
    if(comfirmedUserNumber>1){
        [confirmUserButton setTitle:[NSString stringWithFormat:@"%lu people have joined.",(unsigned long)comfirmedUserNumber] forState:UIControlStateNormal];
    }
    
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}

- (void)viewDidLoad
{
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    activityIndicator.hidden=NO;
    [self.view addSubview:activityIndicator];
    [self.activityIndicator stopAnimating];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Start to load myRelativeEventDetailViewController");
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My Event Detail"];
    navigItem.leftBarButtonItem=backButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    _eventTitle=[_eventDetailInfo objectAtIndex:0];
    _eventType=[_eventDetailInfo objectAtIndex:4];
    _eventDate=[_eventDetailInfo objectAtIndex:1];
    _eventId=[_eventDetailInfo objectAtIndex:5];
    _eventContent=[_eventDetailInfo objectAtIndex:2];
    isAvailable=[_eventDetailInfo objectAtIndex:3];
    
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.frame=CGRectMake(20, 75, 280, 450);
    if ([_eventType isEqualToString:@"driver"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
        backgroundColor=[UIColor colorWithRed:183.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
    }
    if ([_eventType isEqualToString:@"passenger"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:137.0/255.0 blue:111.0/255.0 alpha:1.0];
        backgroundColor=[UIColor colorWithRed:242.0/255.0 green:137.0/255.0 blue:111.0/255.0 alpha:1.0];
    }
    if ([_eventType isEqualToString:@"undecided"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0];
        backgroundColor=[UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0];
    }
    [self.view addSubview:backgroundView];
    
    NSLog(@"Add event title button");
    eventTitleButton=[[UIButton alloc]init];
    eventTitleButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eventTitleButton addTarget:self action:@selector(clickEventTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [eventTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eventTitleButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[eventTitleButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    eventTitleButton.frame=CGRectMake(30.0f, 90.0f, 260.0f, 40.0f);
    [eventTitleButton setTitle:[NSString stringWithFormat:@"%@",_eventTitle] forState:UIControlStateNormal];
    [eventTitleButton setBackgroundColor:backgroundColor];
    [self.view addSubview:eventTitleButton];
    
    NSLog(@"Add event Date button");
    eventDateButton=[[UIButton alloc]init];
    eventDateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eventDateButton addTarget:self action:@selector(clickEventDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [eventDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eventDateButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[eventDateButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    eventDateButton.frame=CGRectMake(30.0f, 140.0f, 260.0f, 40.0f);
    [eventDateButton setTitle:[NSString stringWithFormat:@"%@",_eventDate] forState:UIControlStateNormal];
    [eventDateButton setBackgroundColor:backgroundColor];
    [self.view addSubview:eventDateButton];
    
    NSLog(@"Add event Content button");
    eventContentButton=[[UIButton alloc]init];
    eventContentButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eventContentButton addTarget:self action:@selector(clickEventContentButton:) forControlEvents:UIControlEventTouchUpInside];
    [eventContentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [eventContentButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[eventContentButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    eventContentButton.frame=CGRectMake(30.0f, 190.0f, 260.0f, 40.0f);
    [eventContentButton setTitle:[NSString stringWithFormat:@"%@",_eventContent] forState:UIControlStateNormal];
    [eventContentButton setBackgroundColor:backgroundColor];
    [self.view addSubview:eventContentButton];
    
    applyUserButton=[[UIButton alloc]init];
    applyUserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [applyUserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [applyUserButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [[applyUserButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    applyUserButton.frame=CGRectMake(30.0f, 280.0f, 260.0f, 40.0f);
    [applyUserButton addTarget:self action:@selector(clickApplyUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [applyUserButton setBackgroundColor:backgroundColor];
    CALayer *btnLayer = [applyUserButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:applyUserButton];
    
    confirmUserButton=[[UIButton alloc]init];
    confirmUserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmUserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmUserButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [[confirmUserButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    confirmUserButton.frame=CGRectMake(30.0f, 330.0f, 260.0f, 40.0f);
    [confirmUserButton addTarget:self action:@selector(clickConfirmUserButton:) forControlEvents:UIControlEventTouchUpInside];
    [confirmUserButton setBackgroundColor:backgroundColor];
    btnLayer = [confirmUserButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:confirmUserButton];
    
    disableEventButton=[[UIButton alloc]init];
    disableEventButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [disableEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disableEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[disableEventButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    disableEventButton.frame=CGRectMake(35.0f, 420.0f, 250.0f, 40.0f);
    if ([isAvailable isEqualToString:@"active"]) {
        [disableEventButton setTitle:@"Disable this event" forState:UIControlStateNormal];
        [disableEventButton addTarget:self action:@selector(clickDisableEventButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [disableEventButton setTitle:@"Enable this event" forState:UIControlStateNormal];
        [disableEventButton addTarget:self action:@selector(clickEnableEventButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [disableEventButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [disableEventButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:disableEventButton];
    
    deleteEventButton=[[UIButton alloc]init];
    deleteEventButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[deleteEventButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    deleteEventButton.frame=CGRectMake(35.0f, 470.0f, 250.0f, 40.0f);
    [deleteEventButton setTitle:@"Delete this event" forState:UIControlStateNormal];
    [deleteEventButton addTarget:self action:@selector(clickDeleteEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [deleteEventButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [deleteEventButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:deleteEventButton];
}

-(void)loadEventDate{
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidden:NO];
    }
    contactUserList=[[NSMutableArray alloc]init];
    confirmUserList=[[NSMutableArray alloc]init];
    applyDriverList=[[NSMutableArray alloc]init];
    applyPassengerList=[[NSMutableArray alloc]init];
    confirmDriverList=[[NSMutableArray alloc]init];
    confirmPassengerList=[[NSMutableArray alloc]init];
    contactUserIDList=[[NSMutableArray alloc]init];
    confirmUserIDList=[[NSMutableArray alloc]init];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _appliedUserString=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"waitListAttribute"];
    _confirmedUserString=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"confirmUsersAttribute"];
    appliedUserNumber=_appliedUserString.length/13;
    comfirmedUserNumber=_confirmedUserString.length/13;
    for (NSInteger i=0; i<appliedUserNumber; ++i) {
        [contactUserList addObject:(id)[_appliedUserString substringWithRange:NSMakeRange(13*i, 10)]];
        [contactUserIDList addObject:(id)[_appliedUserString substringWithRange:NSMakeRange(13*i, 12)]];
    }
    for (NSInteger i=0; i<comfirmedUserNumber; ++i) {
        [confirmUserList addObject:(id)[_confirmedUserString substringWithRange:NSMakeRange(13*i, 10)]];
        [confirmUserIDList addObject:(id)[_confirmedUserString substringWithRange:NSMakeRange(13*i, 12)]];
    }
    
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}

-(void)clickApplyUserButton:(id)sender{
    if (contactUserList.count>0) {
        NSLog(@"clickApplyUserButton");
        userViewController *eventUserView=[self.storyboard instantiateViewControllerWithIdentifier:@"userViewController"];
        [eventUserView setUserType:@"apply"];
        [eventUserView setUserList:contactUserList];
        [eventUserView setUserIDList:contactUserIDList];
        [eventUserView setEventID:_eventId];
        [self presentViewController:eventUserView animated:YES completion:nil];
        /*eventUsersViewController *eventUserView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventUsersViewController"];
        [eventUserView setUserType:@"apply"];
        [eventUserView setUserList:contactUserList];
        [eventUserView setUserIDList:contactUserIDList];
        [eventUserView setEventID:_eventId];
        [self presentViewController:eventUserView animated:YES completion:nil];*/
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No one is applying." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)clickConfirmUserButton:(id)sender{
    if (confirmUserList.count>0) {
        userViewController *eventUserView=[self.storyboard instantiateViewControllerWithIdentifier:@"userViewController"];
        [eventUserView setUserType:@"confirm"];
        [eventUserView setUserList:confirmUserList];
        [eventUserView setUserIDList:confirmUserIDList];
        [eventUserView setEventID:_eventId];
        [self presentViewController:eventUserView animated:YES completion:nil];
        /*eventUsersViewController *eventUserView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventUsersViewController"];
        [eventUserView setUserType:@"confirm"];
        [eventUserView setUserList:confirmUserList];
        [eventUserView setUserIDList:confirmUserIDList];
        [eventUserView setEventID:_eventId];
        [self presentViewController:eventUserView animated:YES completion:nil];*/
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No one has joined." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)clickEventTitleButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Edit event title" message:@"Input new event title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag=1;
    [alert show];
}

-(void)clickEventContentButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Edit event content" message:@"Input new event content" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag=2;
    [alert show];
}

-(void)clickDisableEventButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to disable this event" message:@"After disabling it, other people can not join." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    alert.tag=3;
    [alert show];
}

-(void)clickEnableEventButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to enable this event" message:@"After enabling it, other people could join again." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=4;
    [alert show];
}

-(void)clickDeleteEventButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to delete this event" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    alert.tag=5;
    [alert show];
}

-(void)clickEventDateButton:(id)sender{
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select Date", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    datepicker=[[UIDatePicker alloc]init];
    datepicker.datePickerMode=UIDatePickerModeDate;
    sheet.tag=0;
    [datepicker setDate:[NSDate date]];
    [sheet addSubview:datepicker];
}

- (void)chooseDecideTime {
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select Time", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    datepicker=[[UIDatePicker alloc]init];
    datepicker.datePickerMode=UIDatePickerModeTime;
    sheet.tag=1;
    [datepicker setDate:[NSDate date]];
    [sheet addSubview:datepicker];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0 && actionSheet.tag==0) {
        NSDate *date=datepicker.date;
        eventDateString=[self getFinalDateStringFromDate:date];
        [self chooseDecideTime];
    }
    if (buttonIndex==0 && actionSheet.tag==1) {
        NSDate *date=datepicker.date;
        eventTimeString=[self getFinalTimeStringFromDate:date];
        [eventDateButton setTitle:[NSString stringWithFormat:@"%@ %@",eventDateString,eventTimeString] forState:UIControlStateNormal];
        [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"eventDateAttribute" Value:[NSString stringWithFormat:@"%@ %@",eventDateString,eventTimeString]];
    }
}

-(NSString *)getFinalTimeStringFromDate:(NSDate *)time{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"HH:mm"];
    NSString *fullTime=[format stringFromDate:time];
    NSString *AmOrPM,*hour,*min;
    NSInteger h=[[fullTime substringWithRange:NSMakeRange(0, 2)] intValue];
    if (h>12) {
        AmOrPM=@"PM";
        hour=[NSString stringWithFormat:@"%ld",h-12];
        min=[fullTime substringWithRange:NSMakeRange(3, 2)];
    } else {
        AmOrPM=@"AM";
        hour=[NSString stringWithFormat:@"%ld",(long)h];
        min=[fullTime substringWithRange:NSMakeRange(3, 2)];
    }
    self.finalDateStringPart2=[NSString stringWithFormat:@"%@:%@ %@",hour,min,AmOrPM];
    return [NSString stringWithFormat:@"%@:%@ %@",hour,min,AmOrPM];
}

-(NSString *)getFinalDateStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay=[dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"MMM d y"];
    //NSString *dateString=[dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yy/MM/dd"];
    NSString *dateString1=[dateFormatter stringFromDate:date];
    self.finalDateStringPart1=[NSString stringWithFormat:@"%@, %@", [weekDay substringWithRange:NSMakeRange(0, 3)],dateString1];
    return [NSString stringWithFormat:@"%@, %@", [weekDay substringWithRange:NSMakeRange(0, 3)],dateString1];
}

-(void)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        if(buttonIndex==1){
            if ([alertView textFieldAtIndex:0].text.length>0) {
                [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"eventTitleAttribute" Value:[alertView textFieldAtIndex:0].text];
                [eventTitleButton setTitle:[alertView textFieldAtIndex:0].text forState:UIControlStateNormal];
            }
        }
    }
    if(alertView.tag==2){
        if(buttonIndex==1){
            if ([alertView textFieldAtIndex:0].text.length>0) {
                [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"eventContentAttribute" Value:[alertView textFieldAtIndex:0].text];
                [eventContentButton setTitle:[alertView textFieldAtIndex:0].text forState:UIControlStateNormal];
            }
        }
    }
    if (alertView.tag==3) {
        [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"activeStatusAttribute" Value:@"inActive"];
        [disableEventButton setTitle:@"Enable this event" forState:UIControlStateNormal];
    }
    if (alertView.tag==4) {
        [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"activeStatusAttribute" Value:@"active"];
        [disableEventButton setTitle:@"Disable this event" forState:UIControlStateNormal];
    }
    if (alertView.tag==5) {
        [self deleteEvent];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteEvent{
    for (NSInteger i=0; i<appliedUserNumber; ++i) {
        [self deleteEventFromUser:_eventId eventType:@"contactEventsAttribute" username:[contactUserList objectAtIndex:i]];
    }
    for (NSInteger i=0; i<comfirmedUserNumber; ++i) {
        [self deleteEventFromUser:_eventId eventType:@"confirmEventsAttribute" username:[confirmUserList objectAtIndex:i]];
    }
    SimpleDBDeleteAttributesRequest *deleteRequest=[[SimpleDBDeleteAttributesRequest alloc]initWithDomainName:@"eventTable" andItemName:_eventId];
    [sdbClient deleteAttributes:deleteRequest];
}

-(void)deleteEventFromUser:(NSString *)eventID eventType:(NSString *)eventType username:(NSString *)phoneNumber{
    NSLog(@"Delete event %@ in %@ from %@",eventID,eventType,phoneNumber);
    NSString *eventString=@"",*updateEventString=@"";
    NSMutableArray *eventList=[[NSMutableArray alloc]init];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    eventString=[self getAttributeValue:sdbClient domain:@"accountTable" item:phoneNumber attribute:eventType];
    NSLog(@"%@",eventString);
    eventList=[self parseEventString:eventString];
    for (NSInteger i=0; i<eventList.count; ++i) {
        if (![[eventList objectAtIndex:i] isEqualToString:eventID]) {
            updateEventString=[NSString stringWithFormat:@"%@%@/",updateEventString,[eventList objectAtIndex:i]];
        }
    }
    [self updateAttribute:sdbClient domain:@"accountTable" item:phoneNumber attribute:eventType Value:updateEventString];
    NSLog(@"%@",updateEventString);
}

-(NSMutableArray *)parseEventString:(NSString *)eventString{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    //NSLog(@"Start to parse %@",eventString);
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

-(void)updateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSLog(@"In DB:domain:%@,item:%@,update attribute:%@ to value:%@",domainName,itemName,attributeName,value);
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

-(NSString *)getAttributeValue:(AmazonSimpleDBClient *)sdbClient domain:(NSString *)domainName item:(NSString *)itemName attribute:(NSString *)attributeName{
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
