//
//  myRelativeEventViewController.h
//  Redder
//
//  Created by Jiannan on 9/15/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "myRelativeEventViewCell.h"
#import "myRelativeEventCollectionView.h"
#import "myRelativeEventDetailViewController.h"

AmazonSimpleDBClient *sdbClient;

@interface myRelativeEventViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@property (strong, nonatomic) IBOutlet myRelativeEventCollectionView *myRelativeCollectionView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *contactEventString;
@property (nonatomic, strong) NSString *confirmEventString;

@property (strong, nonatomic) NSArray *eventDetailInfo;
@property (nonatomic, strong) NSMutableArray *contactEventList;
@property (nonatomic, strong) NSMutableArray *confirmEventList;
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
