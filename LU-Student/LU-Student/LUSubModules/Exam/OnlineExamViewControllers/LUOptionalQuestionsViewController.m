//
//  LUOptionalQuestionsViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUOptionalQuestionsViewController.h"
#import "LUOptionalQuestionDataManager.h"
#import "LUExamDataManager.h"
@interface LUOptionalQuestionsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;  //Queston Label
@property (weak, nonatomic) IBOutlet UILabel *questionNumber;

@property (weak, nonatomic) IBOutlet UILabel *option1;   // Four options label
@property (weak, nonatomic) IBOutlet UILabel *option2;
@property (weak, nonatomic) IBOutlet UILabel *option3;
@property (weak, nonatomic) IBOutlet UILabel *option4;
@property (weak, nonatomic) IBOutlet UILabel *option5;
@property (weak, nonatomic) IBOutlet UIButton *op1btn;   // Options selection button
@property (weak, nonatomic) IBOutlet UIButton *op2btn;
@property (weak, nonatomic) IBOutlet UIButton *op3btn;
@property (weak, nonatomic) IBOutlet UIButton *op4btn;
@property (weak, nonatomic) IBOutlet UIButton *op5btn;

@end

@implementation LUOptionalQuestionsViewController
{
    NSMutableArray *questioinsArray,*qnoArray,*CorrectOption;  // Array to store all questions.
    NSMutableArray *optionsArray,*QIdArray;     // array to store all answers.
    NSInteger currentQuestion,totalQuestions,selected; // integer required for current question total question and selected  question
    NSMutableDictionary *answers;
    NSArray*questiondata;
     NSArray*pageNoArray;
     NSArray*qtype_id;
     NSArray*qtype_name;
     NSArray*qid;
     NSArray*correctoptionArray;
     NSArray*QnoArray;
    NSArray*PageImageArray;

    
    
    
    int hours, minutes, seconds;
    int currSeconds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _questionNumber.text=@"1";
    _secondsLeft = _tempsecondsLeft;
    [self countdownTimer];

     currentQuestion=0; //let current question be 0 so we get the  questionArray index value
    questioinsArray = [[NSMutableArray alloc]init];
    qnoArray = [[NSMutableArray alloc]init];
    optionsArray = [[NSMutableArray alloc]init];
    answers=[[NSMutableDictionary alloc]init]; // alloc and init dictionary for use.
    CorrectOption=[[NSMutableArray alloc]init];
    QIdArray=[[NSMutableArray alloc]init];
    //[[LUOptionalQuestionDataManager getSharedInstance]createOptinalQuestionDB:@"QuestionDb"];
    
   
    //answers = [_answersTemp copy];
     [self questionList:_questions];
    [self saveInitialdata];
     NSLog(@"%@",answers);
   
    
    totalQuestions=[questioinsArray count]; //total number of questions to stop next button from incrementing greater then the number of questions
    //[self questionList:_questions];
}


