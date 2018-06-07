//
//  LUOnlineExamQuesionsController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import "LUOnlineExamQuesionsController.h"
#import "LUExamDataManager.h"

@interface LUOnlineExamQuesionsController ()
@property (retain, strong) UIButton *writeAnswer;

@end

@implementation LUOnlineExamQuesionsController

{
    NSDictionary *optionsAnswer,*matchAnswer,*fillAnswer,*discriptiveAnswer;
    NSMutableArray *part,*questionType,*mark;
    NSMutableArray *qstn;
    NSMutableArray *qstn0;
    NSMutableArray *dbNameCache,*PageImageArray,*pageNoArray,*PageImageArrayReview,*QuestionType,*qtypeID,*Qtypename,*Qid,*Coreectoption,*Qnumber;
//    NSMutableArray *page_no  =  [[NSMutableArray alloc] init];
//    NSMutableArray *Qtype_id  =  [[NSMutableArray alloc] init];
//    NSMutableArray*Qtype_name =[[NSMutableArray alloc]init];
//    NSMutableArray*QId =[[NSMutableArray alloc]init];
//    NSMutableArray*Correct_Option =[[NSMutableArray alloc]init];
//    NSMutableArray*Page_image =[[NSMutableArray alloc]init];
//    NSMutableArray*Qno =[[NSMutableArray alloc]init];
    NSString*pageno,*qtype,*qtypeid,*qtypename,*qid,*correctoption,*pageimage,*qno;
    NSArray *pageUpdation;
    NSArray *item;
    NSMutableSet *parts;
    NSMutableArray *marks;
    NSIndexPath *clickPath;
    UIView *countdown;
    int tag;
    int hours, minutes, seconds;
    int currSeconds;
    UILabel *progress;
    
    __weak IBOutlet UILabel *pageNoLbl;
    NSTimer *timer;
   // UIButton *writeAnswer;
    
    
    __weak IBOutlet UILabel *reviewAnswerSubjectName;
    
    NSMutableArray *rowData , *sectiondata, *rowDataTemp;
}
@synthesize writeAnswer;



- (void)viewDidLoad
{
    [super viewDidLoad];
    _reviewBaseView.hidden = YES;
    rowData= [[NSMutableArray alloc]init];
    sectiondata = [[NSMutableArray alloc]init];
    rowDataTemp = [[NSMutableArray alloc]init];
    questionType = [[NSMutableArray alloc]init];
    part = [[NSMutableArray alloc]init];
    mark = [[NSMutableArray alloc]init];
    dbNameCache = [[NSMutableArray alloc]init];
    questionType=[[NSMutableArray alloc]init];
    [self fetchQuestions];
    [self countdown];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [[LUExamDataManager getSharedInstance]createExamDB:@"Exam1"];//subject name and subject id...
    NSLog(@"%@",_examID);
    
}

-(void)fetchQuestions
{
    NSLog(@"%@", _questions);
    
    for (int i = 0; i<_questions.count; i++)
    {
        [_questions objectAtIndex:i];
        [sectiondata addObject:[[_questions objectAtIndex:i] objectForKey:@"QuestionTypeName"]];
        [rowData addObject:[[_questions objectAtIndex:i] objectForKey:@"testdata"]];
        [part addObject:[[_questions objectAtIndex:i] objectForKey:@"PartName"]];
        [questionType addObject:[[_questions objectAtIndex:i] objectForKey:@"QuestionTypeId"]];//questiontypeid
        [mark addObject:[[_questions objectAtIndex:i] objectForKey:@"Marks"]];
        if ([[[_questions objectAtIndex:i] objectForKey:@"QuestionTypeId"] isEqualToString:@"2"])
        {
            [rowDataTemp addObject:[[_questions objectAtIndex:i] objectForKey:@"testdata"]];
        }
        else
        {
           NSArray *temp = [NSArray arrayWithObject: [sectiondata objectAtIndex:i]];
            [rowDataTemp addObject: temp];
        }
    }
}


