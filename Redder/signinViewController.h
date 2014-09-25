//
//  signinViewController.h
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "eventPoolTabBarViewController.h"

AmazonSimpleDBClient *sdbClient;

@interface signinViewController : UIViewController
@property (strong,nonatomic) UITextField *phoneNumberText,*passwordText,*securityCodeText;
@property (strong,nonatomic) UIButton *loginButton,*forgetPasswordButton,*sendCodeButton,*securityLoginButton,*backButton;
@property (strong,nonatomic) NSString *phoneNumber, *password,*username,*myEventIndex;
@property UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSString *Account,*Auth,*Number;
/*NSString *twilioAccount = @"********";
NSString *twilioAuth = @"********";
NSString *twilioNumber = @"********";
int confirmation;*/

@end
