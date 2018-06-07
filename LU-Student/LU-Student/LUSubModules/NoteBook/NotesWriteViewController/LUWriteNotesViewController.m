//
//  WriteViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUWriteNotesViewController.h"
#import "LUNotesDrawingView.h"
#import "LUNotesMainDataManager.h"
#import "DrawingDataManager.h"
#import "LUExamDataManager.h"
@interface LUWriteNotesViewController ()<NOTESDrawingViewDelegate>

@end

@implementation LUWriteNotesViewController
{
    CGFloat RED,GREEN,BLUE,CPAlpha;
    __weak IBOutlet UIButton *Original;
    __weak IBOutlet UIButton *dark;
    __weak IBOutlet UIButton *medium;
    __weak IBOutlet UIButton *light;
    __weak IBOutlet UIButton *colorPickerbtnprw;
    
    //evaluation View
    
    __weak IBOutlet UITextField *eMarks;
    __weak IBOutlet UITextField *eDate;
    
    __weak IBOutlet UITextView *eRemark;
    
    ///
    
    CGStretchView *stretchImageView;

    NSArray *PageImageArray;
    NSArray *pageNoArray;
    NSArray*Qno;
    NSArray*qtype_id;
    NSArray*qtype_name;
    NSArray*qid;
    NSArray*correctoption;
    
    UIToolbar *toolbar;
    UIButton *colorBtn;
    int currentPageNo,totalPageNo,questionPageNo;
    NSInteger notesOpenViewTag;
    NSArray *pageUpdation;
    NSString *filteredUnitName ;
    UICollectionView *thumbnailCollection;
    LURulerView *rulerImageView;
    NSManagedObjectModel  *objectModel;
    NSManagedObjectContext *objectContext;
    NSTimer * autosave;
    NSMutableArray *questArray,*questNoArray;
    UIDatePicker *datePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _evaluationView.hidden = YES;
   // [self syncDb:_moduleName syncId:_subjectCategoryId studentId:_studentId];
    datePicker = [[UIDatePicker alloc]init];
    CGRect frame = datePicker.frame;
    frame.size.width = 300;
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self afterSync];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.DrawView.lineWidth = 2.0;
//    if (_isExam != YES)
//    {
//        [self openNotesPerview];
//        [self createColorButton];
//        _examQuestionView.hidden = YES;
//
//        _examViewBase.hidden = YES;
//        colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
//        NSLog(@"%@ %@ %@ %@ %@",_FlashCoverImage,_FlashSubjectName,_FlashUniteNo,_FlashUniteName,_FlashPageType);
//        [self initialExistance];
//        [self pageNoDisplayMethod];
//       // [self createToolBar];
//        [NSTimer scheduledTimerWithTimeInterval:3.0
//                                         target:self
//                                       selector:@selector(removeNotesPerview)
//                                       userInfo:nil
//                                        repeats:NO];
//
//    }else
//    {
//       // [self openNotesPerview];
//
//        [self createColorButton];
//       // [self createToolBar];
//
//        colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
//        NSLog(@"%@ %@ %@ %@ %@",_FlashCoverImage,_FlashSubjectName,_FlashUniteNo,_FlashUniteName,_FlashPageType);
//        [self initialExistance];
//
//        if (_fillQuestions.count<=0)
//        {
//            [self createPage];
//            [self pageNoDisplayMethod];
//
//            _examQuestionView.hidden = NO;
//            _examViewBase.hidden = NO;
//            _qNo.text = _ExamQuestionNo;
//            _question.text = _ExamQuestion;
//
//        }
//        else
//        {
//            _examQuestionView.hidden = YES;
//            _examViewBase.hidden = NO;
//            questArray = [[NSMutableArray alloc]init];
//            questNoArray = [[NSMutableArray alloc]init];
//
//            for (int i=0; i<_fillQuestions.count; i++)
//            {
//                NSDictionary *temp = [_fillQuestions objectAtIndex:i];
//                //NSDictionary *temp1 = [temp objectAtIndex:0];
//                [questNoArray addObject:[temp objectForKey:@"QuestionNumber"]];
//                [questArray addObject:[temp objectForKey:@"Question"]];
//            }
//            [self.fillTable reloadData];
//        }
//
//        [self removeNotesPerview];
//
//
//    }
//
}
-(void)afterSync
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.DrawView.lineWidth = 2.0;
    if (_isExam != YES)
    {
        [self openNotesPerview];
        [self createColorButton];
        _examQuestionView.hidden = YES;
        
        _examViewBase.hidden = YES;
        colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
        NSLog(@"%@ %@ %@ %@ %@",_FlashCoverImage,_FlashSubjectName,_FlashUniteNo,_FlashUniteName,_FlashPageType);
        [self initialExistance];
        [self pageNoDisplayMethod];
        // [self createToolBar];
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(removeNotesPerview)
                                       userInfo:nil
                                        repeats:NO];
        
    }else
    {
        // [self openNotesPerview];
        
        [self createColorButton];
        // [self createToolBar];
        
        colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
        NSLog(@"%@ %@ %@ %@ %@",_FlashCoverImage,_FlashSubjectName,_FlashUniteNo,_FlashUniteName,_FlashPageType);
        [self initialExistance];
        
        if (_fillQuestions.count<=0)
        {
            [self createPage];
            [self pageNoDisplayMethod];
            
            _examQuestionView.hidden = NO;
            _examViewBase.hidden = NO;
            _qNo.text = _ExamQuestionNo;
            _question.text = _ExamQuestion;
            
        }
        else
        {
            _examQuestionView.hidden = YES;
            _examViewBase.hidden = NO;
            _nxtBtn.hidden = YES;
            _prevBtn.hidden = YES;
            questArray = [[NSMutableArray alloc]init];
            questNoArray = [[NSMutableArray alloc]init];
            
            for (int i=0; i<_fillQuestions.count; i++)
            {
                NSDictionary *temp = [_fillQuestions objectAtIndex:i];
                //NSDictionary *temp1 = [temp objectAtIndex:0];
                [questNoArray addObject:[temp objectForKey:@"QuestionNumber"]];
                [questArray addObject:[temp objectForKey:@"Question"]];
            }
            [self.fillTable reloadData];
        }
        
        [self removeNotesPerview];
        
    }
    
}
-(void)syncDb:(NSString *)moduleName syncId:(NSString *)syncId studentId:(NSString *)stdid
{
    NSDictionary *syncBdy = @{@"ModuleName":_moduleName,@"SyncId":_subjectCategoryId,@"StudentId":_studentId};
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall = self;
    [sharedSingleton syncMyDb:DBSync body:syncBdy];
}
-(void) dbSync:(NSDictionary *)syncData
{
    NSLog(@"%@",[syncData objectForKey:@"item"]);
    for (int i=0; i<[[syncData objectForKey:@"item"] count]; i++)
    {
        
        [[[syncData objectForKey:@"item"]objectAtIndex:i ] objectForKey:@"AssignmentSubmissionDescription"];
    BOOL success  =  NO;
        UIImage* img  =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[syncData objectForKey:@"item"]objectAtIndex:i ] objectForKey:@"AssignmentSubmissionDescription"]]]];
    success = [[LUNotesMainDataManager getSharedInstance]save:_FlashUniteName pageno:[NSString stringWithFormat:@"%@", [[[syncData objectForKey:@"item"]objectAtIndex:i ] objectForKey:@"PageNumber" ]] pageimage:UIImagePNGRepresentation(img)];
    success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%@", [[[syncData objectForKey:@"item"]objectAtIndex:i ] objectForKey:@"PageNumber" ]] pageimage:UIImagePNGRepresentation(img)];
    NSLog(success ? @"Yes" : @"No");
}
    [self afterSync];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self NotesAutoSave];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    NSDictionary *profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    
    [autosave invalidate];
    
    if (!_isAssignment && !_isExam && !_isTeacherAssignment)
    {
        
        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
        pageNoArray = [pageUpdation objectAtIndex:0];
        PageImageArray = [pageUpdation objectAtIndex:1];
        NSString *imageString;
        NSString *assignmentTitle;
        NSMutableArray *assignmentBodyDetails = [[NSMutableArray alloc]init];
        for (int i = 0; i<pageNoArray.count; i++)
        {
            assignmentTitle = [pageNoArray objectAtIndex:i];
            imageString = [[PageImageArray objectAtIndex:i] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc]init];
            [bodyDictionary setValue:assignmentTitle forKey:@"pagenumber"];
            [bodyDictionary setValue:imageString forKey:@"NotesImageUrl"];
            [assignmentBodyDetails addObject:bodyDictionary];
        }
        NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
        [body setObject:_studentId forKey:@"StudentId"];
        [body setObject:_subjectCategoryId forKey:@"SubjectNotesCategoryId"];
        [body setObject:@"99" forKey:@"TeacherId"];
        [body setObject:[profileDetails objectForKey:@"ClassId"] forKey:@"ClassId"];
        [body setObject:[profileDetails objectForKey:@"SectionId"] forKey:@"SectionId"];
        [body setObject:assignmentBodyDetails forKey:@"pageData"];

        
        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
        sharedSingleton.LUDelegateCall = self;
        [sharedSingleton notesSubmit: body];
        
    }
     if (_isExam == YES)
     {
//[LUUtilities saveNotes:_FlashUniteName pageNumber:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageImage:[self captureView:self.DrawView.bounds]];
         
         BOOL success  =  NO;
         UIImage* img  =  [self captureView:self.DrawView.bounds];
         //success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageimage:UIImagePNGRepresentation(img)];
         
         //updateExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName
         
         success=[[LUExamDataManager getSharedInstance]updateExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo]  QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img) questionno:_FlashUniteName DB:_DBname];
         
         
         //update:(NSString*)dbName pageno:(NSString*)pageNo pageimage:(NSData *)pageImage
         
         //saveExamDB:_FlashUniteName QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img)  pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo,1] DB:_DBname] ;

        
         NSLog(success ? @"Yes" : @"No");

     }
    if (_isAssignment)
    {
        BOOL success  =  NO;
        UIImage* img  =  [self captureView:self.DrawView.bounds];
        success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%d", currentPageNo] pageimage:UIImagePNGRepresentation(img)];
        NSLog(success ? @"Yes" : @"No");

    }
    if (_isTeacherAssignment)
    {
        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
        pageNoArray = [pageUpdation objectAtIndex:0];
        PageImageArray = [pageUpdation objectAtIndex:1];
        NSString *imageString;
        NSString *assignmentTitle;
        NSMutableArray *assignmentBodyDetails = [[NSMutableArray alloc]init];
        for (int i = 0; i<pageNoArray.count; i++)
        {
            assignmentTitle = [pageNoArray objectAtIndex:i];
            imageString = [[PageImageArray objectAtIndex:i] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc]init];
            [bodyDictionary setValue:assignmentTitle forKey:@"pagenumber"];
            [bodyDictionary setValue:imageString forKey:@"AssignmentImageUrl"];
            [assignmentBodyDetails addObject:bodyDictionary];
        }
        NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
        [body setObject:_subjectCategoryId forKey:@"AssignmentId"];
        NSString *newStr = @"";
        if (newStr.length>0) {
            [body setObject:newStr forKey:@"AssignmentSubmissionAttachment"];
        }else
        {
            [body setObject:@"" forKey:@"AssignmentSubmissionAttachment"];
        }
        [body setObject:_studentId forKey:@"StudentId"];
        [body setObject:@"" forKey:@"AttachmentType"];
        [body setObject:assignmentBodyDetails forKey:@"AssignmentSubmissionDescription"];
        
        
        
        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
        sharedSingleton.LUDelegateCall = self;
        [sharedSingleton assignmentSubmit:body];
    }
}
- (void) assignmentSubmit: (NSDictionary *)assignmentSubmitDetails
{
    
    
 /*   {
        "StudentId":"1",
        "AssignmentId":"10",
        "Status":"Redo",
        "AssignmentSubmissionMark" : "",
        "AssignmentReviewComment":"Change",
        "AssignmentDueDate":"2017-11-28"
    }
  */
 _evaluationView.hidden = NO;

 NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
     [body setObject:_studentId forKey:@"StudentId"];
    [body setObject:_subjectCategoryId forKey:@"AssignmentId"];
    [body setObject:@"" forKey:@"Status"];
    [body setObject:@"" forKey:@"AssignmentSubmissionMark"];
    [body setObject:@"" forKey:@"AssignmentReviewComment"];
    [body setObject:@"" forKey:@"AssignmentDueDate"];
    
    

}
- (IBAction)eStatus:(id)sender
{
    UIButton *estatus  =  (UIButton*)sender;
    switch(estatus.tag)
    {
            case 100:
            
            break;
            case 101:
            
            break;
            case 102:
            
            break;
    }
    
}





