//
//  eventPoolCell.h
//  Redder
//
//  Created by Jiannan on 9/16/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventPoolCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTimeLabel;

@end
