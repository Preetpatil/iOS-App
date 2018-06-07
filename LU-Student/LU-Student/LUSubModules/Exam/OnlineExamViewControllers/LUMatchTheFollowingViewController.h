//
//  LUMatchTheFollowingViewController.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"
#import "LUMatchQuestionCell.h"
@protocol returnMatchAnswerDelegate <NSObject>

@required
-(void)returnMatchAnswer:(NSDictionary *)answer;
@end

@interface LUMatchTheFollowingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LUDelegate>
@property (nonatomic,weak)id<returnMatchAnswerDelegate>MatchQuestionDelegate;

@property (weak,nonatomic) IBOutlet UITableView *matchQuestion;

@property (strong,nonatomic) NSArray *questions;
@property (strong,nonatomic) NSDictionary *matchAnswer;
@property  int tempsecondsLeft;
@property  int secondsLeft;
@property (weak, nonatomic) NSTimer *timercount;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;

@end
