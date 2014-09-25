//
//  myAccountViewController.h
//  Redder
//
//  Created by Jiannan on 9/12/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

AmazonSimpleDBClient *sdbClient;

@interface myAccountViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong,nonatomic) UIButton *logoutButton,*usernameButton,*passwordButton,*reportIssueButton,*suggestionButton;

@property (strong,nonatomic) NSString *fromWhere,*username,*phoneNumber;
@property NSMutableArray *eventID;

@end
