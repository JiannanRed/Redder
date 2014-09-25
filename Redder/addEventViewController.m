//
//  addEventViewController.m
//  Redder
//
//  Created by Jiannan on 9/13/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "addEventViewController.h"

@interface addEventViewController ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation addEventViewController
@synthesize eventDateLabel;
@synthesize datepicker,parentViewController,picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"addEventView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Start to load addEventView with type %@",_eventType);
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    _phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    _userName=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"usernameAttribute"];
    _usernameLabel.text=_userName;
    _eventType=@"undecided";
    
    // Do any additional setup after loading the view.
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(clickDoneButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Add Event"];
    navigItem.leftBarButtonItem=cancelButton;
    navigItem.rightBarButtonItem=doneButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
}

-(void)clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickDoneButton{
    BOOL continues=TRUE;
    if ([_titleTextView.text isEqualToString: @"Edit Event Title"] || [_titleTextView.text isEqualToString: @""]) {
        continues=FALSE;
    }
    if ([_contentTextView.text isEqualToString: @"Edit Event Content(Optional)"]) {
        continues=FALSE;
    }
    if(self.eventTimeLabel.text.length==0 && self.eventDateLabel.text.length==0){
        continues=FALSE;
    }
    if(!continues){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please Check" message:@"Some items are incompleted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        if (self.eventDateLabel.text.length>0 && self.eventTimeLabel.text.length>0) {
            self.finalDateString=[NSString stringWithFormat:@"%@ %@",self.finalDateStringPart1,self.finalDateStringPart2];
        }
        NSLog(@"Start to add event to DataBase.");
        sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
        sdbClient.endpoint=@"http://sdb.amazonaws.com";
        NSString *domainName=[[NSString alloc]init];
        domainName=@"eventTable";
        SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:@"activeStatusAttribute" andValue:@"active" andReplace:YES];
        SimpleDBReplaceableAttribute *attrib2=[[SimpleDBReplaceableAttribute alloc]initWithName:@"postUsernameAttribute" andValue:_userName andReplace:YES];
        SimpleDBReplaceableAttribute *attrib3=[[SimpleDBReplaceableAttribute alloc]initWithName:@"eventDateAttribute" andValue:_finalDateString andReplace:YES];
        SimpleDBReplaceableAttribute *attrib4=[[SimpleDBReplaceableAttribute alloc]initWithName:@"eventTitleAttribute" andValue:_titleTextView.text andReplace:YES];
        SimpleDBReplaceableAttribute *attrib5=[[SimpleDBReplaceableAttribute alloc]initWithName:@"eventContentAttribute" andValue:_contentTextView.text andReplace:YES];
        SimpleDBReplaceableAttribute *attrib6=[[SimpleDBReplaceableAttribute alloc]initWithName:@"eventTypeAttribute" andValue:_eventType andReplace:YES];
        SimpleDBReplaceableAttribute *attrib7=[[SimpleDBReplaceableAttribute alloc]initWithName:@"confirmUsersAttribute" andValue:@"" andReplace:YES];
        SimpleDBReplaceableAttribute *attrib8=[[SimpleDBReplaceableAttribute alloc]initWithName:@"waitListAttribute" andValue:@"" andReplace:YES];
        SimpleDBReplaceableAttribute *attrib9=[[SimpleDBReplaceableAttribute alloc]initWithName:@"Name" andValue:@"Value" andReplace:YES];
        //SimpleDBReplaceableAttribute *attrib10=[[SimpleDBReplaceableAttribute alloc]initWithName:@"Name" andValue:@"Value" andReplace:YES];
        NSMutableArray *attribList=[[NSMutableArray alloc]initWithObjects:attrib1, attrib2,attrib3,attrib4,attrib5,attrib6,attrib7,attrib8,attrib9, nil];
        _maxIndex=[self getAttributeValue:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"myEventIndexAttribute"];
        _itemName=[NSString stringWithFormat:@"%@-%@",_phoneNumber,_maxIndex];
        SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:_itemName andAttributes:attribList];
        SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
        _maxIndex=[NSString stringWithFormat:@"%d",[_maxIndex intValue]+1];
        [self updateAttribute:sdbClient domain:@"accountTable" item:_phoneNumber attribute:@"myEventIndexAttribute" Value:_maxIndex];
        if(putResponse.exception==nil){
            NSLog(@"Attributes updated");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Have posted the event" message:@"" delegate:self
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        }else{
            NSLog(@"error updating attributes:%@",putResponse.exception);
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseDecideDateButton:(id)sender {
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select Date", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    datepicker=[[UIDatePicker alloc]init];
    datepicker.datePickerMode=UIDatePickerModeDate;
    sheet.tag=0;
    [datepicker setDate:[NSDate date]];
    [sheet addSubview:datepicker];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0 && actionSheet.tag==0) {
        NSDate *date=datepicker.date;
        [eventDateLabel setText:[self getFinalDateStringFromDate:date]];
    }
    if (buttonIndex==0 && actionSheet.tag==1) {
        NSDate *date=datepicker.date;
        [_eventTimeLabel setText:[self getFinalTimeStringFromDate:date]];
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
    NSString *dateString=[dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"yy/MM/dd"];
    NSString *dateString1=[dateFormatter stringFromDate:date];
    self.finalDateStringPart1=[NSString stringWithFormat:@"%@, %@", [weekDay substringWithRange:NSMakeRange(0, 3)],dateString1];
    return [NSString stringWithFormat:@"%@, %@", [weekDay substringWithRange:NSMakeRange(0, 3)],dateString];
}

- (IBAction)chooseDecideTimeButton:(id)sender {
    NSString *title=UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)? @"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n\n";
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",title,NSLocalizedString(@"Select Time", @"")] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done",nil, nil];
    [sheet showInView:self.view];
    datepicker=[[UIDatePicker alloc]init];
    datepicker.datePickerMode=UIDatePickerModeTime;
    sheet.tag=1;
    [datepicker setDate:[NSDate date]];
    [sheet addSubview:datepicker];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2) {
        if(buttonIndex==0){
            _driverOrPassengerLabel.text=@"Undecided";
            _eventType=@"undecided";
            _eventBackgroundView.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0];
        }
        if(buttonIndex==1){
            _driverOrPassengerLabel.text=@"Driver";
            _eventType=@"driver";
            _eventBackgroundView.backgroundColor=[UIColor colorWithRed:183.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
        }
        if(buttonIndex==2){
            _driverOrPassengerLabel.text=@"Passenger";
            _eventType=@"passenger";
            _eventBackgroundView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:137.0/255.0 blue:111.0/255.0 alpha:1.0];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)chooseDriverOrPassengerButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you going to post this event as a driver or a passenger?" message:@"" delegate:self cancelButtonTitle:@"Undecided" otherButtonTitles:@"Driver",@"Passenger",nil];
    alert.tag=2;
    [alert show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches]anyObject];
    if([_titleTextView isFirstResponder] && [touch view]!=_titleTextView){
        [_titleTextView resignFirstResponder];
    }
    if([_contentTextView isFirstResponder] && [touch view]!=_contentTextView){
        [_contentTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

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
    return @"Not found";
}

@end
