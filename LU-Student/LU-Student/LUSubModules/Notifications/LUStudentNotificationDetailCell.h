//
//  LUStudentNotificationDetailCell.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUStudentNotificationDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *notificationTitle;
@property (strong, nonatomic) IBOutlet UILabel *expiryDate;
@property (strong, nonatomic) IBOutlet UILabel *notificationDescription;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *statusimage;


/*
 "expiry_date" = "02/28/2017 12:00 AM";
 "notification_description" = "notification description 3";
 "notification_title" = "notification 3";
 status = read;
 type = Class;
 "user_id" = 3;
 "user_notification_id" = 851;
 */
@end
