//
//  eventPoolViewController.h
//  Redder
//
//  Created by Jiannan on 9/16/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventPoolCell.h"
#import "eventPoolCollectionView.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "addEventViewController.h"
#import "eventDetailViewController.h"

AmazonSimpleDBClient *sdbClient;

@interface eventPoolViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    eventPoolCollectionView *_collectiveView;
}
@property (strong, nonatomic) IBOutlet eventPoolCollectionView *eventPoolCollectionView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *accountType;

@property (strong, nonatomic) NSArray *eventDetailInfo;
@property (nonatomic, strong) NSMutableArray *eventType;
@property (nonatomic, strong) NSMutableArray *eventTitle;
@property (nonatomic, strong) NSMutableArray *eventTime;
@property (nonatomic, strong) NSMutableArray *eventContentAttribute;
@property (nonatomic, strong) NSMutableArray *isAvailableAttribute;
@property (nonatomic, strong) NSMutableArray *postUsernameAttribute;
@property (nonatomic, strong) NSMutableArray *eventPhoneNumber;
@property (nonatomic, strong) NSString *accountPhoneNumber;
@property (nonatomic, strong) NSMutableArray *orderIndex;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end
