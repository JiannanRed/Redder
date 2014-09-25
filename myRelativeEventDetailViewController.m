//
//  myRelativeEventDetailViewController.m
//  Redder
//
//  Created by Jiannan on 9/16/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "myRelativeEventDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface myRelativeEventDetailViewController ()<MFMessageComposeViewControllerDelegate>

@end

NSInteger appliedUserNumber,comfirmedUserNumber;
BOOL isDriver,isPassenger,isEventHolder;

@implementation myRelativeEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"myRelativeEventDetailView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Start to load myRelativeEventDetailViewController");
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Event Detail"];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    _phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    _eventPhoneNumber=[[_eventDetailInfo objectAtIndex:5] substringWithRange:NSMakeRange(0, 10)];
    if ([_phoneNumber isEqualToString:_eventPhoneNumber]) {
        isEventHolder=YES;
    }
    _eventId=[_eventDetailInfo objectAtIndex:5];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _appliedUserString=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"waitListAttribute"];
    _confirmedUserString=[self getAttributeValue:sdbClient domain:@"eventTable" item:_eventId attribute:@"confrimUsersAttribute"];
    appliedUserNumber=_appliedUserString.length/13;
    comfirmedUserNumber=_confirmedUserString.length/13;
    
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.frame=CGRectMake(20, 75, 280, 450);
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
    
    NSLog(@"Contact event holder button");
    UIButton *contactEventHolderButton=[[UIButton alloc]init];
    contactEventHolderButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [contactEventHolderButton addTarget:self action:@selector(clickcontactEventHolderButton:) forControlEvents:UIControlEventTouchUpInside];
    [contactEventHolderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactEventHolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[contactEventHolderButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    contactEventHolderButton.frame=CGRectMake(35.0f, 320.0f, 250.0f, 40.0f);
    [contactEventHolderButton setTitle:@"Contact Event Holder" forState:UIControlStateNormal];
    [contactEventHolderButton setBackgroundColor:[UIColor grayColor]];
    /*CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = loginButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
    (id)[[UIColor colorWithRed:217.0f / 255.0f green:211.0f / 255.0f blue:219.0f / 255.0f alpha:1.0f] CGColor],
    (id)[[UIColor colorWithRed:151.0f / 255.0f green:151.0f / 255.0f blue:151.0f / 255.0f alpha:1.0f] CGColor],
         nil];*/
    CALayer *btnLayer = [contactEventHolderButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    //[loginButton.layer insertSublayer:btnGradient atIndex:0];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:contactEventHolderButton];
    
    NSLog(@"Contact quit event button");
    UIButton *quitEventButton=[[UIButton alloc]init];
    quitEventButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [quitEventButton addTarget:self action:@selector(clickQuitEventButton:) forControlEvents:UIControlEventTouchUpInside];
    [quitEventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[quitEventButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    quitEventButton.frame=CGRectMake(35.0f, 380.0f, 250.0f, 40.0f);
    [quitEventButton setTitle:@"Quit Event" forState:UIControlStateNormal];
    [quitEventButton setBackgroundColor:[UIColor grayColor]];
    /*CAGradientLayer *btnGradient = [CAGradientLayer layer];
     btnGradient.frame = loginButton.bounds;
     btnGradient.colors = [NSArray arrayWithObjects:
     (id)[[UIColor colorWithRed:217.0f / 255.0f green:211.0f / 255.0f blue:219.0f / 255.0f alpha:1.0f] CGColor],
     (id)[[UIColor colorWithRed:151.0f / 255.0f green:151.0f / 255.0f blue:151.0f / 255.0f alpha:1.0f] CGColor],
     nil];*/
    btnLayer = [quitEventButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    //[loginButton.layer insertSublayer:btnGradient atIndex:0];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:quitEventButton];
}

-(void)clickQuitEventButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to quit this event?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=2;
    [alert show];
}

-(void)clickcontactEventHolderButton:(id)sender{
    if (isEventHolder) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You are the event holder, you can't contact yourself" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Text",@"Call", nil];
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
    if (alertView.tag==2) {
        NSLog(@"%@",_eventDetailInfo[5]);
        BOOL isApplyUser,isConfirmUser;
        _updateAppliedUserList=@"";
        _updateConfirmUserList=@"";
        isApplyUser=NO;
        isConfirmUser=NO;
        if (buttonIndex==1) {
            for (NSInteger i=0; i<appliedUserNumber; ++i) {
                if (![[_appliedUserString substringWithRange:NSMakeRange(i*13, 10)] isEqualToString:_phoneNumber]) {
                    _updateAppliedUserList=[NSString stringWithFormat:@"%@%@",_updateAppliedUserList,[_appliedUserString substringWithRange:NSMakeRange(i*13, 13)]];
                }else{
                    isApplyUser=YES;
                }
            }
            for (NSInteger i=0; i<comfirmedUserNumber; ++i) {
                if (![[_confirmedUserString substringWithRange:NSMakeRange(i*13, 10)] isEqualToString:_phoneNumber]) {
                    _updateConfirmUserList=[NSString stringWithFormat:@"%@%@",_updateConfirmUserList,[_confirmedUserString substringWithRange:NSMakeRange(i*13, 13)]];
                }else{
                    isConfirmUser=YES;
                }
            }
            NSLog(@"update waitlist to%@",_updateAppliedUserList);
            NSLog(@"update confirm users to%@",_updateConfirmUserList);
            sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
            sdbClient.endpoint=@"http://sdb.amazonaws.com";
            if(isApplyUser){
                [self updateAttribute:sdbClient domain:@"eventTable" item:_eventDetailInfo[5] attribute:@"waitListAttribute" Value:_updateAppliedUserList];
                [self updateContactEventAttribute];
            }
            if(isConfirmUser){
                [self updateAttribute:sdbClient domain:@"eventTable" item:_eventDetailInfo[5] attribute:@"confirmUsersAttribute" Value:_updateConfirmUserList];
                [self updateConfirmEventAttribute];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if(alertView.tag==1){
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
        //sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
        //sdbClient.endpoint=@"http://sdb.amazonaws.com";
        //_contactEventString=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute"];
        //[self updateAttribute:sdbClient domain:@"eventTable" item:_eventId attribute:@"waitListAttribute" Value:[NSString stringWithFormat:@"%@%@%@",_appliedUserString,_phoneNumber,_identity]];
        //[self updateAttribute:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute" Value:[NSString stringWithFormat:@"%@%@/",_contactEventString,_eventId]];
    }
}

-(void)updateContactEventAttribute{
    NSString *updateContactEventString=@"";
    _contactEventString=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute"];
    _contactEventList=[self parseEventString:_contactEventString];
    for (NSInteger i=0; i<_contactEventList.count; ++i) {
        if (![[_contactEventList objectAtIndex:i] isEqualToString:_eventId]) {
            updateContactEventString=[NSString stringWithFormat:@"%@%@/",updateContactEventString,[_contactEventList objectAtIndex:i]];
        }
    }
    NSLog(@"Update contactEventAttribute to:%@",updateContactEventString);
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    [self updateAttribute:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"contactEventsAttribute" Value:updateContactEventString];
}

-(void)updateConfirmEventAttribute{
    NSString *updateConfirmEventString=@"";
    _confirmEventString=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"confirmEventsAttribute"];
    _confirmEventList=[self parseEventString:_confirmEventString];
    for (NSInteger i=0; i<_confirmEventList.count; ++i) {
        if (![[_confirmEventList objectAtIndex:i] isEqualToString:_eventId]) {
            updateConfirmEventString=[NSString stringWithFormat:@"%@%@/",updateConfirmEventString,[_confirmEventList objectAtIndex:i]];
        }
    }
    NSLog(@"Update contactEventAttribute to:%@",updateConfirmEventString);
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    [self updateAttribute:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"confirmEventsAttribute" Value:updateConfirmEventString];
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