-(void)saveInitialdata
{
    questiondata=[[LUExamDataManager getSharedInstance]ShowAllExam:_Dbname qno:_Qnumber];
    pageNoArray=[questiondata objectAtIndex:0];
    qtype_id=[questiondata objectAtIndex:1];
    qtype_name=[questiondata objectAtIndex:2];
    qid=[questiondata objectAtIndex:3];
    correctoptionArray=[questiondata objectAtIndex:4];
    PageImageArray=[questiondata objectAtIndex:5];
    QnoArray=[questiondata objectAtIndex:6];
    if (QnoArray.count==0)
    {
        NSLog(@"not found");
        [[LUExamDataManager getSharedInstance]saveExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
    }
    
    questiondata=[[LUExamDataManager getSharedInstance]ShowAllExam:_Dbname qno:_Qnumber];
    pageNoArray=[questiondata objectAtIndex:0];
    qtype_id=[questiondata objectAtIndex:1];
    qtype_name=[questiondata objectAtIndex:2];
    qid=[questiondata objectAtIndex:3];
    correctoptionArray=[questiondata objectAtIndex:4];
    PageImageArray=[questiondata objectAtIndex:5];
    QnoArray=[questiondata objectAtIndex:6];
    
    
    
//    BOOL success  =  NO;
//    
//    
//        success = [[LUOptionalQuestionDataManager getSharedInstance]saveOptinalQusetion:<#(NSString *)#> Qusetion:<#(NSString *)#> Options:<#(NSString *)#> DB:<#(NSString *)#>:_FlashUniteName pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo,1] pageimage:UIImagePNGRepresentation(img)];
//    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
//    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
//    sharedSingleton.LUDelegateCall=self;
  // [sharedSingleton returnOptionsAnswer:answers];

    //BOOL success  =  NO;
    
   // success = [[LUOptionalQuestionDataManager getSharedInstance]updateOptinalQusetion:_questionNumber.text Qusetion:_questionLabel.text Options:_correctOption DB:@"QuestionDb" ];
    //[self Plistdata];
  
    if ([_optionsQuestionDelegate respondsToSelector:@selector(returnOptionsAnswer:)]) {
        [ _optionsQuestionDelegate returnOptionsAnswer:answers ];
    }
   
   
}



/**
 <#Description#>

 @param theTimer <#theTimer description#>
 */
-(void)updateCounter:(NSTimer *)theTimer
{
    if(_secondsLeft > 0 )
    {
        _secondsLeft -- ;
        hours  =  _secondsLeft / 3600;
        minutes  =  (_secondsLeft % 3600) / 60;
        seconds  =  (_secondsLeft %3600) % 60;
        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds]);
        _timeLeft .text  =  [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else
    {
        _secondsLeft  = _tempsecondsLeft;
    }
}

/**
 <#Description#>
 */
-(void)countdownTimer
{
    _secondsLeft  =  hours  =  minutes  =  seconds  =  0;
    _timercount  =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:)userInfo:nil repeats:YES];
}

/**
 <#Description#>

 @param questionlist <#questionlist description#>
 */
-(void)questionList:(NSArray *)questionlist
{
 
    for (int i=0; i<questionlist.count; i++)
    {
        [qnoArray addObject:[[questionlist objectAtIndex:i] objectForKey:@"QuestionNumber"]];
        [questioinsArray addObject:[[questionlist objectAtIndex:i] objectForKey:@"Question"]];
        [optionsArray addObject:[[questionlist objectAtIndex:i] objectForKey:@"options"]];
        [QIdArray addObject:[[questionlist objectAtIndex:i] objectForKey:@"Id"]];
        
//        for(int j=0; j< [[[questionlist objectAtIndex:i] objectForKey:@"options"] count] ; j++)
//        {
//            if (!([[[questionlist objectAtIndex:i] objectForKey:@"options"] objectAtIndex:j] == nil))
//            {
//            [optionsArray addObject:[[[questionlist objectAtIndex:i] objectForKey:@"options"] objectAtIndex:j]  ];
//            }
//        }
       
        
    }
    
    if (answers==nil)
    {
        for (int i=1; i<=questioinsArray.count; i++)
        {
            [answers setObject:@"" forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
  
 //   [self question:[questioinsArray objectAtIndex:currentQuestion] options:[optionsArray objectAtIndex:currentQuestion ]];
    [self question:[questioinsArray objectAtIndex:currentQuestion] options:[optionsArray objectAtIndex:currentQuestion ] no:[qnoArray objectAtIndex:currentQuestion] QuestionId:[QIdArray objectAtIndex:currentQuestion]];
     totalQuestions=[questioinsArray count];
   
}

/*
 -(void)fetchQuestions{
 NSString *dataUrl =@"http://hemisphereindia.com/ios/onlinetest/exam.php?q_sub=3&q_test=1&q_class=2";//_optionalQuestionLink;
 NSURLSession *session = [NSURLSession sharedSession];
 NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
 for (int i=0; i<json.count; i++) {
 NSDictionary *optionsDict=[json objectAtIndex:i];
 
 NSLog(@"%@",[optionsDict objectForKey:@"question"]);
 
 
 }
 NSLog(@"%@",questionArray);
 NSLog(@"%@",optionsArray);
 
 });
 
 }];
 
 [dataTask resume];
 
 }
 */

#pragma Flag Method

/**
 <#Description#>

 @param flag <#flag description#>
 @return <#return value description#>
 */
-(NSInteger)selectedOption:(NSInteger)flag
{
    NSInteger selection=[[answers objectForKey:[NSString stringWithFormat:@"%ld",flag]]integerValue];
    switch (selection)
    {
        case 1:
            [_op1btn setSelected:YES];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor blueColor]; //set color
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor whiteColor];
            break;
        case 2:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:YES];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor blueColor]; //set color
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor whiteColor];
            break;
        case 3:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:YES];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor blueColor]; //set color
