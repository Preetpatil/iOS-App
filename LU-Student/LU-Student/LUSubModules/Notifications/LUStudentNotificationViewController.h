//
//  LUStudentNotificationViewController.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"

@interface LUStudentNotificationViewController : UIViewController< LUDelegate,UITextFieldDelegate, UIPopoverPresentationControllerDelegate>

{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITableView *schoolTable;
@property (weak, nonatomic) IBOutlet UILabel *unreadCount;

- (IBAction)showNotifications:(id)sender;

// for detail view
@property (weak, nonatomic) IBOutlet UITextView *TitleText;
@property (weak, nonatomic) IBOutlet UIView *Notificationdetailview;
@property (weak, nonatomic) IBOutlet UITextView *Descriptiontext;

- (IBAction)Closebtn:(id)sender;

- (IBAction)addNotification:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addNotificationButton;

@property (weak, nonatomic) IBOutlet UILabel *classLableNotification;


//--------------------------------------------------------------------------------------

@property (weak, nonatomic) IBOutlet UIView *addNotificationPopUP;

@property (weak, nonatomic) IBOutlet UIPickerView *classNamePickerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationTypeSegment;

- (IBAction)segmentTappedNotification:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextView *notificationDescTextView;

//@property (weak, nonatomic) IBOutlet UIButton *addNotificationButton;

- (IBAction)addNotificationTapped:(id)sender;

- (IBAction)cancelAddNotificationButton:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *notificationTitle;

@property (weak, nonatomic) IBOutlet UITextView *notificationDescription;

@property (weak, nonatomic) IBOutlet UITextField *expireAt;


























@end