-(void)updateTextField:(id)sender
{
//    self.assignmentDuedateTextBox.text = [NSString stringWithFormat:@"%@",datePicker.date];
//    datePicker.minimumDate=[NSDate date];
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    self.assignmentDuedateTextBox.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
//    [self.assignmentDuedateTextBox resignFirstResponder];
}
#pragma Create button

/**
 <#Description#>
 */
-(void)createColorButton
{
    colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 32, 32)];
    [colorBtn.layer setCornerRadius:16];
    [colorBtn addTarget:self action:@selector(ColorPicker:) forControlEvents:UIControlEventTouchUpInside];
    colorBtn.tag  =  2;
    colorBtn.backgroundColor = _DrawView.lineColor;
}



#pragma mark - Create Toolbar
/**
 <#Description#>
 */
- (void) createToolBar
{
    toolbar  =  [UIToolbar new];
    toolbar.barStyle  =  UIBarStyleDefault;
    [toolbar setTranslucent:NO];
    [toolbar sizeToFit];
    toolbar.frame  =  CGRectMake(0,65, self.view.bounds.size.width, 70);
    
    //Add tool bar buttons
    // Drawing tool bar items are added to the toolbar
    
    UIBarButtonItem *undoToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"undo-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(undo:)];
    
    UIBarButtonItem *redoToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"redo-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(redo:)];
    
    
    UIBarButtonItem *thumbnailToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"thumbnail"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(thumbnailAction:)];
    [thumbnailToolBarItem setTag:1];
    
    colorBtn.backgroundColor = _DrawView.lineColor;
    UIBarButtonItem *colorToolBarItem  =  [[UIBarButtonItem alloc] initWithCustomView:colorBtn];
    
    UIBarButtonItem *insertImageToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"insert"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(insertImage:)];
        [insertImageToolBarItem setTag:3];
    
    UIBarButtonItem *rulerToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Scale.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rulerAction:)];
    
    UIBarButtonItem *pencilToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"brush"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(write:)];
    [pencilToolBarItem setTag:5];
    
    
    ///
    UIBarButtonItem *pencilCorrectionToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"brush"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(write:)];
    [pencilCorrectionToolBarItem setTag:6];
    ///
    
    
    UIBarButtonItem *heighlightToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"highlighter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(HighlightWriting:)];
    
    UIBarButtonItem *eraserToolBarItem  =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"eraser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(eraseWriting:)];
    
    //  UIBarButtonItem *addItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(eraseWriting:)];
    
    
    
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    UIBarButtonItem *fixedSpaceItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
    
    fixedSpaceItem.width  =  20; //Add spacing between UIToolbar
    
    
    
    if (_isExam == YES) {
        
        //Add buttons to the array
        NSArray *items  =  [NSArray arrayWithObjects: fixedSpaceItem, undoToolBarItem, fixedSpaceItem, redoToolBarItem, flexItem,fixedSpaceItem,thumbnailToolBarItem, fixedSpaceItem, colorToolBarItem, fixedSpaceItem, rulerToolBarItem, fixedSpaceItem, pencilToolBarItem, fixedSpaceItem, heighlightToolBarItem, fixedSpaceItem,eraserToolBarItem, fixedSpaceItem,/* addItem,*/ fixedSpaceItem, nil];
        
//      add array of buttons to toolbar
        [toolbar setItems:items animated:NO];
    } else if (_isCorrection == YES)
    {
        //    Add buttons to the array
        NSArray *items  =  [NSArray arrayWithObjects: fixedSpaceItem, undoToolBarItem, fixedSpaceItem, redoToolBarItem, flexItem,fixedSpaceItem,
                            thumbnailToolBarItem, fixedSpaceItem, pencilCorrectionToolBarItem, fixedSpaceItem, fixedSpaceItem, nil];
        
        //add array of buttons to toolbar
        [toolbar setItems:items animated:NO];

    }
    else
   {
       //    Add buttons to the array
    NSArray *items  =  [NSArray arrayWithObjects: fixedSpaceItem, undoToolBarItem, fixedSpaceItem, redoToolBarItem, flexItem,fixedSpaceItem,
                        thumbnailToolBarItem, fixedSpaceItem, colorToolBarItem, fixedSpaceItem, insertImageToolBarItem, fixedSpaceItem, rulerToolBarItem, fixedSpaceItem, pencilToolBarItem, fixedSpaceItem, heighlightToolBarItem, fixedSpaceItem,eraserToolBarItem, fixedSpaceItem,/* addItem,*/ fixedSpaceItem, nil];
  
       //add array of buttons to toolbar
    [toolbar setItems:items animated:NO];
    }

    CALayer *bottomBorder  =  [CALayer layer];
    
    bottomBorder.frame  =  CGRectMake(0.0f, toolbar.frame.size.height - 1.0f, toolbar.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor  =  [[UIColor blackColor] CGColor];//[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [toolbar.layer addSublayer:bottomBorder];
    
    [self.view addSubview:toolbar];
    
}
//
//static NSArray * extracted(LUWriteNotesViewController *object) {
//    return [[LUExamDataManager getSharedInstance]ShowAllExam:object->_DBname];
//}

