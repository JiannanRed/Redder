//
//  addEventViewController.h
//  Redder
//
//  Created by Jiannan on 9/13/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>

AmazonSimpleDBClient *sdbClient;

@interface addEventViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet UIView *eventBackgroundView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *driverOrPassengerLabel;


@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (nonatomic, strong) NSString *eventType;
@property (strong, nonatomic) NSString *finalDateStringPart1;
@property (strong, nonatomic) NSString *finalDateStringPart2;
@property (strong, nonatomic) NSString *finalDateString;
@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventContent;
@property (strong, nonatomic) NSString *maxIndex;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSMutableArray *passengerOrDriverArray;

- (IBAction)chooseDecideDateButton:(id)sender;
- (IBAction)chooseDecideTimeButton:(id)sender;
- (IBAction)chooseDriverOrPassengerButton:(id)sender;

@end