//            _op4btn.backgroundColor=[UIColor whiteColor];
            break;
        case 4:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:YES];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor blueColor];  //set color
            break;
        case 5:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:YES];
            //            _op1btn.backgroundColor=[UIColor whiteColor];
            //            _op2btn.backgroundColor=[UIColor whiteColor];
            //            _op3btn.backgroundColor=[UIColor whiteColor];
            //            _op4btn.backgroundColor=[UIColor blueColor];  //set color
            break;

            
        case 0:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor whiteColor];  //set color
            break;
    }
    return selection;
}

#pragma This method set the question and options
/**
 <#Description#>

 @param question <#question description#>
 @param options <#options description#>
 */
-(void)question:(NSString *)question options:(NSArray*)options no:(NSString *)qno QuestionId:(NSString*)Qid
{
    _Qnumber=qno;
    _QId=Qid;
    _questionNumber.text = qno;
    _questionLabel.text=question;
  
    
    if ([[options objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        _option1.text=[options objectAtIndex:0];
        
    }
    else
    {
        _op1btn.hidden = YES;
    }
        
    if ([[options objectAtIndex:1] isKindOfClass:[NSString class]])
    {
        _option2.text=[options objectAtIndex:1];
    }else
    {
        _op2btn.hidden = YES;
    }

    if ([[options objectAtIndex:2] isKindOfClass:[NSString class]])
    {
        _option3.text=[options objectAtIndex:2];
    }else
    {
        _op3btn.hidden = YES;
    }

    if ([[options objectAtIndex:3] isKindOfClass:[NSString class]])
    {
        _option4.text=[options objectAtIndex:3];
    }else
    {
        _op4btn.hidden = YES;
    }

    if ([[options objectAtIndex:4] isKindOfClass:[NSString class]])
    {
        if (_option5.text.length != 0) {
            _option5.text=[options objectAtIndex:4];
        }
        else
        {
            _op5btn.hidden = YES;

        }
    }
   // BOOL success  =  NO;
    
  //  success = [[LUOptionalQuestionDataManager getSharedInstance]saveOptinalQusetion:_questionNumber.text Qusetion:_questionLabel.text Options:_correctOption DB:@"QuestionDb" ];

    //[self Plistdata];
    
  
}

#pragma Next Button action
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)NextQuestion:(id)sender
{
   // _questionNumber.text = [NSString stringWithFormat:@"%lu",currentQuestion+1];
    
    [[LUExamDataManager getSharedInstance]updateExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
    
    currentQuestion++;
    if(currentQuestion<totalQuestions)
    {
        
        NSLog(@"%ld",[self selectedOption:currentQuestion]);
        [self question:[questioinsArray objectAtIndex:currentQuestion] options:[optionsArray objectAtIndex:currentQuestion ] no:[qnoArray objectAtIndex:currentQuestion] QuestionId:[QIdArray objectAtIndex:currentQuestion]];
        
        [[LUExamDataManager getSharedInstance]saveExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
        //updateExamDB
        [[LUExamDataManager getSharedInstance]updateExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
        
       
        
       
    }
    else
    {
        currentQuestion=totalQuestions-1;
    }
}

#pragma Previous button action

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)PreviousQuestion:(id)sender
{
   // _questionNumber.text = [NSString stringWithFormat:@"%lu",currentQuestion-1];

    currentQuestion--;
    if (currentQuestion>=0)
    {
        NSLog(@"%ld",[self selectedOption:currentQuestion+1]);
        [self question:[questioinsArray objectAtIndex:currentQuestion] options:[optionsArray objectAtIndex:currentQuestion ] no:[qnoArray objectAtIndex:currentQuestion] QuestionId:[QIdArray objectAtIndex:currentQuestion]];
      
    }
    else
    {
        currentQuestion=0;
    }
}

#pragma This method handles the color for user selection and answer
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)optionSelection:(id)sender
{
    switch ([sender tag])
    {
        case 1:
            [_op1btn setSelected:YES];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];

//            _op1btn.backgroundColor=[UIColor blueColor]; //set color
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor whiteColor];
            [answers setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",currentQuestion+1]]; //save the user selection
            _correctOption=[NSString stringWithFormat:@"%li", (long)((UIControl*)sender).tag];//[NSString stringWithFormat:@"%ld",currentQuestion+1];
            
            break;
        case 2:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:YES];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor blueColor]; //set color
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor whiteColor];
            [answers setObject:@"2" forKey:[NSString stringWithFormat:@"%ld",currentQuestion+1]];  //save the user selection
              _correctOption=[NSString stringWithFormat:@"%li", (long)((UIControl*)sender).tag];
            break;
        case 3:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:YES];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor blueColor]; //set color
