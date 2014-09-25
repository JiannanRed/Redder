//
//  myRelativeEventDetailViewController.h
//  Redder
//
//  Created by Jiannan on 9/16/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

@interface myRelativeEventDetailViewController : UIViewController

@property (strong, nonatomic) NSArray *eventDetailInfo;
@property (strong, nonatomic) NSString *accountType;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *eventPhoneNumber;
@property (strong, nonatomic) NSString *identity;
@property (strong, nonatomic) NSString *appliedUserString;
@property (strong, nonatomic) NSString *confirmedUserString;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *addPhoneNumberString;
@property (strong, nonatomic) NSString *contactEventString;
@property (strong, nonatomic) NSString *confirmEventString;
@property (strong, nonatomic) NSString *updateAppliedUserList;
@property (strong, nonatomic) NSString *updateConfirmUserList;

@property (strong, nonatomic)NSMutableArray *applyPassenger,*applyDriver,*confirmPassenger,*confirmDriver,*contactEventList,*confirmEventList;

@end
