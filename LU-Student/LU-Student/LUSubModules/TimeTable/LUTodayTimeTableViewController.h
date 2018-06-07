//
//  LUTodayTimeTableViewController.h
//  LUStudent
//
//  Created by Preeti Patil on 15/02/17.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"
@interface LUTodayTimeTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LUDelegate>
@property (weak, nonatomic) IBOutlet UITableView *todayTable;
//@property (strong, nonatomic) NSDictionary *todaydata;
@property (strong, nonatomic) NSMutableArray *todaydata;
@property (strong, nonatomic) NSMutableDictionary *todaydataDict;
@property (strong, nonatomic) NSDictionary *period;

@property (strong, nonatomic) NSString *Id;


@property NSArray *todayArray;
@end
