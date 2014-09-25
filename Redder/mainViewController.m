//
//  mainViewController.m
//  Redder
//
//  Created by Jiannan on 9/11/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "mainViewController.h"

NSInteger appearTimes;

@interface mainViewController ()

@end

@implementation mainViewController

@synthesize loginButton,mainImage,startPoint,endPoint,pictureNumber;
@synthesize registerButton,phoneNumber,password,myEventIndex,activityIndicator;

-(void)viewDidAppear:(BOOL)animated{
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidden:NO];
    }
    appearTimes++;
    NSString *fromWhere;
    fromWhere=[[NSUserDefaults standardUserDefaults]stringForKey:@"fromWhere"];
    phoneNumber=[[NSUserDefaults standardUserDefaults]stringForKey:@"phoneNumber"];
    password=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    if(phoneNumber.length>3 && appearTimes==1 && ![fromWhere isEqualToString:@"registerView"]){
        NSLog(@"%@,%@",phoneNumber,password);
        [self login];
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"mainView" forKey:@"fromWhere"];
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appearTimes=0;
    pictureNumber=1;
    
    mainImage.image=[UIImage imageNamed:@"carpool.jpg"];
    
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    activityIndicator.hidden=NO;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(clickSignInButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[loginButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    loginButton.frame=CGRectMake(40.0f, 480.0f, 80.0f, 40.0f);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor grayColor]];
    CALayer *btnLayer = [loginButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:loginButton];
    
    registerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[registerButton titleLabel]setFont:[UIFont fontWithName:@"RobotoCondensed" size:18.0f]];
    registerButton.frame=CGRectMake(150.0f, 480.0f, 135.0f, 40.0f);
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor grayColor]];
    CALayer *btnLayer1 = [registerButton layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [btnLayer1 setBorderWidth:1.0f];
    [btnLayer1 setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.view addSubview:registerButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickSignInButton:(id)sender{
    signinViewController *signinViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"signinViewController"];
    signinViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:signinViewController animated:YES completion:nil];
}

-(void)clickRegisterButton:(id)sender{
    registerViewController *registerViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    registerViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerViewController animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        phoneNumber=[alertView textFieldAtIndex:0].text;
        password=[alertView textFieldAtIndex:1].text;
        [self login];
    }
}

-(void)login{
    NSString *domainName=[[NSString alloc]initWithFormat:@"accountTable"];
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
                _username=attrib.value;
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
        [[NSUserDefaults standardUserDefaults]setValue:_username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setValue:myEventIndex forKey:@"myEventIndexAttribute"];
        NSLog(@"log in as %@",_username);
        [[NSUserDefaults standardUserDefaults]setValue:@"mainView" forKey:@"fromWhere"];
        appearTimes++;
        eventPoolTabBarViewController *eventPoolTabBarView=[self.storyboard instantiateViewControllerWithIdentifier:@"eventPoolTabBarView"];
        eventPoolTabBarView.modalTransitionStyle=//UIModalTransitionStyleCoverVertical;
        UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:eventPoolTabBarView animated:YES completion:nil];
    }
}

/*- (IBAction)pageControl:(UIPageControl *)sender {
    mainImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",sender.currentPage+1]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *theTouch=[touches anyObject];
    startPoint=[theTouch locationInView:self.mainImage];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *theTouch=[touches anyObject];
    endPoint=[theTouch locationInView:self.mainImage];
    if (endPoint.x<startPoint.x-150 && pictureNumber<3) {
        pictureNumber++;
        mainImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)pictureNumber]];
        mainPageController.currentPage=pictureNumber-1;
    }
    if (endPoint.x>startPoint.x+150 && pictureNumber>1) {
        pictureNumber--;
        mainImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)pictureNumber]];
        mainPageController.currentPage=pictureNumber-1;
    }
}*/
@end