/**
 <#Description#>
 */
-(void)initialExistance
{
    [self createPage];
    
    if (_isExam==YES)
    {
        //-(NSArray*)ShowAllExam:(NSString*)DBName
//        [returnArray addObject:Qno];
//        [returnArray addObject:Qtype_id];
//        [returnArray addObject:Qtype_name];
//        [returnArray addObject:QId];
//        [returnArray addObject:Correct_Option];
//        [returnArray addObject:Page_image];
//        [returnArray addObject:page_no];
//        
        //[returnArray addObject:DName];
       // [returnArray addObject:DArt];
        
        pageUpdation=[[LUExamDataManager getSharedInstance]ShowAllExam:_DBname qno:_FlashUniteName];
        pageNoArray=[pageUpdation objectAtIndex:0];
        qtype_id=[pageUpdation objectAtIndex:1];
        qtype_name=[pageUpdation objectAtIndex:2];
        qid=[pageUpdation objectAtIndex:3];
        correctoption=[pageUpdation objectAtIndex:4];
        PageImageArray=[pageUpdation objectAtIndex:5];
        Qno=[pageUpdation objectAtIndex:6];
        
//        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
//        pageNoArray = [pageUpdation objectAtIndex:0];
//        PageImageArray = [pageUpdation objectAtIndex:1];
    }
    
    else{
    pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
    pageNoArray = [pageUpdation objectAtIndex:0];
    PageImageArray = [pageUpdation objectAtIndex:1];
    }
    
    if (pageNoArray.count == 0)
    {
        BOOL success  =  NO;
        UIImage* img  =  [self captureView:self.DrawView.bounds];
        if (_isExam == YES)
        {
            NSLog(@"%@",_QuestionType_Id);
           // success = [[LUNotesMainDataManager getSharedInstance]save:_FlashUniteName pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo,1] pageimage:UIImagePNGRepresentation(img)];
            
            //saveExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName
            
            success=[[LUExamDataManager getSharedInstance]saveExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo,1] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img)  questionno:_FlashUniteName DB:_DBname];

            
            
           
        }else
        {
            success = [[LUNotesMainDataManager getSharedInstance]save:_FlashUniteName pageno:@"1" pageimage:UIImagePNGRepresentation(img)];
            
            
        }
        
        NSLog(success ? @"Yes" : @"No");
        currentPageNo = 1;
        pageUpdation=[[LUExamDataManager getSharedInstance]ShowAllExam:_DBname qno:_FlashUniteName];
        
        pageNoArray=[pageUpdation objectAtIndex:0];
        qtype_id=[pageUpdation objectAtIndex:1];
        qtype_name=[pageUpdation objectAtIndex:2];
        qid=[pageUpdation objectAtIndex:3];
        correctoption=[pageUpdation objectAtIndex:4];
        PageImageArray=[pageUpdation objectAtIndex:5];
        Qno=[pageUpdation objectAtIndex:6];
        ///
