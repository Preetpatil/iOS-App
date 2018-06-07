//
//  LUStudentAppDelegate.m
//  LUStudent

//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentAppDelegate.h"
#import "LUOperation.h"

//#import "LUStudentMainViewController.h"

NSString *const pasteboardIdentifier = @"LUCutCopyPaste";

@interface LUStudentAppDelegate ()

@end

@implementation LUStudentAppDelegate
@synthesize AlertMessage;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIPasteboard pasteboardWithName:pasteboardIdentifier create:YES];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

//


//-(void) checkNetworkStatus:(NSNotification *)notice
//{
//    // called after network status changes
//
//    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
//    switch (internetStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"The internet is down.");
//            self.internetActive = NO;
//
//            //save in keychain
//
//
//
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"The internet is working via WIFI.");
//            self.internetActive = YES;
//            //save the username and password..
//
//
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"The internet is working via WWAN.");
//            self.internetActive = YES;
//
//            break;
//        }
//    }
//
//    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
//
//    switch (hostStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"A gateway to the host server is down.");
//            self.hostActive = NO;
//            AlertMessage = @"A gateway to the host server is down";
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"A gateway to the host server is working via WIFI.");
//            self.hostActive = YES;
//
//            AlertMessage = @"A gateway to the host server is working via WIFI";
//
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"A gateway to the host server is working via WWAN.");
//            self.hostActive = YES;
//
//            break;
//        }
//    }
//}

- (void)logoutButtonPressed
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Logout"
                                 message:@"Are You Sure Want to Logout!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    //[self LUStudentMainVC:alert animated:YES completion:nil];
}

//
-(void)alert
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AlertView" message:AlertMessage preferredStyle:UIAlertControllerStyleAlert];
    //    alert.view.tintColor = [UIColor redColor];
    //
    //    UIView *firstSubview = alert.view.subviews.firstObject;
    //
    //    UIView *alertContentView = firstSubview.subviews.firstObject;
    //    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
    //        subSubView.backgroundColor = [UIColor blueColor]; //Here you change background
    //    }
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [alert addAction:defaultAction];
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}







////////////////////////////////////////////..................................

//-(void)setUpRechability
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
//
//    reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//
//    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//
//    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet-=NO;   }
//    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet-=YES;  }
//    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet-=YES;  }
//
//}
//
//- (void) handleNetworkChange:(NSNotification *)notice
//{
//    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//
//    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet-=NO;   }
//    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet-=YES;  }
//    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet-=YES;  }
//
//    //    if (self.hasInet) {
//    //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Net avail" message:@"" delegate:self cancelButtonTitle:OK_EN otherButtonTitles:nil, nil];
//    //        [alert show];
//    //    }
//}


/////////////////////////////////////////////////////////.............................
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"LearningUmbrellaMaster"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
@end