//            _op4btn.backgroundColor=[UIColor whiteColor];
            [answers setObject:@"3" forKey:[NSString stringWithFormat:@"%ld",currentQuestion+1]];  //save the user selection
              _correctOption=[NSString stringWithFormat:@"%li", (long)((UIControl*)sender).tag];
            break;
        case 4:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:YES];
            [_op5btn setSelected:NO];
//            _op1btn.backgroundColor=[UIColor whiteColor];
//            _op2btn.backgroundColor=[UIColor whiteColor];
//            _op3btn.backgroundColor=[UIColor whiteColor];
//            _op4btn.backgroundColor=[UIColor blueColor];  //set color
            [answers setObject:@"4" forKey:[NSString stringWithFormat:@"%ld",currentQuestion+1]];  //save the user selection
              _correctOption=[NSString stringWithFormat:@"%li", (long)((UIControl*)sender).tag];
            break;
        case 5:
            [_op1btn setSelected:NO];
            [_op2btn setSelected:NO];
            [_op3btn setSelected:NO];
            [_op4btn setSelected:NO];
            [_op5btn setSelected:YES];
            //            _op1btn.backgroundColor=[UIColor whiteColor];
            //            _op2btn.backgroundColor=[UIColor whiteColor];
            //            _op3btn.backgroundColor=[UIColor whiteColor];
            //            _op4btn.backgroundColor=[UIColor blueColor];  //set color
            [answers setObject:@"5" forKey:[NSString stringWithFormat:@"%ld",currentQuestion+1]];  //save the user selection
              _correctOption=[NSString stringWithFormat:@"%li", (long)((UIControl*)sender).tag];
            
            break;

    }
    NSLog(@"%@",answers); //you can see the answer set to the respective questions
    //[self Plistdata];
    NSLog(@"%@",_correctOption);
//    BOOL success=NO;
//
// success= [[LUExamDataManager getSharedInstance]saveExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
//    NSLog(success ? @"Yes" : @"No");
//
//   success=  [[LUExamDataManager getSharedInstance]updateExamDB:@"" QusetiontypeId:_questionType QusetiontypeName:@"" QusetionId:_QId Correctoption:_correctOption Pageimage:nil questionno:_Qnumber DB:_Dbname];
//    NSLog(success ? @"Yes" : @"No");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

// {"Id":11,"type":1,"TestImageUrl":2},
//{"Id":12,"type":1,"TestImageUrl":3},
//{"Id":13,"type":1,"TestImageUrl":3},
//{"Id":14,"type":1,"TestImageUrl":1},
//{"Id":15,"type":1,"TestImageUrl":4},
//{"Id":16,"type":2,
//    "pagenumber":"1.1",
//    "TestImageUrl":""}

@end
