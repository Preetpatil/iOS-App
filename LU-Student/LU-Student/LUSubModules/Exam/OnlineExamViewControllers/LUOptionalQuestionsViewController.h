//
//  LUOptionalQuestionsViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"

@protocol returnOptionsAnswerDelegate <NSObject>

@required
-(void)returnOptionsAnswer:(NSDictionary *)answer;
@end

@interface LUOptionalQuestionsViewController : UIViewController<LUDelegate>

@property (nonatomic,strong)id<returnOptionsAnswerDelegate>optionsQuestionDelegate;
@property (weak, nonatomic) IBOutlet UIButton *nxtqstn;
@property (weak, nonatomic) IBOutlet UIButton *prevqstn;

@property NSArray *questions;
@property NSString *optionalQuestionLink,*correctOption,*questionType,*Qnumber,*questionTypeID,*QId,*question,*Dbname;
@property (weak, nonatomic) NSTimer *timercount;
@property(weak, nonatomic) NSString *link;
@property(retain, nonatomic) NSDictionary *answersTemp; //dictionay to save all the answers from the user
@property  int secondsLeft;
@property  int tempsecondsLeft;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property NSIndexPath *indxPth;

//saveExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName


@end