//        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
//        pageNoArray = [pageUpdation objectAtIndex:0];
//        PageImageArray = [pageUpdation objectAtIndex:1];
        [self pageNoDisplayMethod];
    }
    else
    {
        CGRect drawView  =  [_DrawView.layer bounds];
        UIGraphicsBeginImageContextWithOptions(drawView.size,YES,0.0f);
        [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  lastObject]]] drawInRect:_DrawView.bounds];
        UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_DrawView loadImage:image];
        
        currentPageNo = (int)PageImageArray.count;
        [self pageNoDisplayMethod];
        
    }
   // autosave = [NSTimer scheduledTimerWithTimeInterval:2.0
   //                                             target:self
   //                                           selector:@selector(NotesAutoSave)
   //                                           userInfo:nil
    //                                           repeats:YES];
}


/**
 <#Description#>

 @param pageno <#pageno description#>
 */
-(void)NotesSave:(NSString*)pageno
{
    if (_isExam==YES)
    {
        pageUpdation=[[LUExamDataManager getSharedInstance]ShowAllExam:_DBname qno:_FlashUniteName];
        
        pageNoArray=[pageUpdation objectAtIndex:0];
        qtype_id=[pageUpdation objectAtIndex:1];
        qtype_name=[pageUpdation objectAtIndex:2];
        qid=[pageUpdation objectAtIndex:3];
        correctoption=[pageUpdation objectAtIndex:4];
        PageImageArray=[pageUpdation objectAtIndex:5];
        Qno=[pageUpdation objectAtIndex:6];
        
    }
    
    else
    {
        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
        pageNoArray = [pageUpdation objectAtIndex:0];
        PageImageArray = [pageUpdation objectAtIndex:1];
        
        
    }
    
    if (![pageNoArray containsObject:pageno])
    {
        BOOL success  =  NO;
        UIImage* img  =  [self captureView:self.DrawView.bounds];
        if (_isExam==YES)
        {
           // success=[[LUExamDataManager getSharedInstance]saveExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo,1] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img)  questionno:_FlashUniteName DB:_DBname];
            
            success=[[LUExamDataManager getSharedInstance]saveExamDB:pageno  QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img) questionno:_FlashUniteName DB:_DBname];
            
             NSLog(success ? @"Yes" : @"No");
            pageUpdation=[[LUExamDataManager getSharedInstance]ShowAllExam:_DBname qno:_FlashUniteName];
            pageNoArray = [pageUpdation objectAtIndex:0];
            [self pageNoDisplayMethod];
            
        }
        else{
        success = [[LUNotesMainDataManager getSharedInstance]save:_FlashUniteName pageno:pageno pageimage:UIImagePNGRepresentation(img)];
        NSLog(success ? @"Yes" : @"No");
        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
        pageNoArray = [pageUpdation objectAtIndex:0];
        [self pageNoDisplayMethod];
        }
    }
    else
    {
        CGRect drawView  =  [_DrawView.layer bounds];
        UIGraphicsBeginImageContext(drawView.size);
        [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  objectAtIndex:[pageNoArray indexOfObject:pageno]]]] drawInRect:_DrawView.bounds];
        UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_DrawView loadImage:image];
    }
    
    
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)PreviousPage:(id)sender
{
    
    if (_isExam ==YES) {
        
        
        // [self NotesAutoSave];
        
       // [LUUtilities saveNotes:_FlashUniteName pageNumber:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageImage:[self captureView:self.DrawView.bounds]];
        
        BOOL success  =  NO;
        UIImage* img  =  [self captureView:self.DrawView.bounds];
        
        if (_isExam==YES)
        {
            //questionno:_FlashUniteName
            success=[[LUExamDataManager getSharedInstance]saveExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img) questionno:_FlashUniteName DB:_DBname];
            //updateExamDB
            success=[[LUExamDataManager getSharedInstance]updateExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img) questionno:_FlashUniteName DB:_DBname];
        }
        else
        {
        success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageimage:UIImagePNGRepresentation(img)];
        NSLog(success ? @"Yes" : @"No");
        }
        
        currentPageNo = currentPageNo-1;
        if ((!currentPageNo) == 0)
        {
            _previewWrite.image = nil;
            [_DrawView clear];
            
            CGRect drawView  =  [_DrawView.layer bounds];
            UIGraphicsBeginImageContext(drawView.size);
            [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  objectAtIndex:[pageNoArray indexOfObject:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo]]]]] drawInRect:_DrawView.bounds];
            UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [_DrawView loadImage:image];
            [self pageNoDisplayMethod];
            
        }
        else
        {
            currentPageNo = 1;
            [self pageNoDisplayMethod];
            
        }
    }else
        
    {
        
         [self NotesAutoSave];
        currentPageNo = currentPageNo-1;
        if ((!currentPageNo) == 0)
        {
            _previewWrite.image = nil;
            [_DrawView clear];
            
            CGRect drawView  =  [_DrawView.layer bounds];
            UIGraphicsBeginImageContext(drawView.size);
            [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  objectAtIndex:[pageNoArray indexOfObject:[NSString stringWithFormat:@"%d",currentPageNo]]]]] drawInRect:_DrawView.bounds];
            UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [_DrawView loadImage:image];
            [self pageNoDisplayMethod];
            
        }
        else
        {
            currentPageNo = 1;
            [self pageNoDisplayMethod];
            
        }
        
    }
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)NextPage:(id)sender
{
    if (_isExam == YES)
    {
        [self NotesAutoSave];
        
        //[LUUtilities saveNotes:_FlashUniteName pageNumber:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageImage:[self captureView:self.DrawView.bounds]];
        
        BOOL success  =  NO;
        UIImage* img  =  [self captureView:self.DrawView.bounds];
        
        //updateExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName
        
        success=[[LUExamDataManager getSharedInstance]updateExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img) questionno:_FlashUniteName DB:_DBname];
        //success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] pageimage:UIImagePNGRepresentation(img)];
        NSLog(success ? @"Yes" : @"No");
        
        [self NotesSave:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo]];
        currentPageNo = currentPageNo+1;
       
        _previewWrite.image = nil;
        [_DrawView clear];
        if (currentPageNo<=  PageImageArray.count)
        {
            [self pageNoDisplayMethod];
            CGRect drawView  =  [_DrawView.layer bounds];
            UIGraphicsBeginImageContext(drawView.size);
            [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  objectAtIndex:[pageNoArray indexOfObject:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo]]]]] drawInRect:_DrawView.bounds];
            UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [_DrawView loadImage:image];
        }
        [self NotesSave:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo]];
        [self pageNoDisplayMethod];
    }else
    {
       [self NotesAutoSave];
        [self NotesSave:[NSString stringWithFormat:@"%d",currentPageNo]];
        currentPageNo = currentPageNo+1;
        _previewWrite.image = nil;
        [_DrawView clear];
        if (currentPageNo<=  PageImageArray.count)
        {
            [self pageNoDisplayMethod];
            CGRect drawView  =  [_DrawView.layer bounds];
            UIGraphicsBeginImageContext(drawView.size);
            [[UIImage imageWithData:[NSData dataWithData:[PageImageArray  objectAtIndex:[pageNoArray indexOfObject:[NSString stringWithFormat:@"%d",currentPageNo]]]]] drawInRect:_DrawView.bounds];
            UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [_DrawView loadImage:image];
        }
        [self NotesSave:[NSString stringWithFormat:@"%d",currentPageNo]];
        [self pageNoDisplayMethod];
    }
}

