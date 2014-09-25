//
//  registerViewController.m
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "registerViewController.h"

NSString *twilioAccount = @"********";
NSString *twilioAuth = @"********";
NSString *twilioNumber = @"********";
int confirmation;

@interface registerViewController ()

@end

@implementation registerViewController
@synthesize phoneNumberText,usernameText,passwordText,rePasswordText,confirmationText,submitButton,imageButton,sendConfirmationButton,backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"registerView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor lightGrayColor];
    
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"Register"];
    navigItem.leftBarButtonItem=cancelButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    
    imageButton=[[UIButton alloc]init];
    imageButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imageButton addTarget:self action:@selector(clickImageButton) forControlEvents:UIControlEventTouchUpInside];
    [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [[imageButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:10.0f]];
    [imageButton setTitle:@"" forState:UIControlStateNormal];
    [imageButton setBackgroundColor:[UIColor whiteColor]];
    imageButton.frame=CGRectMake(35.0f, 100.0f, 90.0f, 90.0f);
    [imageButton setBackgroundImage:[UIImage imageNamed:@"defaultPhoto.png"] forState:UIControlStateNormal];
    CALayer *btnLayer = [imageButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    //[self.view addSubview:imageButton];
    
    confirmationText=[[UITextField alloc]init];
    [confirmationText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [confirmationText addTarget:self action:@selector(showPhoneFormatAlert) forControlEvents:UIControlEventAllTouchEvents];
    [confirmationText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    confirmationText.placeholder=@"Comfirmation Code";
    confirmationText.borderStyle=UITextBorderStyleRoundedRect;
    confirmationText.clearButtonMode=UITextFieldViewModeWhileEditing;
    confirmationText.keyboardType=UIKeyboardTypePhonePad;
    confirmationText.frame=CGRectMake(35.0f, 200.0f, 250.0f, 40.0f);
    confirmationText.hidden=YES;
    [self.view addSubview:confirmationText];
    
    phoneNumberText=[[UITextField alloc]init];
    [phoneNumberText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [phoneNumberText addTarget:self action:@selector(showPhoneFormatAlert) forControlEvents:UIControlEventAllTouchEvents];
    [phoneNumberText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    phoneNumberText.placeholder=@"Phone Number";
    phoneNumberText.borderStyle=UITextBorderStyleRoundedRect;
    phoneNumberText.clearButtonMode=UITextFieldViewModeWhileEditing;
    phoneNumberText.keyboardType=UIKeyboardTypePhonePad;
    phoneNumberText.frame=CGRectMake(35.0f, 100.0f, 250.0f, 40.0f);
    [self.view addSubview:phoneNumberText];
    
    usernameText=[[UITextField alloc]init];
    [usernameText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [usernameText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    usernameText.placeholder=@"Username";
    usernameText.borderStyle=UITextBorderStyleRoundedRect;
    usernameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    usernameText.frame=CGRectMake(35.0f, 150.0f, 250.0f, 40.0f);
    [self.view addSubview:usernameText];
    
    passwordText=[[UITextField alloc]init];
    [passwordText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    passwordText.placeholder=@"Password";
    passwordText.borderStyle=UITextBorderStyleRoundedRect;
    passwordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordText.secureTextEntry=YES;
    passwordText.frame=CGRectMake(35.0f, 200.0f, 250.0f, 40.0f);
    [self.view addSubview:passwordText];
    
    rePasswordText=[[UITextField alloc]init];
    [rePasswordText addTarget:self action:@selector(textFieldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [rePasswordText setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    rePasswordText.placeholder=@"Re-enter Password";
    rePasswordText.borderStyle=UITextBorderStyleRoundedRect;
    rePasswordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    rePasswordText.secureTextEntry=YES;
    rePasswordText.frame=CGRectMake(35.0f, 250.0f, 250.0f, 40.0f);
    [self.view addSubview:rePasswordText];
    
    sendConfirmationButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendConfirmationButton addTarget:self action:@selector(clickSendConfirmationButton) forControlEvents:UIControlEventTouchUpInside];
    [sendConfirmationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendConfirmationButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[sendConfirmationButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    sendConfirmationButton.frame=CGRectMake(35.0f, 330.0f, 250.0f, 40.0f);
    [sendConfirmationButton setTitle:@"Send Confirmation" forState:UIControlStateNormal];
    [sendConfirmationButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [sendConfirmationButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:sendConfirmationButton];
    
    submitButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[submitButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    submitButton.frame=CGRectMake(35.0f, 330.0f, 250.0f, 40.0f);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [submitButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    submitButton.hidden=YES;
    [self.view addSubview:submitButton];
    
    backButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[backButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    backButton.frame=CGRectMake(35.0f, 400.0f, 250.0f, 40.0f);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor grayColor]];
    btnLayer = [backButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    backButton.hidden=YES;
    [self.view addSubview:backButton];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
}

-(void)clickSendConfirmationButton{
    if([self couldContinue]){
        phoneNumberText.hidden=YES;
        usernameText.hidden=YES;
        passwordText.hidden=YES;
        rePasswordText.hidden=YES;
        sendConfirmationButton.hidden=YES;
        confirmationText.hidden=NO;
        submitButton.hidden=NO;
        backButton.hidden=NO;
        [self sendMessage:phoneNumberText.text];
    }
}

-(void)clickSubmitButton:(id)sender{
    if([confirmationText.text intValue]==confirmation){
        [self addNewUser];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation Number is wrong" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)clickBackButton{
    phoneNumberText.hidden=NO;
    usernameText.hidden=NO;
    passwordText.hidden=NO;
    rePasswordText.hidden=NO;
    sendConfirmationButton.hidden=NO;
    confirmationText.hidden=YES;
    submitButton.hidden=YES;
    backButton.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickImageButton{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Choose Photo" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Choose From Library",@"Take New Photo", nil];
    alert.tag=2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2){
        if (buttonIndex==1) {
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }
        if(buttonIndex==2){
            UIImagePickerController *picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    UIImage *selectedImage=image;
    [self.imageButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPhoneFormatAlert{
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input phone number without format as 7651111234." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
}

-(void)clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)addNewUser{
    BOOL continues=NO;
    NSLog(@"Start to add this user to database.");
    NSString *domainName=[[NSString alloc]init];
    domainName=@"accountTable";
    SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:@"passwordAttribute" andValue:passwordText.text andReplace:YES];
    SimpleDBReplaceableAttribute *attrib2=[[SimpleDBReplaceableAttribute alloc]initWithName:@"usernameAttribute" andValue:usernameText.text andReplace:YES];
    SimpleDBReplaceableAttribute *attrib3=[[SimpleDBReplaceableAttribute alloc]initWithName:@"myEventIndexAttribute" andValue:@"1" andReplace:YES];
    SimpleDBReplaceableAttribute *attrib4=[[SimpleDBReplaceableAttribute alloc]initWithName:@"contactEventsAttribute" andValue:@"" andReplace:YES];
    SimpleDBReplaceableAttribute *attrib5=[[SimpleDBReplaceableAttribute alloc]initWithName:@"confirmEventsAttribute" andValue:@"" andReplace:YES];
    SimpleDBReplaceableAttribute *attrib6=[[SimpleDBReplaceableAttribute alloc]initWithName:@"Name" andValue:@"Value" andReplace:YES];
    SimpleDBReplaceableAttribute *attrib7=[[SimpleDBReplaceableAttribute alloc]initWithName:@"PhotoUrlAttribute" andValue:@"Default" andReplace:YES];
    NSMutableArray *attribList=[[NSMutableArray alloc]initWithObjects:attrib1, attrib2,attrib3,attrib4,attrib5,attrib6,attrib7, nil];
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:phoneNumberText.text andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        NSLog(@"Attributes updated");
        continues=YES;
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
    if (continues) {
        [[NSUserDefaults standardUserDefaults]setValue:phoneNumberText.text forKey:@"phoneNumber"];
        [[NSUserDefaults standardUserDefaults]setValue:passwordText.text forKey:@"password"];
        NSLog(@"Have added this user to database");
        [[NSUserDefaults standardUserDefaults]setValue:@"registerView" forKey:@"fromWhere"];
        [self clickBackButton];
        eventPoolTabBarViewController *eventPoolTabBarView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventPoolTabBarView"];
        [[NSUserDefaults standardUserDefaults]setValue:@"secureView" forKey:@"fromWhere"];
        [self presentViewController:eventPoolTabBarView animated:YES completion:nil];
    } else {
        UIAlertView *alert=[UIAlertView alloc];
        alert.message=@"Network is out of service. Failed to create new account.";
        [alert addButtonWithTitle:@"Reenter"];
        [alert show];
    }
}

-(BOOL) couldContinue{
    NSLog(@"Checking input state");
    UIAlertView *alert;
    alert.tag=1;
    NSString *message;
    BOOL continues=YES;
    
    if ([phoneNumberText.text isEqualToString:@""]) {
        message=@"Phone Number can not be empty";
        alert=[[UIAlertView alloc]initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (phoneNumberText.text.length!=10) {
        message=@"Phone Number format is wrong";
        alert=[[UIAlertView alloc]initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if([usernameText.text isEqualToString:@""]){
        message=@"Username can not be empty";
        continues=NO;
    }
    if ([passwordText.text isEqualToString:@""]) {
        message=@"Password can not be empty";
        continues=NO;
    }
    if ([rePasswordText.text isEqualToString:@""]) {
        message=@"Please re-enter the password";
        continues=NO;
    }
    if (![passwordText.text isEqualToString:rePasswordText.text]) {
        message=@"Password does not match";
        continues=NO;
    }
    if (!continues) {
        alert=[[UIAlertView alloc]initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return continues;
    }
    if ([self accountExist]) {
        alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"This number has existed, please use another one!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        continues=NO;
        return continues;
    }
    return continues;
}

-(BOOL)accountExist{
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
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages",twilioAccount,twilioAuth,twilioAccount];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    confirmation = (arc4random() % (9000)) + 1000;
    NSString *textContent = [NSString stringWithFormat:@"Hello from Redder! Your confirmation code IS: %d", confirmation];
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", twilioNumber,userPhoneNumber,textContent];
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
