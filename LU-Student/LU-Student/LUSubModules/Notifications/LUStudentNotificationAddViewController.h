
//
//  LUStudentNotificationAddViewController.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"


@interface LUStudentNotificationAddViewController : UIViewController<UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate,LUDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *classNamePickerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationTypeSegment;

- (IBAction)segmentTappedNotification:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextView *notificationDescTextView;

@property (weak, nonatomic) IBOutlet UIButton *addNotificationButton;

- (IBAction)addNotificationTapped:(id)sender;

- (IBAction)cancelButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *notificationTitle;

@property (weak, nonatomic) IBOutlet UITextView *notificationDescription;

@property (weak, nonatomic) IBOutlet UITextField *expireAt;

@end