/**
 <#Description#>
 */
-(void)NotesAutoSave
{
    
    [LUUtilities saveNotes:_FlashUniteName pageNumber:[NSString stringWithFormat:@"%d",currentPageNo] pageImage:[self captureView:self.DrawView.bounds]];
    
    
    
    BOOL success  =  NO;
    
    UIImage* img  =  [self captureView:self.DrawView.bounds];
   
    if (_isExam==YES)
    {
        //questionno:_FlashUniteName
        
         [[LUExamDataManager getSharedInstance]saveExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img)  questionno:_FlashUniteName DB:_DBname];
        
        success=[[LUExamDataManager getSharedInstance]updateExamDB:[NSString stringWithFormat:@"%@.%d",_ExamQuestionNo, currentPageNo] QusetiontypeId:_QuestionType_Id QusetiontypeName:@"" QusetionId:_Question_Id Correctoption:@"" Pageimage:UIImagePNGRepresentation(img)  questionno:_FlashUniteName DB:_DBname];

    }
    else{
        
        success = [[LUNotesMainDataManager getSharedInstance]update:_FlashUniteName pageno:[NSString stringWithFormat:@"%d",currentPageNo] pageimage:UIImagePNGRepresentation(img)];
        
        
    }
    //
    
    //(BOOL)update:(NSString*)dbName pageno:(NSString*)pageNo pageimage:(NSData *)pageImage
    //updateExamDB:(NSString*)QNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage pageno:(NSString *)PageNo DB:(NSString *)DBName  ;

    NSLog(success ? @"Yes" : @"No");
}

/**
 <#Description#>
 */
-(void)openNotesPerview
{
    UIImage *previewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_FlashCoverImage]]];
    _previewNotesImage.image = previewImage;
    _previewSubject_Name.text = _FlashSubjectName;
    _previewUnit_No.text = _FlashUniteNo;
    _previewUnit_name.text = _FlashUniteName;
}

/**
 <#Description#>
 */
