//  9-24
//  mainViewController.h
//  Redder
//
//  Created by Jiannan on 9/11/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "registerViewController.h"
#include "signinViewController.h"

AmazonSimpleDBClient *sdbClient;

@interface mainViewController : UIViewController

@property (nonatomic,assign) NSInteger pictureNumber;
@property(nonatomic,strong) NSString *username,*phoneNumber,*password,*myEventIndex;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property CGPoint startPoint,endPoint;

@property UIActivityIndicatorView *activityIndicator;

@property(nonatomic,strong)IBOutlet UIButton *loginButton;
@property(nonatomic,strong)IBOutlet UIButton *registerButton;
@end