-(void)countdown
{
    countdown = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    progress = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 180,160)];
    countdown.backgroundColor = [UIColor whiteColor];
    [self.view  addSubview:countdown];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:countdown];
    [NSTimer scheduledTimerWithTimeInterval: 6.0
                                     target: self
                                   selector:@selector(disabler)
                                   userInfo: nil repeats:NO];
    
    
    progress.textColor = [UIColor redColor];
    [progress setFont:[UIFont fontWithName:@"Helvetica" size:160]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [progress setText:@"05"];
        });
    });
    progress.backgroundColor = [UIColor clearColor];
    progress .center  =  CGPointMake(CGRectGetMidX(countdown.bounds),
                                     CGRectGetMidY(countdown.bounds));
    [countdown addSubview:progress];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:progress];
    
    currSeconds = 05;
    [self start];
    
    _subjectName.text = _tempSUBJECTNAME;
    
    
    [self fetcher];
    _secondsLeft = _tempsecondsLeft;
    [self countdownTimer];
}


/**
 <#Description#>
 */
-(void)start
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}


/**
 <#Description#>
 */
- (void)timerFired
{
    if(currSeconds>0)
    {
        currSeconds-= 1;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            [progress setText:[NSString stringWithFormat:@"%02d",currSeconds]];
            });
        });
        NSLog(@"%@",progress.text);
    }
    else
    {
        [timer invalidate];
    }
}

/**
 <#Description#>
 */
