//
//  myAccountViewController.m
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "myAccountViewController.h"

@interface myAccountViewController ()

@end

@implementation myAccountViewController
@synthesize logoutButton,usernameButton,fromWhere,username,phoneNumber,eventID,passwordButton,reportIssueButton,suggestionButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"myAccountView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    username=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My  Account"];
    navigItem.leftBarButtonItem=backButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    [super viewDidLoad];
    fromWhere=[[NSUserDefaults standardUserDefaults]stringForKey:@"fromWhere"];
    // Do any additional setup after loading the view.
    
    NSLog(@"Add username button");
    usernameButton=[[UIButton alloc]init];
    usernameButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [usernameButton addTarget:self action:@selector(clickUsernameButton:) forControlEvents:UIControlEventTouchUpInside];
    [usernameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [usernameButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[usernameButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    usernameButton.frame=CGRectMake(30.0f, 150.0f, 260.0f, 40.0f);
    [usernameButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal];
    [usernameButton setBackgroundColor:[UIColor whiteColor]];
    CALayer *btnLayer = [usernameButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:usernameButton];
    
    NSLog(@"Add password button");
    passwordButton=[[UIButton alloc]init];
    passwordButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [passwordButton addTarget:self action:@selector(clickPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [passwordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [passwordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [[passwordButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    passwordButton.frame=CGRectMake(30.0f, 250.0f, 260.0f, 40.0f);
    [passwordButton setTitle:@"Reset Password" forState:UIControlStateNormal];
    [passwordButton setBackgroundColor:[UIColor whiteColor]];
    btnLayer = [passwordButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:passwordButton];
    
    suggestionButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [suggestionButton addTarget:self action:@selector(clickSuggestionButton:) forControlEvents:UIControlEventTouchUpInside];
    [suggestionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [suggestionButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[suggestionButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    suggestionButton.frame=CGRectMake(35.0f, 350.0f, 250.0f, 40.0f);
    [suggestionButton setTitle:@"Suggestion" forState:UIControlStateNormal];
    [suggestionButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [suggestionButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:suggestionButton];
    
    reportIssueButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reportIssueButton addTarget:self action:@selector(clickReportIssueButton:) forControlEvents:UIControlEventTouchUpInside];
    [reportIssueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportIssueButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[reportIssueButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    reportIssueButton.frame=CGRectMake(35.0f, 400.0f, 250.0f, 40.0f);
    [reportIssueButton setTitle:@"Report An Issue" forState:UIControlStateNormal];
    [reportIssueButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [reportIssueButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:reportIssueButton];
    
    logoutButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logoutButton addTarget:self action:@selector(clicklogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[logoutButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    logoutButton.frame=CGRectMake(35.0f, 450.0f, 250.0f, 40.0f);
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [logoutButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:logoutButton];
}

-(void)clickSuggestionButton:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:@[@"redderlance@gmail.com"]];
        [mailViewController setSubject:@"Give a suggestion"];
        [mailViewController setMessageBody:@"\n\n\n\n App Version:1.0" isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

-(void)clickReportIssueButton:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:@[@"redderlance@gmail.com"]];
        [mailViewController setSubject:@"Report an issue"];
        [mailViewController setMessageBody:@"\n\n\n\n App Version:1.0" isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickUsernameButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Edit username" message:@"Input new username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag=1;
    [alert show];
}

-(void)clickPasswordButton:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Edit password" message:@"Input new password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder=@"password";
    [alert textFieldAtIndex:0].secureTextEntry=YES;
    [alert textFieldAtIndex:1].placeholder=@"re-enter password";
    alert.tag=2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        if(buttonIndex==1){
            if ([alertView textFieldAtIndex:0].text.length>0) {
                [self updateAttribute:sdbClient domain:@"accountTable" item:phoneNumber attribute:@"usernameAttribute" Value:[alertView textFieldAtIndex:0].text];
                [usernameButton setTitle:[alertView textFieldAtIndex:0].text forState:UIControlStateNormal];
                [self loadEventData];
                for (NSInteger i=0; i<eventID.count; ++i) {
                    [self updateAttribute:sdbClient domain:@"eventTable" item:[eventID objectAtIndex:i] attribute:@"postUsernameAttribute" Value:[alertView textFieldAtIndex:0].text];
                }
            }
        }
    }
    if(alertView.tag==2 && buttonIndex==1){
        if ([[alertView textFieldAtIndex:0].text isEqualToString:[alertView textFieldAtIndex:1].text]) {
            [self updateAttribute:sdbClient domain:@"accountTable" item:phoneNumber attribute:@"passwordAttribute" Value:[alertView textFieldAtIndex:0].text];
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password does not match" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clicklogoutButton:(id)sender{
    [[NSUserDefaults standardUserDefaults]setValue:@"myAccountViewLogout" forKey:@"fromWhere"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadEventData{
    eventID=[[NSMutableArray alloc]init];
    NSLog(@"Start to load event information from database in my account collection view.\n\n");
    
    NSString *domainName=[[NSString alloc]initWithFormat:@"eventTable"];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *selectExpression=[NSString stringWithFormat:@"select postUsernameAttribute from %@",domainName];
    SimpleDBSelectRequest *selectRequest1=[[SimpleDBSelectRequest alloc]initWithSelectExpression:selectExpression andConsistentRead:YES];
    //selectRequest1.nextToken=nextToken;
    SimpleDBSelectResponse *select1Response=[sdbClient select:selectRequest1];
    for (SimpleDBItem *item in select1Response.items){
        if ([phoneNumber isEqualToString:[item.name substringWithRange:NSMakeRange(0, 10)]]) {
            [eventID addObject:(id)item.name];
        }
    }
    NSLog(@"Finish load data from dataBase in my Account View");
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

@end