-(void)removeNotesPerview
{
    
    
    [self createToolBar];
    [_previewNotesView removeFromSuperview];
    [_previewNotesImage removeFromSuperview];
    [_previewSubject_Name removeFromSuperview];
    [_previewUnit_No removeFromSuperview];
    [_previewUnit_name removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 <#Description#>
 */
-(void)createPage
{
    
    if ([_FlashPageType isEqual:@"Ruled"])
    {
        _PageType_view.Type = @"Ruled";
    }
    else if ([_FlashPageType isEqual:@"Checked"])
    {
        _PageType_view.Type = @"Checked";
    }
    else if ([_FlashPageType isEqual:@"Ruled Activity"])
    {
        _PageType_view.Type = @"Ruled Activity";
    }
    else if ([_FlashPageType isEqual:@"Plain Activity"])
    {
        _PageType_view.Type = @"Plain Activity";
    }
    else if ([_FlashPageType isEqual:@"Left margin"])
    {
        _PageType_view.Type = @"Left margin";
    }
    else if ([_FlashPageType isEqual:@"cursive"])
    {
        _PageType_view.Type = @"cursive";
    }
    else if ([_FlashPageType isEqual:@"graph"])
    {
        _PageType_view.Type = @"graph";
    }
    else if ([_FlashPageType isEqual:@"Plain"])
    {
        _PageType_view.Type = @"Plain";
    }
    else if ([_FlashPageType isEqual:@"Diary"])
    {
        _PageType_view.Type = @"Diary";
        _TimeDateStamp.hidden = YES;
        _PageNoLbl.hidden = YES;
        
        NSDateComponents *components  =  [[NSCalendar currentCalendar] components:NSCalendarUnitDay | kCFCalendarUnitWeekday |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        NSInteger day  =  [components day];
        NSInteger tempMonth  =  [components month];
        NSInteger year  =  [components year];
        NSInteger tempweek = [components weekday];
        NSString *month;
        NSString *weekday;
        
        switch (tempMonth)
        {
            case 1:
                month = @"January";
                break;
            case 2:
                month = @"February";
                break;
            case 3:
                month = @"March";
                break;
            case 4:
                month = @"April";
                break;
            case 5:
                month = @"May";
                break;
            case 6:
                month = @"June";
                break;
            case 7:
                month = @"July";
                break;
            case 8:
                month = @"August";
                break;
            case 9:
                month = @"September";
                break;
            case 10:
                month = @"October";
                break;
            case 11:
                month = @"November";
                break;
            case 12:
                month = @"December";
                break;
        }
        switch (tempweek)
        {
            case 1:
                weekday = @"Sunday";
                break;
            case 2:
                weekday = @"Monday";
                break;
            case 3:
                weekday = @"Tuesday";
                break;
            case 4:
                weekday = @"Wednesday";
                break;
            case 5:
                weekday = @"Thursday";
                break;
            case 6:
                weekday = @"Friday";
                break;
            case 7:
                weekday = @"Saturday";
                break;
                
        }
        _DiaryDay.text = [NSString stringWithFormat:@"%ld",(long)day];
        _DiaryMonth.text = month;
        _DiaryYear.text = [NSString stringWithFormat:@"%ld",(long)year];
        _DiaryWeek.text = weekday;
    }
    [_PageType_view setNeedsDisplay];
}
#pragma open the tools UIView on button click
/**
 <#Description#>

 @param sender <#sender description#>
 */
-(void) openToolViewDisplay:(id)sender
{
    [self closeToolViewDisplayed];
    notesOpenViewTag = [sender tag];
    UIBarButtonItem *toolTag = (UIBarButtonItem*)sender;
    switch (toolTag.tag)
    {
        case 1:
        {
            //            _FontStyleTopOffset.constant  = 136;
            //            [UIView animateWithDuration:1.0 animations:^{
            //                [_textStyleView layoutIfNeeded];
            //            }];
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _thumbnailView.frame = CGRectMake(_thumbnailView.frame.origin.x, _thumbnailView.frame.origin.y + 760, _thumbnailView.frame.size.width, _thumbnailView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 2://opens the shape UIView
        {
            //            _clipArtTopOffset.constant  = 143;
            //
            //            [UIView animateWithDuration:1.0 animations:^{
            //                [_clipArtView layoutIfNeeded];
            //            }];
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _ColorPickerView.frame = CGRectMake(_ColorPickerView.frame.origin.x, _ColorPickerView.frame.origin.y + 250, _ColorPickerView.frame.size.width, _ColorPickerView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
            
        }
            break;
        case 3: //opens the colorPicker
        {
            
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _insertImageView.frame = CGRectMake(_insertImageView.frame.origin.x, _insertImageView.frame.origin.y + 99, _insertImageView.frame.size.width, _insertImageView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 4: // open write tool select UIVew
        {
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _InsertImageThumbnailView.frame = CGRectMake(_InsertImageThumbnailView.frame.origin.x, _InsertImageThumbnailView.frame.origin.y + 700, _InsertImageThumbnailView.frame.size.width, _InsertImageThumbnailView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 5:// open eraser UIVew
        {
            _DrawView.drawTool = NOTESDrawingToolTypePen;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _WriteToolSelectView.frame = CGRectMake(_WriteToolSelectView.frame.origin.x, _WriteToolSelectView.frame.origin.y + 60, _WriteToolSelectView.frame.size.width, _WriteToolSelectView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
        case 6:// open eraser UIVew
        {
            _DrawView.drawTool = NOTESDrawingToolTypePen;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _correctionWriteToolSelectView.frame = CGRectMake(_correctionWriteToolSelectView.frame.origin.x, _correctionWriteToolSelectView.frame.origin.y + 60, _correctionWriteToolSelectView.frame.size.width, _correctionWriteToolSelectView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
        }
            break;
    }
}
#pragma close the tools UIView on button click
/**
 <#Description#>

 @return <#return value description#>
 */
-(BOOL) closeToolViewDisplayed
{
    BOOL result = NO;
    switch (notesOpenViewTag)
    {
        case 1:
        {
            thumbtap = 0;
            //_FontStyleTopOffset.constant  = 49;
            
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _thumbnailView.frame = CGRectMake(_thumbnailView.frame.origin.x, _thumbnailView.frame.origin.y - 760, _thumbnailView.frame.size.width, _thumbnailView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                           [thumbnailCollection removeFromSuperview];
                                          //_animationInProgress = NO;
                                      }];
            
            
            return YES;
        }
            break;
        case 2:
        {
            colortap = 0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _ColorPickerView.frame = CGRectMake(_ColorPickerView.frame.origin.x, _ColorPickerView.frame.origin.y - 250, _ColorPickerView.frame.size.width, _ColorPickerView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            
            return YES;
        }
            break;
        case 3:
        {
            imageTap = 0;
            
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _insertImageView.frame = CGRectMake(_insertImageView.frame.origin.x, _insertImageView.frame.origin.y - 99, _insertImageView.frame.size.width, _insertImageView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
        case 4:
        {
            insertImagetap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _InsertImageThumbnailView.frame = CGRectMake(_InsertImageThumbnailView.frame.origin.x, _InsertImageThumbnailView.frame.origin.y - 700, _InsertImageThumbnailView.frame.size.width, _InsertImageThumbnailView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
        case 5:
        {
            writetap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _WriteToolSelectView.frame = CGRectMake(_WriteToolSelectView.frame.origin.x, _WriteToolSelectView.frame.origin.y - 60, _WriteToolSelectView.frame.size.width, _WriteToolSelectView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
        case 6:
        {
            writetap  =  0;
            [UIView animateKeyframesWithDuration:1.0
                                           delay:0.0
                                         options:0
                                      animations:^{
                                          _correctionWriteToolSelectView.frame = CGRectMake(_correctionWriteToolSelectView.frame.origin.x, _correctionWriteToolSelectView.frame.origin.y - 60, _correctionWriteToolSelectView.frame.size.width, _correctionWriteToolSelectView.frame.size.height);
                                      }
                                      completion:^(BOOL finished) {
                                          //_animationInProgress = NO;
                                      }];
            return YES;
        }
            break;
            
    }
    return  result;
}

/**
 <#Description#>
 */
-(void)updateButtonStatus
{
    self.undo.enabled = [self.DrawView canUndo];
    self.redo.enabled = [self.DrawView canRedo];
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)undo:(id)sender
{
    [self.DrawView undoLatestStep];
    [self updateButtonStatus];
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)redo:(id)sender
{
    [self.DrawView redoLatestStep];
    [self updateButtonStatus];
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)eraseWriting:(id)sender
{
    self.DrawView.lineWidth = 40.0;
    self.DrawView.drawTool = NOTESDrawingToolTypeEraser;
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)HighlightWriting:(id)sender
{
    self.DrawView.lineAlpha = 0.2;
    self.DrawView.drawTool = NOTESDrawingToolTypeRectagleFill;
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)WriteToolAction:(id)sender
{
    UIButton *toolselected  =  (UIButton*)sender;
    switch(toolselected.tag)
    {
        case 1:
            
            self.DrawView.lineWidth = 2.0;
            
            break;
        case 2:
            
            self.DrawView.lineWidth = 4.0;
            
            break;
            
        case 3:
            
            self.DrawView.lineWidth = 6.0;
            
            break;
    }
    
    self.DrawView.drawTool = NOTESDrawingToolTypePen;
    [self closeToolViewDisplayed];
    notesOpenViewTag=-1;
}
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)WriteCorrectionToolAction:(id)sender
{
    UIButton *toolselected  =  (UIButton*)sender;
    switch(toolselected.tag)
    {
        case 1:
            
            self.DrawView.lineWidth = 2.0;
            self.DrawView.lineColor = [UIColor redColor];
            
            break;
        case 2:
            
            self.DrawView.lineWidth = 2.0;
            
            self.DrawView.lineColor = [UIColor blueColor];
            break;
            
        case 3:
            
            self.DrawView.lineWidth = 2.0;
            
            self.DrawView.lineColor = [UIColor greenColor];
            break;
    }
    
    self.DrawView.drawTool = NOTESDrawingToolTypePen;
    [self closeToolViewDisplayed];
    notesOpenViewTag=-1;
}

///////////
int colortap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)ColorPicker:(id)sender
{
    // [self closeWriteTool];
    //  [self closeInsertImage];
    //  [self closeThumbnail];
    colortap++;
    if (colortap == 1)
    {
        [self openToolViewDisplay:sender];
        //        self.colorPickerTopOffet.constant  =  142;
        //
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_ColorPickerView layoutIfNeeded];
        //        }];
    }
    else if (colortap == 2)
    {
        colortap = 0;
        [self closeToolViewDisplayed];
        notesOpenViewTag = -1;
        //        self.colorPickerTopOffet.constant  =  -114;
        //
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_ColorPickerView layoutIfNeeded];
        //        }];
    }
}

/**
 <#Description#>
 */
-(void)closeColorPicker
{
    colortap = 0;
    self.colorPickerTopOffet.constant  =  -114;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_ColorPickerView layoutIfNeeded];
    }];
}

///////////////
int imageTap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)insertImage:(id)sender
{
    // [self closeColorPicker];
    //[self closeWriteTool];
    // [self closeThumbnail];
    imageTap++;
    if (imageTap == 1)
    {
        [self openToolViewDisplay:sender];
        
        //        self.insertImageTopOffset.constant  =  142;
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_insertImageView layoutIfNeeded];
        //        }];
    }
    else if (imageTap == 2)
    {
        imageTap = 0;
        [self closeToolViewDisplayed];
        notesOpenViewTag = -1;
        //        self.insertImageTopOffset.constant  =  35;
        //
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_insertImageView layoutIfNeeded];
        //        }];
    }
}

/**
 <#Description#>
 */
-(void)closeInsertImage
{
    imageTap = 0;
    self.insertImageTopOffset.constant  =  35;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_insertImageView layoutIfNeeded];
    }];
}

//////////
int writetap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)write:(id)sender
{
    //[self closeColorPicker];
    //[self closeInsertImage];
    //[self closeThumbnail];
    writetap++;
    if (writetap == 1)
    {
        [self openToolViewDisplay:sender];
        //        self.topoffset.constant  =  142;
        //
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_WriteToolSelectView layoutIfNeeded];
        //        }];
    }
    else if (writetap == 2)
    {
        writetap = 0;
        [self closeToolViewDisplayed];
        notesOpenViewTag = -1;
        //        self.topoffset.constant  = 77;
        //
        //        [UIView animateWithDuration:0.50 animations:^{
        //            [_WriteToolSelectView layoutIfNeeded];
        //        }];
    }
    
}


/**
 <#Description#>
 */
-(void)closeWriteTool
{
    writetap = 0;
    self.topoffset.constant  = 77;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_WriteToolSelectView layoutIfNeeded];
    }];
}

////////////
int thumbtap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)thumbnailAction:(id)sender
{
    [self NotesAutoSave];
    //[self closeColorPicker];
    // [self closeInsertImage];
    //  [self closeWriteTool];
    thumbtap++;
    if (thumbtap == 1)
    {
        pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:_FlashUniteName];
        pageNoArray = [pageUpdation objectAtIndex:0];
        PageImageArray = [pageUpdation objectAtIndex:1];
        [self pageForThumbnail];
        [self openToolViewDisplay:sender];
        
        //        self.thumbnailTopOffset.constant  = 133;
        //        [UIView animateWithDuration:1.0 animations:^{
        //            [_thumbnailView layoutIfNeeded];
        //        }];
    }
    else if (thumbtap == 2)
    {
       
        thumbtap = 0;
        [self closeToolViewDisplayed];
      //  [thumbnailCollection removeFromSuperview];
        notesOpenViewTag = -1;

                 [thumbnailCollection removeFromSuperview];
        //        self.thumbnailTopOffset.constant  = -626;
        //        [UIView animateWithDuration:1.0 animations:^{
        //            [_thumbnailView layoutIfNeeded];
        //        }];
    }
}