-(void)disabler
{
     [countdown removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 <#Description#>
 */
-(void)fetcher
{
    
//    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
//    sharedSingleton.LUDelegateCall=self;
//    [sharedSingleton regularQuestionList:_link];
    
    
//    part = [[NSMutableArray alloc]init];
//    ques = [[NSMutableArray alloc]init];
//    marks = [[NSMutableArray alloc]init];
//
//        NSString *dataUrl  = _link;
//    NSURLSession *session  =  [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask  =  [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            item  =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//    for ( int i=0; i<item.count; i++) {
//        NSDictionary *ar1 = [item objectAtIndex:i];
//        [marks addObject:[ar1 objectForKey:@"mark"]];
//        [part addObject:[ar1 objectForKey:@"part"]];
//        [ques addObject:[ar1 objectForKey:@"questions"]];
//        // NSLog(@"%@ %@",part , ques);
//    }
//            [_questionList reloadData];
//        });
//    }];
//   [dataTask resume];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[rowDataTemp objectAtIndex:section] count]  ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //    return view;
    // 1. The view for the header
    UIView* LUHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // 2. Set a custom background color and a border
    LUHeaderView.backgroundColor = [UIColor lightGrayColor];
    LUHeaderView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    LUHeaderView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel1 = [[UILabel alloc] init];
    headerLabel1.frame = CGRectMake(50, 2, 100, 18);
    headerLabel1.backgroundColor = [UIColor clearColor];
    headerLabel1.textColor = [UIColor whiteColor];
    headerLabel1.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel1.text =[part objectAtIndex:section];
    headerLabel1.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [LUHeaderView addSubview:headerLabel1];
    
    UILabel* headerLabel2 = [[UILabel alloc] init];
    headerLabel2.frame = CGRectMake(tableView.frame.size.width-150, 2, 100, 18);
    headerLabel2.backgroundColor = [UIColor clearColor];
    headerLabel2.textColor = [UIColor whiteColor];
    headerLabel2.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel2.text = [mark objectAtIndex:section];
    headerLabel2.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [LUHeaderView addSubview:headerLabel2];
    
    
    // 5. Finally return
    return LUHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectiondata.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *header =@"sections";//  [sectiondata objectAtIndex:section];
    return header;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.section);
    NSLog(@"%ld",(long)indexPath.row);
    clickPath = indexPath;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    UILabel *qstnlbl = (UILabel *)[cell viewWithTag:2];
    
   NSLog(@"%@", [[rowDataTemp objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    
    if ([[questionType objectAtIndex:indexPath.section] isEqualToString:@"2"])
    {
        
        qstnlbl.text =[NSString stringWithFormat:@"%@", [[[rowDataTemp objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Question"]];

    }else{
        qstnlbl.text =[NSString stringWithFormat:@"%@",  [[rowDataTemp objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
    
   // qstnlbl.text =[NSString stringWithFormat:@"%@",[[rowDataTemp objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] ;
    
    UILabel *qstnnolbl = (UILabel *)[cell viewWithTag:1];
    qstnnolbl.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    writeAnswer  =  (UIButton *)[cell viewWithTag:3];
    
    [writeAnswer setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed:@"examWrite.png"]]];
    [writeAnswer setTitle:@"" forState:UIControlStateNormal];
    [writeAnswer addTarget:self action:@selector(towriteExamButton:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

/**
 <#Description#>

 @param sender <#sender description#>
 @param event <#event description#>
 */
-(void)towriteExamButton:(id)sender event:(id)event
{
   [sender setTitle:@"" forState:UIControlStateSelected];
    [sender setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"view-edit.png"]]];
   // writeAnswer.backgroundColor =[UIColor colorWithPatternImage: [UIImage imageNamed:@"view-edit.png"]];
   // [sender setBackground:[UIImage imageNamed:@"view-edit.png"]];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.questionList];
    NSIndexPath *indexPath = [self.questionList indexPathForRowAtPoint:buttonPosition];
    
   if ([[questionType objectAtIndex:indexPath.section] isEqualToString:@"1"])
   {
       NSLog(@"1");
       
       LUOptionalQuestionsViewController *pushToWrite = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionalVC"];
       pushToWrite.optionsQuestionDelegate = self;
       //pushToWrite.indxPth = clickPath;
   
       pushToWrite.tempsecondsLeft = _secondsLeft;
       //optionalQuestionLink,*correctOption,*questionType,*Qnumber,*questionTypeID,*QId
       pushToWrite.answersTemp = optionsAnswer;
//       pushToWrite.Qnumber =[[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"QuestionNumber"];
//
//       pushToWrite.question = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Question"];
//
//       pushToWrite.QId = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Id"];
       pushToWrite.Dbname=@"Exam1";
//       _questiontype_ID=[questionType objectAtIndex:indexPath.section];
//       NSLog(@"%@",_questiontype_ID);
       pushToWrite.questionTypeID= _questiontype_ID;
       
       

       pushToWrite.questions = [rowData objectAtIndex:indexPath.section];
       
       [self.navigationController pushViewController:pushToWrite animated:YES];
   }
   else if ([[questionType objectAtIndex:indexPath.section] isEqualToString:@"2"])
   {
       NSLog(@"2");
    // _questiontype_ID =  [[[_questions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"QuestionTypeId"];
       
       LUWriteNotesViewController *pushToWrite =  [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentWriteNotesVC"];
       pushToWrite.tempsecondsLeft = _secondsLeft;
       pushToWrite.ExamQuestionNo =[[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"QuestionNumber"];
       
       pushToWrite.ExamQuestion = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Question"];
       
       pushToWrite.Question_Id = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Id"];
       pushToWrite.DBname=@"Exam1";
       _questiontype_ID=[questionType objectAtIndex:indexPath.section];
       NSLog(@"%@",_questiontype_ID);
       pushToWrite.QuestionType_Id= _questiontype_ID;
       pushToWrite.isExam = YES;
       pushToWrite.FlashUniteName = [NSString stringWithFormat:@"Question%@",pushToWrite.ExamQuestionNo];
       
       

      // BOOL success  =  NO;
       if(![dbNameCache containsObject:[NSString stringWithFormat:@"Question%@",pushToWrite.ExamQuestionNo]])
       {
           [dbNameCache addObject:[NSString stringWithFormat:@"Question%@",pushToWrite.ExamQuestionNo]];
       }
       
      [self.navigationController pushViewController:pushToWrite animated:YES];
      
     
   }
   else if ([[questionType objectAtIndex:indexPath.section] isEqualToString:@"3"])
   {
       NSLog(@"3");

       LUWriteNotesViewController *pushToWrite =  [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentWriteNotesVC"];
       pushToWrite.tempsecondsLeft = _secondsLeft;
       
       //fill trial
       pushToWrite.fillQuestions = [rowData objectAtIndex:indexPath.section];
       
       //       //descriptive question
       //       pushToWrite.ExamQuestionNo =[[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"QuestionNumber"];
       //       pushToWrite.ExamQuestion = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Question"];
       
       pushToWrite.isExam = YES;
       pushToWrite.FlashUniteName = @"fillQuestion"; //[NSString stringWithFormat:@"Question%@",pushToWrite.ExamQuestionNo];
       pushToWrite.ExamQuestionNo = @"fillQuestion";
       
       pushToWrite.Question_Id = [[[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Id"];
       pushToWrite.DBname=@"Exam1";
       _questiontype_ID=[questionType objectAtIndex:indexPath.section];
       NSLog(@"%@",_questiontype_ID);
       pushToWrite.QuestionType_Id= _questiontype_ID;
       pushToWrite.isExam = YES;
       
       BOOL success  =  NO;
       if (![dbNameCache containsObject:@"fillQuestion"])
       {
           [dbNameCache addObject:@"fillQuestion"];
       }
       
      // success  =  [[LUNotesMainDataManager getSharedInstance]createDB:@"fillQuestion"];//[NSString stringWithFormat:@"Question%@",pushToWrite.FlashUniteName]];
      // NSLog(success ? @"Yes Notes created" : @"No notes created");
       [self.navigationController pushViewController:pushToWrite animated:YES];


   }
    
    
   else if ([[questionType objectAtIndex:indexPath.section] isEqualToString:@"4"])
   {
       NSLog(@"4");
       LUMatchTheFollowingViewController *pushToMatch = [self.storyboard instantiateViewControllerWithIdentifier:@"matchVC"];
       pushToMatch.questions = [rowData objectAtIndex:indexPath.section];
       pushToMatch.tempsecondsLeft = _secondsLeft;
       [self.navigationController pushViewController:pushToMatch animated:YES];
   }
    
   // LUOptionalQuestionsViewController *pushToWrite = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionalVC"];
  //  pushToWrite.indxPth = clickPath;
  //  pushToWrite.questions = [rowData objectAtIndex:clickPath.row];
    
    
    //pushToWrite.questions = [rowData objectAtIndex:<#(NSUInteger)#>];
    //pushToWrite.isExam=YES;
    //pushToWrite.FlashPageType = @"ruled";
    
    //toWrite.question = [tempDict objectForKey:@"question"];
    //toWrite.questionNo = [tempDict objectForKey:@"question_no"];
    //toWrite.examSubjectName =_tempSUBJECTNAME;
  //  [self.navigationController pushViewController:pushToWrite animated:YES];
    
}

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
-(void)countdownTimer
{
    _secondsLeft  =  hours  =  minutes  =  seconds  =  0;
    _timercount  =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:)userInfo:nil repeats:YES];
}

-(void)returnOptionsAnswer:(NSDictionary *)answer
{
    optionsAnswer = answer;
}


-(void)returnMatchAnswer:(NSDictionary *)answer
{
    
}

-(void)returnDiscriptiveAnswer:(NSDictionary *)answer
{
    
}


int currentPage = 0;

- (IBAction)submitExam:(id)sender

{
    /*
    PageImageArray = [[NSMutableArray alloc]init];
    pageNoArray = [[NSMutableArray alloc]init];
    PageImageArrayReview = [[NSMutableArray alloc]init];
    //*QuestionType,*qtypeID,*Qtypename,*Qid,*Coreectoption,*Qnumber
    QuestionType= [[NSMutableArray alloc]init];
    qtypeID= [[NSMutableArray alloc]init];
    Qtypename=[[NSMutableArray alloc]init];
    Qid=[[NSMutableArray alloc]init];
    Coreectoption=[[NSMutableArray alloc]init];
    Qnumber=[[NSMutableArray alloc]init];

    reviewAnswerSubjectName.text = _tempSUBJECTNAME;
   
    
    pageUpdation = [[LUExamDataManager getSharedInstance]ShowAllExam:@"Exam1" qno:];
    pageNoArray=[pageUpdation objectAtIndex:0];//
    qtypeID=[pageUpdation objectAtIndex:1];//
    Qtypename=[pageUpdation objectAtIndex:2];
    Qid=[pageUpdation objectAtIndex:3];
    Coreectoption=[pageUpdation objectAtIndex:4];
    PageImageArray=[pageUpdation objectAtIndex:5];//
    Qnumber=[pageUpdation objectAtIndex:6];
    NSString *imageString;

 
    
//NSString*pageno,*qtype,*qtypeid,*qtypename,*qid,*correctoption,*pageimage,*qno;
    NSMutableArray*ExamdescriptionBody=[[NSMutableArray alloc]init];
    for (int i=0; i<pageNoArray.count; i++)
    {
       
        pageno=[pageNoArray objectAtIndex:i];
        qtypeid=[ qtypeID objectAtIndex:i];
         qid=[Qid objectAtIndex:i];
        pageimage=[[PageImageArray objectAtIndex:i]base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];//image base64
        NSMutableDictionary*ExamDict=[[NSMutableDictionary alloc]init];//dict
        [ExamDict setValue:qid forKey:@"Id"];
        [ExamDict setValue:qtypeid forKey:@"type"];
        [ExamDict setValue:pageno forKey:@"pagenumber"];
        [ExamDict setValue: pageimage forKey:@"TestImageUrl"];
        [ExamdescriptionBody addObject:ExamDict];//array
    }
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
        [body setObject:_examID forKey:@"TestId"];
        [body setObject:ExamdescriptionBody forKey:@"TestDescription"];
   
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall = self;
    [sharedSingleton Examsubmit: body];
    
//    for (int i=0; i<dbNameCache.count; i++)
//    {
//        BOOL success  =  NO;
//        success  =  [[LUExamDataManager getSharedInstance]createExamDB:[dbNameCache objectAtIndex:i]];
//        pageUpdation  =  [[LUExamDataManager getSharedInstance]ShowAllExam:[dbNameCache objectAtIndex:i]];
//
//        //pageUpdation = [[LUExamDataManager getSharedInstance]ShowAllExam:[dbNameCache objectAtIndex:i]];
//        [pageNoArray addObject: [pageUpdation objectAtIndex:0]];
//        [PageImageArray addObject: [pageUpdation objectAtIndex:1]];
//
//
//
////        NSArray *drawings = [[DrawingDataManager getSharedInstance]viewAllArt:_DBName];
////        NSArray *artnameArr = [drawings objectAtIndex:0];
////        NSArray *artimageArr = [drawings objectAtIndex:1];
////        NSString *imageString;
////        if ([artnameArr containsObject:_artName]) {
////            [artnameArr indexOfObject:_artName];
////            imageString = [[artimageArr objectAtIndex: [artnameArr indexOfObject:_artName]] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
////            NSLog(@"%@",imageString);
////
////            NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
////            [body setObject:_stdntID forKey:@"StudentId"];
////
////            [body setObject:_ClassID forKey:@"ClassId"];
////
////            [body setObject:_artCatagory forKey:@"DrawingCategoryName"];
////            [body setObject:_artName forKey:@"DrawingName"];
////            [body setObject:imageString forKey:@"ImageUrl"];
////
////
////
////            LUOperation *sharedSingleton = [LUOperation getSharedInstance];
////            sharedSingleton.LUDelegateCall=self;
////            [sharedSingleton drawingSubmit: body];
////
//
//    }
//    if (!(PageImageArray.count<=0))
//    {
//        for (int i=0; i<PageImageArray.count; i++)
//        {
//          NSArray *temp = [PageImageArray objectAtIndex:i];
//            for (int i=0; i<temp.count; i++)
//            {
//                [PageImageArrayReview addObject:[temp objectAtIndex:i]];
//            }
//        }
//    }
//    if (dbNameCache.count ==0 && PageImageArray.count == 0)
//    {
//
//        _reviewBaseView.hidden = YES;
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"Alert !!"
//                                     message:@"You have not Written any anwers"
//                                     preferredStyle:UIAlertControllerStyleAlert];
//
//        //Add Buttons
//
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"Yes"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//
//                                    }];
//
//
//
//        [alert addAction:yesButton];
//
//
//        [self presentViewController:alert animated:YES completion:nil];
//    }else
//    {
//        _reviewBaseView.hidden = NO;
//
//        _answerImage.image = [UIImage imageWithData:[PageImageArrayReview objectAtIndex:currentPage]];
//        pageNoLbl.text = [NSString stringWithFormat:@"page %d of %d",currentPage+1,(int) [PageImageArrayReview count]];


}
- (IBAction)completeExam:(id)sender
{
        UIAlertController *alertController  =  [UIAlertController
                                              alertControllerWithTitle:@"Confirmation"
                                              message:@"Click confirm to submit your exam."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction  =  [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
    
                                       }];
    
        UIAlertAction *okAction  =  [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                      [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   ];
    
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
*/
}
- (IBAction)editExam:(id)sender
{
    _reviewBaseView.hidden = YES;
}
- (IBAction)previous:(id)sender
{
    currentPage--;
    if (currentPage<=-1)
    {
         _answerImage.image = [UIImage imageWithData:[PageImageArrayReview objectAtIndex:0]];
        currentPage=0;
    }
    else
    {
        _answerImage.image = [UIImage imageWithData:[PageImageArrayReview objectAtIndex:currentPage]];
        pageNoLbl.text = [NSString stringWithFormat:@"page %d of %d",currentPage+1,(int) [PageImageArrayReview count]];

    }
}

- (IBAction)Next:(id)sender
{
    currentPage++;
    if (!(currentPage>=PageImageArrayReview.count))
    {
        _answerImage.image = [UIImage imageWithData:[PageImageArrayReview objectAtIndex:currentPage]];
        pageNoLbl.text = [NSString stringWithFormat:@"page %d of %d",currentPage+1,(int) [PageImageArrayReview count]];

    }else
    {
        currentPage=(int) [PageImageArrayReview count];
    }
    
}

@end
