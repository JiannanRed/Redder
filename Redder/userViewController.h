//
//  userViewController.h
//  Redder
//
//  Created by Jiannan on 9/23/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userTableViewCell.h"
#import "userTableView.h"
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

@interface userViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property UIActivityIndicatorView *activityIndicator;

@property (strong,nonatomic) NSString *userType;
@property (strong,nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *eventID;
@property (strong,nonatomic) NSMutableArray *userList;
@property (strong,nonatomic) NSMutableArray *userIDList;

@end
