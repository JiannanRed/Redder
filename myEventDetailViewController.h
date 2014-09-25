//
//  myEventDetailViewController.h
//  Redder
//
//  Created by Jiannan on 9/19/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "eventUsersViewController.h"
#import "userViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

@interface myEventDetailViewController : UIViewController

@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSArray *eventDetailInfo;

@property (strong, nonatomic) NSString *accountType;
@property (strong, nonatomic) NSString *eventDate;
@property (strong, nonatomic) NSString *eventTime;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *eventPhoneNumber;
@property (strong, nonatomic) NSString *identity;
@property (strong, nonatomic) NSString *appliedUserString;
@property (strong, nonatomic) NSString *confirmedUserString;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventContent;
@property (strong, nonatomic) NSString *addPhoneNumberString;
@property (strong, nonatomic) NSString *contactEventString;
@property (strong, nonatomic) NSString *confirmEventString;
@property (strong, nonatomic) NSString *updateAppliedUserList;
@property (strong, nonatomic) NSString *updateConfirmUserList;
@property (strong, nonatomic) NSString *finalDateStringPart1;
@property (strong, nonatomic) NSString *finalDateStringPart2;

@property (strong, nonatomic)NSMutableArray *contactEventList,*confirmEventList;

@property (strong, nonatomic)UIActivityIndicatorView *activityIndicator;

@end
