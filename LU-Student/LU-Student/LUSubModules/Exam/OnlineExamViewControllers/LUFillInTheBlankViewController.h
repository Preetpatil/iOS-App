//
//  LUFillInTheBlankViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUFillInTheBlankViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *fillTable;
@property (nonatomic,weak) NSArray *questions;
@property (weak, nonatomic) NSTimer *timercount;
@property  int secondsLeft;
@property  int tempsecondsLeft;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@end
