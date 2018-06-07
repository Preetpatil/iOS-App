//
//  LUStudentAppDelegate.h
//  LUStudent

//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LUReachability.h"


extern NSString *const pasteboardIdentifier;

@interface LUStudentAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) LUReachability *reachabile;//trial

@property (nonatomic, retain) NSString *AlertMessage;
//@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *view;
@property (strong, nonatomic) UILabel *label;

@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

