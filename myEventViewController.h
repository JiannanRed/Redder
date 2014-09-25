//
//  myEventViewController.h
//  Redder
//
//  Created by Jiannan on 9/17/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "myEventCollectionCell.h"
#import "myEventCollectionView.h"
#import "myEventDetailViewController.h"
#import "myAccountViewController.h"

AmazonSimpleDBClient *sdbClient;

@interface myEventViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet myEventCollectionView *myEventCollectionView;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *contactEventString;
@property (nonatomic, strong) NSString *confirmEventString;

@property (strong, nonatomic) NSArray *eventDetailInfo;
@property (nonatomic, strong) NSMutableArray *eventId;
@property (nonatomic, strong) NSMutableArray *myEventList;
@property (nonatomic, strong) NSMutableArray *confirmUserList;
@property (nonatomic, strong) NSMutableArray *eventType;
@property (nonatomic, strong) NSMutableArray *eventTitle;
@property (nonatomic, strong) NSMutableArray *eventTime;
@property (nonatomic, strong) NSMutableArray *eventContentAttribute;
@property (nonatomic, strong) NSMutableArray *isAvailableAttribute;
@property (nonatomic, strong) NSMutableArray *waitList;
@property (nonatomic, strong) NSMutableArray *eventPhoneNumber;
@property (nonatomic, strong) NSString *accountPhoneNumber;
@property (nonatomic, strong) NSMutableArray *orderIndex;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@property UIActivityIndicatorView *activityIndicator;

@end