/**
 <#Description#>
 */
-(void)closeThumbnail
{
    
    thumbtap = 0;
    [self closeToolViewDisplayed];
    notesOpenViewTag = -1;

//    self.thumbnailTopOffset.constant  = -626;
//    [UIView animateWithDuration:0.50 animations:^{
//        [_thumbnailView layoutIfNeeded];
//    }];
    [thumbnailCollection removeFromSuperview];
}

////////////////
int insertImagetap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)insertImageThumbnailAction:(id)sender
{
    //[self closeInsertImage];
    insertImagetap++;
    if (insertImagetap == 1)
    {
        [[DrawingDataManager getSharedInstance]createDrawingDB:@"Drawing"];
        pageUpdation = [[DrawingDataManager getSharedInstance]viewAllArt:@"Drawing"];
        PageImageArray = [pageUpdation objectAtIndex:1];
        [self pageForInsert];
        [self openToolViewDisplay:sender];
        //        self.InsertImageViewTopOffset.constant  = 142;
        //
        //        [UIView animateWithDuration:1.0 animations:^{
        //            [_InsertImageThumbnailView layoutIfNeeded];
        //        }];
        
    }
    else if (insertImagetap == 2)
    {
        insertImagetap = 0;
        //self.InsertImageViewTopOffset.constant  = -566;
        [thumbnailCollection removeFromSuperview];
        notesOpenViewTag = -1;
        //[UIView animateWithDuration:1.0 animations:^{
        //    [_InsertImageThumbnailView layoutIfNeeded];
        //}];
        [self closeToolViewDisplayed];
    }
    
    
}
/**
 <#Description#>
 */
-(void)closeInsertImageThumbnail
{
    [thumbnailCollection removeFromSuperview];
    insertImagetap = 0;
    self.InsertImageViewTopOffset.constant  = -566;
    [UIView animateWithDuration:0.50 animations:^{
        [_InsertImageThumbnailView layoutIfNeeded];
    }];
}
///////////////////



///////////////////////
/*
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)pushToDraw:(id)sender
{
    LUStudentMainDrawingViewController *pushToDrawing = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentMainDrawingVC"];
    [self.navigationController pushViewController:pushToDrawing animated:YES];
    
}

///////////////////////


int rulerTap = 0;
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)rulerAction:(id)sender
{
    [self closeToolViewDisplayed];
    notesOpenViewTag=-1;
    rulerTap++;
    if (rulerTap == 1)
    {
        rulerImageView  =  [[LURulerView alloc] initWithFrame:CGRectMake(50, 400, 1300, 130)];
        rulerImageView.backgroundColor = [UIColor clearColor];
        rulerImageView.image  =  [UIImage imageNamed:@"ruler.png"];
        self.DrawView.drawTool = NOTESDrawingToolTypeLine;
        self.DrawView.lineWidth = 6.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:rulerImageView];
        });
    }
    else if(rulerTap == 2)
    {
        rulerTap = 0;
        [rulerImageView removeFromSuperview];
        self.DrawView.drawTool = NOTESDrawingToolTypePen;
    }
}

////////
/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)colorSelection:(id)sender
{
    UIButton *toolselected  =  (UIButton*)sender;
    switch(toolselected.tag)
    {
        case 100:
            
            RED = 253.0;
            GREEN = 83.0;
            BLUE = 8.0;
            break;
            
        case 101:
            
            RED = 251.0;
            GREEN = 153.0;
            BLUE = 2.0;
            
            break;
            
        case 102:
            RED = 250.0;
            GREEN = 188.0;
            BLUE = 2.0;
            break;
            
        case 103:
            RED = 255.0;
            GREEN = 255.0;
            BLUE = 0.0;
            
            break;
        case 104:
            
            RED = 208.0;
            GREEN = 234.0;
            BLUE = 43.0;
            
            break;
        case 105:
            
            RED = 102.0;
            GREEN = 176.0;
            BLUE = 50.0;
            
            break;
        case 106:
            RED = 3.0;
            GREEN = 145.0;
            BLUE = 206.0;
            
            break;
        case 107:
            
            RED = 2.0;
            GREEN = 71.0;
            BLUE = 254.0;
            
            break;
        case 108:
            
            RED = 61.0;
            GREEN = 1.0;
            BLUE = 164.0;
            
            break;
        case 109:
            
            RED = 134.0;
            GREEN = 1.0;
            BLUE = 175.0;
            
            break;
        case 110:
            
            RED = 167.0;
            GREEN = 25.0;
            BLUE = 75.0;
            
            break;
        case 111:
            
            RED = 254.0;
            GREEN = 39.0;
            BLUE = 18.0;
            
            break;
        case 112:
            
            RED = 0.0;
            GREEN = 0.0;
            BLUE = 0.0;
            
            break;
    }
    self.DrawView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1];
    self.DrawView.lineAlpha = CPAlpha;
    Original.backgroundColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1];
    dark.backgroundColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.8];
    medium.backgroundColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.6];
    light.backgroundColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.4];
    self.PreviewColor.textColor = [UIColor blackColor];
    //colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
    colorBtn.backgroundColor = _DrawView.lineColor;
    
}

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)ColorShadeAction:(id)sender
{
    
    UIButton *ColorSelect  =  (UIButton*)sender;
    switch(ColorSelect.tag)
    {
        case 200:
            self.DrawView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1];
            self.DrawView.lineAlpha = 1;
            break;
        case 201:
            self.DrawView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.8];
            self.DrawView.lineAlpha = 0.8;
            break;
        case 202:
            self.DrawView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.6];
            self.DrawView.lineAlpha = 0.6;
            break;
        case 203:
            self.DrawView.lineColor = [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:0.4];
            self.DrawView.lineAlpha = 0.4;
            break;
    }
    colorPickerbtnprw.backgroundColor = self.DrawView.lineColor;
}

/**
 <#Description#>
 */
