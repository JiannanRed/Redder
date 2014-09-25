//
//  userTableViewCell.h
//  Redder
//
//  Created by Jiannan on 9/23/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

@interface userTableViewCell : UITableViewCell

@property (nonatomic, assign) UIViewController *viewController;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventType;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *rejectButton;
- (IBAction)touchContactButton:(id)sender;
- (IBAction)touchConfirmButton:(id)sender;
- (IBAction)touchRejectButton:(id)sender;

@end
