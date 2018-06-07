//
//  LUStudentOnlineExamViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import "LUStudentOnlineExamViewController.h"
#import "LUNotesMainDataManager.h"


@interface LUStudentOnlineExamViewController ()
@end

@implementation LUStudentOnlineExamViewController
{
    
    int current_date, current_month, current_year,current_hour,current_minute,current_second,daysInMonth,offset;
    int enableDay,enableMonth,enableYear,enableHour,enableMinute,enableSeconds;
    int balanceTime;
    int tempMonthIncrement,tempMonthDecrement;
    NSString *tempLINK,*QType;
    NSTimeInterval times;
    NSTimeInterval Ttime;
    NSArray *daysInWeeks;
    NSMutableArray *days,*allDays,*examSubjectName,*examId,*time,*total_time,*questionLINK,*questionTYPE,*TEMPcalanderExamList,*calanderExamList;
    
    __weak IBOutlet UILabel *status;
    __weak IBOutlet UILabel *subjectName;
    __weak IBOutlet UILabel *StartTime;
    __weak IBOutlet UIButton *writeButton;
    
    __weak IBOutlet UILabel *status2;
    __weak IBOutlet UILabel *subjectName2;
    __weak IBOutlet UILabel *startTime2;
    __weak IBOutlet UIButton *writeButton2;
    NSIndexPath *myindex;
    int now,later;
    NSTimer *enabler;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    status.text = @"Next Exam";
    status2.text = @"Next Exam";
    subjectName.textColor = [UIColor grayColor];
    StartTime.textColor = [UIColor grayColor];
    status.textColor = [UIColor grayColor];
    writeButton.hidden = YES;
    writeButton2.hidden = YES;
    subjectName2.textColor = [UIColor grayColor];
    startTime2.textColor = [UIColor grayColor];
    status2.textColor = [UIColor grayColor];
    
    
//   enabler = [NSTimer scheduledTimerWithTimeInterval: 5.0
//                                     target: self
//                                   selector:@selector(Enabler)
//                                   userInfo: nil repeats:YES];
    
    daysInWeeks  =  [[NSArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",
                     @"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    
    examSubjectName = [[NSMutableArray alloc]init];
    time = [[NSMutableArray alloc]init];
    total_time = [[NSMutableArray alloc]init];
    questionLINK = [[NSMutableArray alloc]init];
    questionTYPE = [[NSMutableArray alloc]init];
    calanderExamList = [[NSMutableArray alloc]init];
    examId = [[NSMutableArray alloc]init];
    
    [self examListFetch];
    [self initializeOnlineExamView];
    

}

/**
 <#Description#>
 */
- (void) initializeOnlineExamView
{
    current_date = [[LUOnlineExamDateFormatter getTheCurrentDate]intValue];
    current_month = [[LUOnlineExamDateFormatter getTheCurrentMonth]intValue];
    current_year = [[LUOnlineExamDateFormatter getTheCurrentYear]intValue];
    [self CMonth:current_month];
    
    daysInMonth  =  (int)[LUOnlineExamDateFormatter getDaysInMonth:current_month year:current_year];
    offset = (int)[daysInWeeks indexOfObject:[LUOnlineExamDateFormatter getDayOfDate:1 month:current_month year:current_year]];
    days = [[NSMutableArray alloc]init];
    allDays = [[NSMutableArray alloc]init];
    [self allDaysArray];
    _examList = [[UITableView alloc]initWithFrame:CGRectMake(1, 48, 350, 600) style:UITableViewStylePlain];
    _examList.backgroundColor = [UIColor lightGrayColor];
    _examList.separatorColor = [UIColor blackColor];
    _examList.separatorInset = UIEdgeInsetsZero;
    _examList.layoutMargins = UIEdgeInsetsZero;
    _examList.delegate = self;
    _examList.dataSource = self;
    
    _examList.tableFooterView  =  [[UIView alloc] initWithFrame:CGRectZero];
    _examList.tableFooterView.backgroundColor = [UIColor grayColor];
    [self.tableViewBase addSubview:_examList];
}


/**
 <#Description#>
 
 @param month <#month description#>
 */
-(void)CMonth:(int )month
{
    switch (month)
    {
        case 1:
            _Month.text = @"January";
            break;
        case 2:
            _Month.text = @"February";
            break;
        case 3:
            _Month.text = @"March";
            break;
        case 4:
            _Month.text = @"April";
            break;
        case 5:
            _Month.text = @"May";
            break;
        case 6:
            _Month.text = @"June";
            break;
        case 7:
            _Month.text = @"July";
            break;
        case 8:
            _Month.text = @"August";
            break;
        case 9:
            _Month.text = @"September";
            break;
        case 10:
            _Month.text = @"October";
            break;
        case 11:
            _Month.text = @"November";
            break;
        case 12:
            _Month.text = @"December";
            break;
    }
}


/**
 <#Description#>
 */


-(void)allexamArray
{
    
    TEMPcalanderExamList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<examSubjectName.count; i++)
    {
        NSString *string  = [ time objectAtIndex:i];
        NSString *pattern  =  @"(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})";
        NSRegularExpression *regex  =  [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                 options:0 error:NULL];
        NSTextCheckingResult *match  =  [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        NSString *year  =  [string substringWithRange:[match rangeAtIndex:1]];
        NSString *month  =  [string substringWithRange:[match rangeAtIndex:2]];
        NSString *day  =  [string substringWithRange:[match rangeAtIndex:3]];
        NSString *hour  =  [string substringWithRange:[match rangeAtIndex:4]];
        NSString *minute  =  [string substringWithRange:[match rangeAtIndex:5]];
        NSString *second  =  [string substringWithRange:[match rangeAtIndex:6]];
        
        enableDay = [day intValue];
        enableMonth = [month intValue];
        enableYear = [year intValue];
        enableHour = [hour intValue];
        enableMinute = [minute intValue];
        enableSeconds = [second intValue];
        
        NSString *tempday = [NSString stringWithFormat:@"%d",enableDay];
        [TEMPcalanderExamList addObject:tempday];
    }
    
}


/**
 <#Description#>
 */
-(void)allDaysArray{
    if (offset>0)
    {
        for (int i = 0; i<offset; i++)
        {
            [allDays addObject:@""];
        }
    }
    for (int i = 1; i<= daysInMonth; i++)
    {
        [allDays addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

/**
 <#Description#>
 */
-(void)examListArray
{
    int j = 0;
    if (offset>0)
    {
        for (int i = 0; i<offset; i++)
        {
            [allDays addObject:@""];
        }
    }
    
    for (int i = 0; i<allDays.count; i++)
    {
        if (j<TEMPcalanderExamList.count)
        {
            NSString *temp1 = [allDays objectAtIndex:i];
            NSString *temp2 = [TEMPcalanderExamList objectAtIndex:j];
            if ([temp1 isEqual:temp2])
            {
                [calanderExamList addObject:[examSubjectName objectAtIndex:j]];
                j++;
            }
            else
            {
                [calanderExamList addObject:@""];
            }
        }
        else
        {
            [calanderExamList addObject:@""];
        }
    }
}

/**
 <#Description#>
 */
-(void)examListFetch
{
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton examList:ExamList_link];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_calendar reloadData];
    });
    
}


/**
 <#Description#>
 
 @param examlist <#examlist description#>
 */
-(void)examList:(NSArray *)examlist
{
    for (int i=0; i<examlist.count; i++)
    {
        [examSubjectName addObject:[[examlist objectAtIndex:i ] objectForKey:@"SubjectName"]];
        [time addObject:[[examlist objectAtIndex:i ] objectForKey:@"TestStartTime"]];
        [total_time addObject:[[examlist objectAtIndex:i ] objectForKey:@"TestDuration"]];
        [examId addObject:[[examlist objectAtIndex:i ] objectForKey:@"Id"]];
        
       
        
        
        //LUOnlineExamQuesionsController *pushToexamID = [self.storyboard instantiateViewControllerWithIdentifier:@"questionController"];
        
      //   pushToexamID.examID =
        
        
        
        // [questionLINK addObject:[[examlist objectAtIndex:i ] objectForKey:@"test_link"]];
        // [questionTYPE addObject:[[examlist objectAtIndex:i ] objectForKey:@"type"]];
        
    }
    
    
    
    //    [examlist enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop)
    //     {
    //         NSLog(@"test  = %@\n", object);
    //         if ([[object objectForKey:@"class_id"] isEqualToString: @"2"])
    //         {
    //             NSArray *obj1 = [object objectForKey:@"test"];
    //             NSDictionary *testDetails = [obj1 objectAtIndex:0];
    //             [examSubjectName addObject:[testDetails objectForKey:@"subject"]];
    //             [time addObject:[testDetails objectForKey:@"date"]];
    //             [total_time addObject:[testDetails objectForKey:@"duration"]];
    //             [questionLINK addObject:[testDetails objectForKey:@"test_link"]];
    //             [questionTYPE addObject:[testDetails objectForKey:@"type"]];
    //         }
    //
    //
    //     }];
    [self allexamArray];
    [self examListArray];
    
    [self upcomming];
    [_examList reloadData];
   
    [self Enabler];
    [_calendar reloadData];
    
    
    NSLog(@"%@",examlist);
}

/**
 <#Description#>
 */
-(void)upcomming
{
    subjectName.text = [examSubjectName objectAtIndex:now];
    StartTime.text = [time objectAtIndex:now];
    _exam_Id=[examId objectAtIndex:now];
    NSLog(@"%@",_exam_Id);
//     LUOnlineExamQuesionsController *pushToexamID = [self.storyboard instantiateViewControllerWithIdentifier:@"questionController"];
//    
//    pushToexamID.examID =_exam_Id;
    subjectName2.text = [examSubjectName objectAtIndex:later];
    startTime2.text = [time objectAtIndex:later];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allDays.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.hidden = NO;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl  =  (UILabel *)[cell viewWithTag:100];
    UILabel *lbl1  =  (UILabel *)[cell viewWithTag:102];
    
    lbl.text = [NSString stringWithFormat:@"%@",[allDays objectAtIndex:indexPath.row]];
    lbl.backgroundColor = [UIColor redColor];
    
    if ([lbl.text isEqual:@""])
    {
        cell.backgroundColor = [UIColor clearColor];
        lbl.backgroundColor = [UIColor clearColor];
    }
    
    if ((calanderExamList.count!= 0) && (current_month  ==  tempMonthIncrement))
    {
        lbl1.text = [calanderExamList objectAtIndex:indexPath.row];
    }
    else
    {
        lbl1.text = @"";
    }
    if (([lbl.text isEqualToString:[NSString stringWithFormat:@"%d",current_date]]) && (current_month  ==  tempMonthIncrement))
    {
        if(calanderExamList.count!= 0)
        {
            NSString *indx = [calanderExamList objectAtIndex:indexPath.row];
            
            if (![indx  isEqual: @""])
            {
                NSUInteger indx1  =  [examSubjectName indexOfObject: indx];
                
                now = (int)indx1;
               
                //  QType = [NSString stringWithFormat:@"%@",[questionTYPE objectAtIndex:indx1]];
                //tempLINK = [questionLINK objectAtIndex:indx1];
                NSString *temp = [total_time objectAtIndex:indx1];
                Ttime = 60*[temp intValue];
            }
            
            if (now == examSubjectName.count-1)
            {
                subjectName2.text = @"";
                startTime2.text = @"";
            }
            else
            {
                later = now+1;
            }
            [self upcomming];
        }
    }
    else
    {
        lbl.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return examSubjectName.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell  ==  nil)
    {
        cell  =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [examSubjectName objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    return cell;
}

/**
 <#Description#>
 */
-(void)Enabler{
    
    current_date = [[LUOnlineExamDateFormatter getTheCurrentDate]intValue];
    current_month = [[LUOnlineExamDateFormatter getTheCurrentMonth]intValue];
    tempMonthIncrement = current_month;
    current_year = [[LUOnlineExamDateFormatter getTheCurrentYear]intValue];
    current_hour = (int)[LUOnlineExamDateFormatter getTheCurrenthour];
    current_minute = (int)[LUOnlineExamDateFormatter getTheCurrentminute];
    current_second = (int)[LUOnlineExamDateFormatter getTheCurrentsecond];
    
    for (int i = 0; i<examSubjectName.count; i++)
    {
        NSString *string  = [ time objectAtIndex:i];
        NSString *pattern  =  @"(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})";
        NSRegularExpression *regex  =  [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                 options:0 error:NULL];
        NSTextCheckingResult *match  =  [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        NSString *year  =  [string substringWithRange:[match rangeAtIndex:1]];
        NSString *month  =  [string substringWithRange:[match rangeAtIndex:2]];
        NSString *day  =  [string substringWithRange:[match rangeAtIndex:3]];
        NSString *hour  =  [string substringWithRange:[match rangeAtIndex:4]];
        NSString *minute  =  [string substringWithRange:[match rangeAtIndex:5]];
        NSString *second  =  [string substringWithRange:[match rangeAtIndex:6]];
        
        enableDay = [day intValue];
        enableMonth = [month intValue];
        enableYear = [year intValue];
        enableHour = [hour intValue];
        enableMinute = [minute intValue];
        enableSeconds = [second intValue];
        
        
          //if (current_date == enableDay && current_month == enableMonth && current_year == enableYear && current_hour == enableHour && current_minute>= enableMinute)
        {
            status.text = @"Online";
            status.textColor = [UIColor redColor];
            writeButton.hidden = NO;
            writeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"writeExam.png"]];
            [writeButton setTitle:@"write" forState:UIControlStateNormal];
            subjectName.textColor = [UIColor blueColor];
            StartTime.textColor = [UIColor blueColor];
            
//            [NSTimer scheduledTimerWithTimeInterval: balanceTime
//                                             target: self
//                                           selector:@selector(disabler)
//                                           userInfo: nil repeats:NO];
        }
        [self balancetimeCalculator];
        
    }
}


/**
 <#Description#>
 */
-(void)disabler
{
    status.text = @"Over";
    status2.text = @"Next Exam";
    subjectName.textColor = [UIColor grayColor];
    StartTime.textColor = [UIColor grayColor];
    status.textColor = [UIColor grayColor];
    writeButton.hidden = YES;
    writeButton2.hidden = YES;
    subjectName2.textColor = [UIColor grayColor];
    startTime2.textColor = [UIColor grayColor];
    status2.textColor = [UIColor grayColor];
}

/**
 <#Description#>
 */
-(void)balancetimeCalculator
{
    NSDateFormatter *df  =  [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *TodayString  =  [df stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter  =  [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate  =  [dateFormatter dateFromString:[time objectAtIndex:now]];
    NSString *temp = [dateFormatter stringFromDate:startDate];
    times  =  [[df dateFromString:TodayString] timeIntervalSinceDate:[df dateFromString:temp]];
    balanceTime = Ttime-times;
    
}

/**
 <#Description#>
 */
-(void)instrictionAlert
{
    UIAlertController *alertController  =  [UIAlertController
                                            alertControllerWithTitle:@"Instruction"
                                            message:@"\n1. THERE ARE 10 QUESTIONS ON THIS PAPER.\n2.DO NOT FORGET TO REVIEW PROPERLY.\n3. FOR ALL OBJECTIVE,KINDY USE BLANK LINE TO WRITE ANSWERS.\n4.DON'T UNDERLINE,CHOOSE OR MARK.\n5.WORK QUICLY BUT ACCURATELY."
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
                                     [self flight];
                                 }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/**
 <#Description#>
 */
-(void)timeoutAlert
{
    UIAlertController *alertController  =  [UIAlertController
                                            alertControllerWithTitle:@"WARNING"
                                            message:@"Exam completed, Thank You..."
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction  =  [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     
                                     //[enabler invalidate];
                                     
                                 }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 <#Description#>
 */
-(void)flight
{
    [self balancetimeCalculator];
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObject:[examId objectAtIndex:now] forKey:@"TestDetailId"];
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton examCall:GetQuestions_link body:bodyDictionary];

    
    
    //    if ([QType isEqualToString:@"1"])
    //    {
    //        LUOnlineExamQuesionsController *toQuestions = [self.storyboard instantiateViewControllerWithIdentifier:@"type1"];
    //        toQuestions.tempsecondsLeft = balanceTime;
    //        toQuestions.link = tempLINK;
    //        NSCharacterSet *notAllowedChars  =  [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    //
    //        toQuestions.tempSUBJECTNAME = subjectName.text ;
    //        BOOL success  =  NO;
    //        [[LUNotesMainDataManager getSharedInstance]createDB:[[subjectName.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""]];
    //        NSLog(success ? @"Yes Notes created" : @"No notes created");
    //
    //        [self.navigationController pushViewController:toQuestions animated:YES];
    //    }
    //    else if ([QType isEqualToString:@"0"])
    //    {
    //        LUOptionalQuestionsViewController *toQuestions = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionalVC"];
    //        toQuestions.tempsecondsLeft = balanceTime;
    //        toQuestions.optionalQuestionLink = tempLINK;
    //        //toQuestions.tempSUBJECTNAME = subjectName.text;
    //        [self.navigationController pushViewController:toQuestions animated:YES];
    //    }
}

-(void)questionList:(NSArray *)questionlist
{
    LUOnlineExamQuesionsController *toQuestions = [self.storyboard instantiateViewControllerWithIdentifier:@"questionController"];
    toQuestions.tempsecondsLeft = balanceTime;
    toQuestions.questions = questionlist;
    toQuestions.tempSUBJECTNAME = subjectName.text;
    toQuestions.examID=_exam_Id;
    [self.navigationController pushViewController:toQuestions animated:YES];
}




int click = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)writeButtonAction:(id)sender
{
    if (click == 0)
    {
        click++;
        [self instrictionAlert ];
    }
    if (click>0)
    {
        [self timeoutAlert];
    }
    
}


/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)nextMonth:(id)sender
{
    _nextMonth.hidden = YES;
    _prevMonth.hidden = NO;
    tempMonthIncrement +=  1;
    daysInMonth  =  (int)[LUOnlineExamDateFormatter getDaysInMonth:tempMonthIncrement year:current_year];
    offset = (int)[daysInWeeks indexOfObject:[LUOnlineExamDateFormatter getDayOfDate:1 month:tempMonthIncrement year:current_year]];
    days = [[NSMutableArray alloc]init];
    allDays = [[NSMutableArray alloc]init];
    [self allDaysArray];
    [self CMonth:tempMonthIncrement];
    tempMonthDecrement = tempMonthIncrement;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.calendar reloadData];
    });
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)previousMonth:(id)sender
{
    _nextMonth.hidden = NO;
    _prevMonth.hidden = YES;
    
    tempMonthDecrement -=  1;
    daysInMonth  =  (int)[LUOnlineExamDateFormatter getDaysInMonth:tempMonthDecrement year:current_year];
    offset = (int)[daysInWeeks indexOfObject:[LUOnlineExamDateFormatter getDayOfDate:1 month:tempMonthDecrement year:current_year]];
    days = [[NSMutableArray alloc]init];
    allDays = [[NSMutableArray alloc]init];
    [self allDaysArray];
    [self CMonth:tempMonthDecrement];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.calendar reloadData];
    });
    
    tempMonthIncrement = tempMonthDecrement;
}
@end
