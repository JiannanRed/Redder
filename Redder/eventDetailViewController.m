//
//  eventDetailViewController.m
//  Redder
//
//  Created by Jiannan on 9/14/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "eventDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface eventDetailViewController ()<MFMessageComposeViewControllerDelegate>

@end

NSInteger appliedUserNumber,comfirmedUserNumber;
BOOL isDriver,isPassenger,isEventHolder;

@implementation eventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"eventDetailView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    //detailViewController.eventType=_eventType[[_orderIndex[row] intValue]];
    //detailViewController.eventDetailInfo=@[_eventTitle[[_orderIndex[row] intValue]],_eventTime[[_orderIndex[row] intValue]],_eventContentAttribute[[_orderIndex[row] intValue]],_isAvailableAttribute[[_orderIndex[row] intValue]],_postUsernameAttribute[[_orderIndex[row] intValue]],_eventPhoneNumber[[_orderIndex[row] intValue]]];
    [super viewDidLoad];
    
    isDriver=NO;
    isPassenger=NO;
    isEventHolder=NO;
    
    _phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    _eventPhoneNumber=[[_eventDetailInfo objectAtIndex:5] substringWithRange:NSMakeRange(0, 10)];
    
    if ([_phoneNumber isEqualToString:_eventPhoneNumber]) {
        isEventHolder=YES;
    }
    _eventId=[_eventDetailInfo objectAtIndex:5];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _appliedUserList=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"waitListAttribute"];
    _confirmedUserList=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"confrimUsersAttribute"];
    appliedUserNumber=_appliedUserList.length/13;
    comfirmedUserNumber=_confirmedUserList.length/13;
    
    for(NSInteger i=0;i<appliedUserNumber;++i){
        NSLog(@"%@,%@,%@",[_appliedUserList substringWithRange:NSMakeRange(i*13+11, 1)],[_appliedUserList substringWithRange:NSMakeRange(i*13, 10)],_phoneNumber);
        if ([[_appliedUserList substringWithRange:NSMakeRange(i*13+11, 1)] isEqualToString:@"d"]) {
            if ([[_appliedUserList substringWithRange:NSMakeRange(i*13, 10)]isEqualToString:_phoneNumber]) {
                isDriver=YES;
            }
            [_applyDriver addObject:[_appliedUserList substringWithRange:NSMakeRange(i*13, 10)]];
        }else{
            if ([[_appliedUserList substringWithRange:NSMakeRange(i*13, 10)]isEqualToString:_phoneNumber]) {
                isPassenger=YES;
            }
            [_applyPassenger addObject:[_appliedUserList substringWithRange:NSMakeRange(i*13, 10)]];
        }
    }
    for(NSInteger i=0;i<comfirmedUserNumber;++i){
        if ([[_confirmedUserList substringWithRange:NSMakeRange(i*13+11, 1)] isEqualToString:@"d"]) {
            if ([[_confirmedUserList substringWithRange:NSMakeRange(i*13, 10)]isEqualToString:_phoneNumber]) {
                isDriver=YES;
            }
            [_confirmDriver addObject:[_confirmedUserList substringWithRange:NSMakeRange(i*13, 10)]];
        }else{
            if ([[_confirmedUserList substringWithRange:NSMakeRange(i*13, 10)]isEqualToString:_phoneNumber]) {
                isPassenger=YES;
            }
            [_confirmDriver addObject:[_confirmedUserList substringWithRange:NSMakeRange(i*13, 10)]];
        }
    }
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Event Detail"];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.frame=CGRectMake(20, 75, 280, 400);
    if ([_eventType isEqualToString:@"driver"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
    }
    if ([_eventType isEqualToString:@"passenger"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:137.0/255.0 blue:111.0/255.0 alpha:1.0];
    }
    if ([_eventType isEqualToString:@"undecided"]) {
        backgroundView.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0];
    }
    [self.view addSubview:backgroundView];
    
    UILabel *usernameLabel=[[UILabel alloc]init];
    [usernameLabel setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    usernameLabel.textAlignment=NSTextAlignmentCenter;
    usernameLabel.text=[_eventDetailInfo objectAtIndex:4];
    usernameLabel.frame=CGRectMake(90.0f, 20.0f, 190.0f, 40.0f);
    [backgroundView addSubview:usernameLabel];
    
    UITextField *eventTitleField=[[UITextField alloc]init];
    eventTitleField.textAlignment=NSTextAlignmentCenter;
    [eventTitleField setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    eventTitleField.text=[_eventDetailInfo objectAtIndex:0];
    eventTitleField.frame=CGRectMake(90.0f, 60.0f, 190.0f, 40.0f);
    eventTitleField.backgroundColor=[backgroundView backgroundColor];
    eventTitleField.enabled=NO;
    [backgroundView addSubview:eventTitleField];
    
    UILabel *eventTimeLabel=[[UILabel alloc]init];
    [eventTimeLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Italic" size:18.0f]];
    eventTimeLabel.text=[_eventDetailInfo objectAtIndex:1];
    eventTimeLabel.frame=CGRectMake(90.0f, 100.0f, 190.0f, 40.0f);
    [backgroundView addSubview:eventTimeLabel];
    
    UITextView *eventContentView=[[UITextView alloc]init];
    eventContentView.textAlignment=NSTextAlignmentCenter;
    [eventContentView setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    eventContentView.text=[_eventDetailInfo objectAtIndex:2];
    eventContentView.frame=CGRectMake(30.0f, 150.0f, 200.0f, 100.0f);
    eventContentView.backgroundColor=[backgroundView backgroundColor];
    eventContentView.selectable=NO;
    [backgroundView addSubview:eventContentView];
    
    if ([[_eventDetailInfo objectAtIndex:3] isEqual:@"inActive"]) {
        UILabel *disableLabel=[[UILabel alloc]init];
        [disableLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Italic" size:18.0f]];
        disableLabel.text=@"You can not join this event now.";
        disableLabel.frame=CGRectMake(20.0f, 270.0f, 270.0f, 40.0f);
        [backgroundView addSubview:disableLabel];
    } else {
        NSLog(@"Adding join button");
        UIButton *joinEventButton=[[UIButton alloc]init];
        joinEventButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [joinEventButton addTarget:self action:@selector(clickJoinEventButton:) forControlEvents:UIControlEventTouchUpInside];
        [joinEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[joinEventButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
        joinEventButton.frame=CGRectMake(35.0f, 320.0f, 250.0f, 40.0f);
        [joinEventButton setTitle:@"Join this event" forState:UIControlStateNormal];
        [joinEventButton setBackgroundColor:[UIColor grayColor]];
        /*CAGradientLayer *btnGradient = [CAGradientLayer layer];
         btnGradient.frame = loginButton.bounds;
         btnGradient.colors = [NSArray arrayWithObjects:
         (id)[[UIColor colorWithRed:217.0f / 255.0f green:211.0f / 255.0f blue:219.0f / 255.0f alpha:1.0f] CGColor],
         (id)[[UIColor colorWithRed:151.0f / 255.0f green:151.0f / 255.0f blue:151.0f / 255.0f alpha:1.0f] CGColor],
         nil];*/
        CALayer *btnLayer = [joinEventButton layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:5.0f];
        //[loginButton.layer insertSublayer:btnGradient atIndex:0];
        [btnLayer setBorderWidth:1.0f];
        [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [self.view addSubview:joinEventButton];
    }
}

-(void)clickJoinEventButton:(id)sender{
    BOOL couldJoin=YES;
    if (isEventHolder) {
        couldJoin=NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You are the event holder, you can't contact yourself" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    if(isPassenger || isDriver){
        couldJoin=NO;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You have already join this event." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    if(couldJoin){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you going to join as a driver or passenger?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Driver",@"Passenger", nil];
        alert.tag=1;
        [alert show];
    }
}

-(void)clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        NSLog(@"%@",_eventDetailInfo[5]);
        if (buttonIndex==1) {
            NSLog(@"Join as a driver");
            _identity=@"-d/";
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Contact event holder" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Text",@"Call", nil];
            alert.tag=2;
            [alert show];
        }
        if (buttonIndex==2) {
            NSLog(@"Join as a passenger");
            _identity=@"-p/";
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Contact event holder" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Text",@"Call", nil];
            alert.tag=2;
            [alert show];
        }
    }
    if(alertView.tag==2){
        if (buttonIndex==2) {
            NSLog(@"Choose to call %@.",_eventPhoneNumber);
            NSString *URL=[NSString stringWithFormat:@"tel:%@",_eventPhoneNumber];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (buttonIndex==1) {
            NSLog(@"Choose to send message to %@.",_eventPhoneNumber);
            [self showSMS];
        }
        sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
        sdbClient.endpoint=@"http://sdb.amazonaws.com";
        _contactEventList=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute"];
        [self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"waitListAttribute" Value:[NSString stringWithFormat:@"%@%@%@",_appliedUserList,_phoneNumber,_identity]];
        NSLog(@"%@%@/",_contactEventList,_eventId);
        [self updateAttribute:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute" Value:[NSString stringWithFormat:@"%@%@/",_contactEventList,_eventId]];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:{
            UIAlertView *warningAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to send SMS" delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [warningAlert show];
            //[self addCurrentEventToContactEvent];
            break;
        }
        case MessageComposeResultSent:
            //[self addCurrentEventToContactEvent];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showSMS{
    if(![MFMessageComposeViewController canSendText]){
        UIAlertView *warningAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Your device doesn't support SMS" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [warningAlert show];
        return;
    }
    NSArray *recipents=@[_eventPhoneNumber];
    MFMessageComposeViewController *messageController=[[MFMessageComposeViewController alloc]init];
    messageController.messageComposeDelegate=self;
    [messageController setRecipients:recipents];
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)updateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSMutableArray *attribList=[[NSMutableArray alloc]init];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:attrib.name andValue:attrib.value andReplace:YES];
            NSLog(@"%@,%@",attrib1.name,attrib1.value);
            if ([attrib.name isEqualToString:attributeName]) {
                attrib1.value=value;
            }
            NSLog(@"%@,%@",attrib1.name,attrib1.value);
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
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
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
