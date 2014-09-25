//
//  registerViewController.h
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "eventPoolTabBarViewController.h"
#import <Foundation/Foundation.h>

AmazonSimpleDBClient *sdbClient;
@interface registerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) UITextField *phoneNumberText,*usernameText,*passwordText,*rePasswordText,*confirmationText;
@property (strong,nonatomic) UIButton *submitButton,*imageButton,*sendConfirmationButton,*backButton;

-(IBAction)textFieldReturn:(id)sender;

@end
