//
//  signinViewController.m
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "signinViewController.h"

/*NSString *twilioAccount = @"********";
NSString *twilioAuth = @"********";
NSString *twilioNumber = @"********";*/
int confirmation;

@interface signinViewController ()

@end

@implementation signinViewController
@synthesize phoneNumberText,sendCodeButton,securityLoginButton,securityCodeText,passwordText,loginButton,phoneNumber,password,username,forgetPasswordButton,myEventIndex,activityIndicator,backButton,Account,Auth,Number;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"signInView" forKey:@"fromWhere"];
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}

- (void)viewDidLoad
{
    Account = @"********";
    Auth = @"********";
    Number = @"********";
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    activityIndicator.hidden=NO;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    [super viewDidLoad];
    phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    password=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    // Do any additional setup after loading the view.
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Login"];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    sendCodeButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendCodeButton addTarget:self action:@selector(clickSendCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendCodeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[sendCodeButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:12.0f]];
    sendCodeButton.frame=CGRectMake(35.0f, 220.0f, 250.0f, 40.0f);
    [sendCodeButton setTitle:@"Send Confirmation Code" forState:UIControlStateNormal];
    [sendCodeButton setBackgroundColor:[UIColor grayColor]];
    CALayer *btnLayer = [sendCodeButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor grayColor] CGColor]];
    sendCodeButton.hidden=YES;
    [self.view addSubview:sendCodeButton];
    
    securityLoginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [securityLoginButton addTarget:self action:@selector(clickSecurityLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [securityLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [securityLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [[securityLoginButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    securityLoginButton.frame=CGRectMake(35.0f, 270.0f, 250.0f, 40.0f);
    [securityLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [securityLoginButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [securityLoginButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    securityLoginButton.hidden=YES;
    [self.view addSubview:securityLoginButton];
    
    backButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [[backButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:12.0f]];
    backButton.frame=CGRectMake(35.0f, 320.0f, 250.0f, 40.0f);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [backButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor grayColor] CGColor]];
    backButton.hidden=YES;
    [self.view addSubview:backButton];
    
    securityCodeText=[[UITextField alloc]init];
    [securityCodeText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [securityCodeText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    securityCodeText.placeholder=@"Confirmation Code";
    securityCodeText.borderStyle=UITextBorderStyleRoundedRect;
    securityCodeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    securityCodeText.keyboardType=UIKeyboardTypePhonePad;
    securityCodeText.frame=CGRectMake(35.0f, 150.0f, 250.0f, 40.0f);
    securityCodeText.hidden=YES;
    [self.view addSubview:securityCodeText];
    
    phoneNumberText=[[UITextField alloc]init];
    [phoneNumberText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [phoneNumberText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    phoneNumberText.placeholder=@"Phone Number";
    phoneNumberText.borderStyle=UITextBorderStyleRoundedRect;
    phoneNumberText.clearButtonMode=UITextFieldViewModeWhileEditing;
    phoneNumberText.keyboardType=UIKeyboardTypePhonePad;
    phoneNumberText.frame=CGRectMake(35.0f, 100.0f, 250.0f, 40.0f);
    [self.view addSubview:phoneNumberText];
    
    passwordText=[[UITextField alloc]init];
    [passwordText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    passwordText.placeholder=@"Password";
    passwordText.borderStyle=UITextBorderStyleRoundedRect;
    passwordText.secureTextEntry=YES;
    passwordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordText.frame=CGRectMake(35.0f, 150.0f, 250.0f, 40.0f);
    [self.view addSubview:passwordText];
    
    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[loginButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    loginButton.frame=CGRectMake(35.0f, 220.0f, 250.0f, 40.0f);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [loginButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:loginButton];
    
    forgetPasswordButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[forgetPasswordButton titleLabel] setFont:[UIFont fontWithName:@"RobotoCondensed" size:12.0f]];
    [forgetPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    forgetPasswordButton.frame=CGRectMake(170.0f, 280.0f, 130.0f, 20.0f);
    [forgetPasswordButton setTitle:@"forget password?" forState:UIControlStateNormal];
    CALayer *btnLayer1 = [forgetPasswordButton layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [btnLayer1 setBorderWidth:1.0f];
    [btnLayer1 setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.view addSubview:forgetPasswordButton];
}

-(void) clickSendCodeButton:(id)sender{
    UIAlertView *alert;
    if (phoneNumberText.text.length!=10) {
        alert=[[UIAlertView alloc]initWithTitle:@"Phone number format is wrong." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (![self accountExist]) {
            alert=[[UIAlertView alloc]initWithTitle:@"Account does not exist." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self sendMessage:phoneNumberText.text];
        }
    }
}

-(void)clickSecurityLoginButton{
    UIAlertView *alert;
    if (phoneNumberText.text.length<10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Phone number is wrong!" delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (![self accountExist]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Account does not exist!" delegate:self
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if ([securityCodeText.text intValue]==confirmation) {
                [self secureLogin];
            }else{
                alert=[[UIAlertView alloc]initWithTitle:@"Confirmation is wrong." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
            }
        }
    }
    
}

-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void) clickForgetPasswordButton:(id)sender{
    passwordText.hidden=YES;
    forgetPasswordButton.hidden=YES;
    loginButton.hidden=YES;
    sendCodeButton.hidden=NO;
    securityCodeText.hidden=NO;
    backButton.hidden=NO;
    securityLoginButton.hidden=NO;
}

-(void) clickBackButton:(id)sender{
    passwordText.hidden=NO;
    forgetPasswordButton.hidden=NO;
    loginButton.hidden=NO;
    sendCodeButton.hidden=YES;
    securityCodeText.hidden=YES;
    backButton.hidden=YES;
    securityLoginButton.hidden=YES;
}

-(void) clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clickLoginButton:(id)sender{
    if (phoneNumberText.text.length<10) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please input phone number!" delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if ([passwordText.text isEqualToString:@""]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please input password!" delegate:self
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            [self login];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)login{
    NSString *domainName=[[NSString alloc]initWithFormat:@"accountTable"];
    phoneNumber=phoneNumberText.text;
    password=passwordText.text;
    BOOL accountExist=NO;
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:phoneNumber];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            if ([attrib.name isEqualToString:@"passwordAttribute"] && [attrib.value isEqualToString:password]) {
                accountExist=YES;
            }
            if([attrib.name isEqualToString:@"usernameAttribute"]){
                username=attrib.value;
            }
            if([attrib.name isEqualToString:@"myEventIndexAttribute"]){
                myEventIndex=attrib.value;
            }
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    if (accountExist==NO) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Phone number or password is wrong!" delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:phoneNumber forKey:@"phoneNumber"];
        [[NSUserDefaults standardUserDefaults]setValue:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setValue:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setValue:myEventIndex forKey:@"myEventIndexAttribute"];
        NSLog(@"log in as %@",username);
        [[NSUserDefaults standardUserDefaults]setValue:@"mainView" forKey:@"fromWhere"];
        
        eventPoolTabBarViewController *eventPoolTabBarView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventPoolTabBarView"];
        eventPoolTabBarView.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:eventPoolTabBarView animated:YES completion:nil];
    }
}

-(void)secureLogin{
    NSString *domainName=[[NSString alloc]initWithFormat:@"accountTable"];
    phoneNumber=phoneNumberText.text;
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:phoneNumber];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            if([attrib.name isEqualToString:@"usernameAttribute"]){
                username=attrib.value;
            }
            if([attrib.name isEqualToString:@"myEventIndexAttribute"]){
                myEventIndex=attrib.value;
            }
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    [[NSUserDefaults standardUserDefaults]setValue:phoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults]setValue:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]setValue:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setValue:myEventIndex forKey:@"myEventIndexAttribute"];
    NSLog(@"log in as %@",username);
    [[NSUserDefaults standardUserDefaults]setValue:@"mainView" forKey:@"fromWhere"];
        
    eventPoolTabBarViewController *eventPoolTabBarView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventPoolTabBarView"];
    eventPoolTabBarView.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:eventPoolTabBarView animated:YES completion:nil];
}

-(BOOL)accountExist{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSString *domainName=[[NSString alloc]initWithFormat:@"accountTable"];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:phoneNumberText.text];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        NSLog(@"%lu Attribute values found",(unsigned long)[getResponse.attributes count]);
        if ((unsigned long)[getResponse.attributes count]>0) {
            NSLog(@"account exists");
            return YES;
        }else{
            NSLog(@"This user %@ does not exist.",phoneNumberText.text);
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    return NO;
}

- (void)sendMessage:(NSString *) userPhoneNumber {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages",Account,Auth,Account];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    confirmation = (arc4random() % (9000)) + 1000;
    NSString *textContent = [NSString stringWithFormat:@"Hello from Redder! Your confirmation code IS: %d", confirmation];
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", Number,userPhoneNumber,textContent];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSLog(@"%@", receivedData.description);
    }
}

@end