-(void)pageNoDisplayMethod
{
    _PageNoLbl.text = [NSString stringWithFormat:@"Page %d / %lu",currentPageNo,(unsigned long)pageNoArray.count];
    
}

/**
 <#Description#>
 */
-(void)timeDateStamp
{
    int d =  [[LUOnlineExamDateFormatter getTheCurrentDate]intValue];
    int m =  [[LUOnlineExamDateFormatter getTheCurrentMonth]intValue];
    int y =  [[LUOnlineExamDateFormatter getTheCurrentYear]intValue];
    NSInteger H = [LUOnlineExamDateFormatter getTheCurrenthour];
    NSInteger M = [LUOnlineExamDateFormatter getTheCurrentminute];
    NSDateFormatter *formatter  =  [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar  =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLocale *usLocale  =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"a"];
    NSString *APM = [formatter stringFromDate:[NSDate date]];
    _TimeDateStamp.text = [NSString stringWithFormat:@"%ld.%ld %@   %d-%d-%d",(long)H,M,APM,d,m,y];
}

/**
 <#Description#>

 @param frame <#frame description#>
 @return <#return value description#>
 */
- (UIImage *)captureView:(CGRect)frame
{
    CGRect drawView  =  [_DrawView.layer bounds];
    UIGraphicsBeginImageContext(drawView.size );
    
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    //CGContextTranslateCTM(context, 0, -142);
    [_writeBaseView.layer renderInContext:context];
    UIImage *img  = nil;
    img  =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
    //    //CGRect drawView  =  [_DrawView bounds];
    //    CGRect pageTypeView = [_writeBaseView bounds];
    //    //UIGraphicsBeginImageContextWithOptions(drawView.size,YES,0.0f);
    //    UIGraphicsBeginImageContextWithOptions(pageTypeView.size,YES,0.0f);
    //    CGContextRef context  =  UIGraphicsGetCurrentContext();
    //    [_PageType_view.layer renderInContext:context];
    //    //[_DrawView.layer renderInContext:context];
    //    UIImage *screenshot  =  UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    return screenshot;
}

/**
 <#Description#>
 */
-(void)pageForThumbnail
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        thumbnailCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,1333,750) collectionViewLayout:layout];
        [thumbnailCollection setDataSource:self];
        [thumbnailCollection setDelegate:self];
        [thumbnailCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [thumbnailCollection setBackgroundColor:[UIColor clearColor]];
        [_thumbnailView addSubview:thumbnailCollection];
        [thumbnailCollection reloadData];
    });
}

/**
 <#Description#>
 */
-(void)pageForInsert
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        thumbnailCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,1333,690) collectionViewLayout:layout];
        [thumbnailCollection setDataSource:self];
        [thumbnailCollection setDelegate:self];
        [thumbnailCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [thumbnailCollection setBackgroundColor:[UIColor clearColor]];
        [_InsertImageThumbnailView addSubview:thumbnailCollection];
        [thumbnailCollection reloadData];
    });
}

#pragma mark CollectionView Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return PageImageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowOpacity = 0.5;
    
    UIImageView *pageview  =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    UIImage *tempimage = [UIImage imageWithData:[NSData dataWithData:[PageImageArray objectAtIndex:indexPath.row]]];
    pageview.image  =  tempimage;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell addSubview:pageview];
    });
    
    if (pageNoArray == nil)
    {
        
    }
    else
    {
        UILabel *pagenolbl  =  [[UILabel alloc] initWithFrame:CGRectMake(160, 160, 70, 30)];
        pagenolbl.textAlignment = 2;
        pagenolbl.text = [NSString stringWithFormat:@"Page %ld",indexPath.row+1];
        pagenolbl.textColor = [UIColor blackColor];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell addSubview:pagenolbl];
        });
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(280, 200);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_DrawView clear];
    [self trial:indexPath.row];
    currentPageNo = [[pageNoArray objectAtIndex:indexPath.row] intValue];
    [self pageNoDisplayMethod];
    [self closeThumbnail];
}


/**
 <#Description#>

 @param index <#index description#>
 */
-(void)trial:(NSInteger)index
{
  /*
    stretchImageView  =  [[CGStretchView alloc] initWithFrame:CGRectMake(100, 100,1021/2,808/2)];
    stretchImageView.image  =  [UIImage imageWithData:[NSData dataWithData:[PageImageArray objectAtIndex:index]]]; //drawInRect:_DrawView.bounds];
    stretchImageView.delegate  =  self;
    stretchImageView.isFillActive = NO;
    [_DrawView addSubview:stretchImageView];
  */
    CGRect drawView  =  [_DrawView.layer bounds];
    UIGraphicsBeginImageContext(drawView.size);
    [[UIImage imageWithData:[NSData dataWithData:[PageImageArray objectAtIndex:index]]] drawInRect:_DrawView.bounds];
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_DrawView loadImage:image];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"examFillCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"examFillCell"];
    }
    UILabel *qNO = (UILabel *)[cell viewWithTag:100];
    qNO.text = [questNoArray objectAtIndex:indexPath.row];
    UILabel *qQstn = (UILabel *)[cell viewWithTag:101];
    qQstn.text = [questArray objectAtIndex:indexPath.row];
    
    
    return cell;
    
}


@end
