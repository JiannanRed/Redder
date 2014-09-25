//
//  eventDetailViewController.h
//  Redder
//
//  Created by Jiannan on 9/14/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;
@interface eventDetailViewController : UIViewController

@property (strong, nonatomic) NSArray *eventDetailInfo;
@property (strong,nonatomic) NSString *accountType;
@property (strong,nonatomic) NSString *phoneNumber;
@property (strong, nonatomic)NSString *eventType;
@property (strong, nonatomic)NSString *eventPhoneNumber;
@property (strong, nonatomic)NSString *identity;
@property (strong, nonatomic)NSString *appliedUserList;
@property (strong, nonatomic)NSString *confirmedUserList;
@property (strong, nonatomic)NSString *eventId;
@property (strong, nonatomic)NSString *addPhoneNumberString;
@property (strong, nonatomic)NSString *contactEventList;

@property (strong, nonatomic)NSMutableArray *applyPassenger,*applyDriver,*confirmPassenger,*confirmDriver;

@end
