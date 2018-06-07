//
//  LUOnlineExamQuesionsController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LUHeader.h"
#import "LUNotesMainDataManager.h"


@interface LUOnlineExamQuesionsController : UIViewController<LUDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UIButton *submitExam;
@property (weak, nonatomic) IBOutlet UITableView *questionList;

@property (weak, nonatomic) NSTimer *timercount;
@property(weak, nonatomic) NSArray *questions;

@property NSString *tempSUBJECTNAME;
@property  int secondsLeft;
@property  int tempsecondsLeft;


-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

//review

@property (weak, nonatomic) IBOutlet UIView *reviewBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;

@property NSString*examID;
@property NSString*questiontype_ID;

@end
