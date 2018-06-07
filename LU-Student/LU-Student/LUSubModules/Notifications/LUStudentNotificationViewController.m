//
//  LUStudentNotificationViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentNotificationViewController.h"
#import "LUStudentNotificationDetailCell.h"
#import "LUStudentNotificationAddViewController.h"

#define kLUAll 100
#define kLUSchool 101
#define kLUClass 102

@implementation LUStudentNotificationViewController
{
    
    NSMutableDictionary *catchDict;
    LUOperation *sharedSingleton;
    NSMutableArray *allArray;
    NSMutableArray *schoolArray;
    NSMutableArray *classArray;
    NSMutableArray *NotificationArry;
    NSMutableDictionary*notificationDic;
    NSInteger  selectedNotificationType;
    NSMutableArray *ClassId_login, *ClassName_login, *Id_login, *SectionId_login, *SectionName_login, *SubjectId_login,
    *SubjectName_login, *SectionData_login, *Subjectresult_login;
    NSMutableArray *classNamePicker;
    NSMutableArray *sectionNamePicker;
    NSArray *sectionDataResponse;
    NSArray *subjectnameResponse, *subjectStateArray;
    NSString *classRow, *sectionRow, *subjectRow, *pageTypeRow;
    NSDictionary *responseOne;
    NSArray *userLoginList;
    NSDictionary *sendDict;
    NSString *typeValue;
    NSMutableDictionary *newResponse;
    NSString *userRoleName;
    NSArray *tempArrayLogin, *uniqClassIdLogin ,*uniqSectionIdLogin;
    UIDatePicker *datePicker;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    newResponse = [[NSMutableDictionary alloc]init];
    NotificationArry=[[NSMutableArray alloc]init];
    notificationDic =[[NSMutableDictionary alloc]init];
    catchDict = [[NSMutableDictionary alloc]init];
    classNamePicker = [[NSMutableArray alloc]init];
    sectionNamePicker = [[NSMutableArray alloc]init];

    ClassId_login = [[NSMutableArray alloc] init];
    ClassName_login = [[NSMutableArray alloc] init];
    Id_login = [[NSMutableArray alloc] init];
    SectionId_login = [[NSMutableArray alloc] init];
    SectionName_login = [[NSMutableArray alloc] init];
    SubjectId_login = [[NSMutableArray alloc] init];
    SubjectName_login = [[NSMutableArray alloc] init];
    SectionData_login = [[NSMutableArray alloc] init];
    Subjectresult_login = [[NSMutableArray alloc] init];
    
    typeValue=@"";
    _addNotificationPopUP.hidden=YES;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    _Descriptiontext.editable=NO;
    _TitleText.editable=NO;
    _unreadCount.layer.cornerRadius =10;
    _unreadCount.clipsToBounds = true;
    _Notificationdetailview.hidden=YES;
    
    
    [_notificationTypeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    _notificationDescription.layer.cornerRadius = 5;
    _notificationDescription.layer.masksToBounds = YES;
    _notificationDescription.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    _notificationDescription.layer.borderWidth = 0.9;
    
    self.classNamePickerView.dataSource = self;
    self.classNamePickerView.delegate = self;

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_addNotificationPopUP.bounds];
    _addNotificationPopUP.layer.masksToBounds = NO;
    _addNotificationPopUP.layer.shadowColor = [UIColor blackColor].CGColor;
    _addNotificationPopUP.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _addNotificationPopUP.layer.shadowOpacity = 0.5f;
    _addNotificationPopUP.layer.shadowPath = shadowPath.CGPath;
    _addNotificationPopUP.layer.cornerRadius = 10;
    
    _addNotificationButton.hidden = YES;

    [self loadData];
    [self initializeNotification];

}
-(void)viewWillDisappear:(BOOL)animated
{
 
    
    
     // [timer invalidate];
}

-(void)UpdateTable
{
    [self initializeNotification];
    //[_schoolTable reloadData ];
}



- (IBAction)Closebtn:(id)sender
{
    _Notificationdetailview.hidden=YES;
}

- (IBAction)addNotification:(id)sender
{
    [self loadData];
    _addNotificationPopUP.hidden=NO;
    
    datePicker = [[UIDatePicker alloc]init];
    CGRect frame = datePicker.frame;
    frame.size.width = 300;
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.expireAt setInputView:datePicker];
    // Do any additional setup after loading the view, typically from a nib.





    
    
    
    //    LUNotificationAddViewController *pushToNotificationAdd = [self.storyboard instantiateViewControllerWithIdentifier:@"LUTeacherAddNotificationVC"];
//    [self.navigationController pushViewController:pushToNotificationAdd animated:YES];

    
    
}

-(void)updateTextField:(id)sender
{
    
    
    //datePicker = (UIDatePicker*)self.expireAt.inputView;
    self.expireAt.text = [NSString stringWithFormat:@"%@",datePicker.date];
    datePicker.minimumDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.expireAt.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.expireAt resignFirstResponder];
   }

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped. Hello World!");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"INSIDE TEXTFIELD");
    
    
    
                       
}



- (IBAction)addNotificationTapped:(id)sender
{
    [datePicker resignFirstResponder];
    datePicker.hidden = YES;
    if ([typeValue isEqualToString:@""]) {
        NSLog(@"Notification type empty");
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Notification Type Empty"
                                     message:@"Please select the notification type"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        //                                   [self clearAllData];
                                    }];

        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
   else if (_notificationTitle.text.length <= 0)
    {
        NSLog(@"textEMpty");

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Notification Title Empty"
                                     message:@"Please enter valid title for notification"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        //                                   [self clearAllData];
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (_notificationDescription.text.length <= 0)
    {
        NSLog(@"descEMpty");

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Notification Description Empty"
                                     message:@"Please enter valid fields in the description box"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        //                                   [self clearAllData];
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

      
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Description Empty"
//                                                        message:@"Please enter valid fields in the text box"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:nil];
//        [alert show];
//
        
    }
    else if (_expireAt.text.length <= 0)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Expiry date not selected"
                                     message:@"Please select the date from the date picker"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        //                                   [self clearAllData];
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
      
//        NSLog(@"Date empty");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Expire Date Empty"
//                                                        message:@"Please enter valid fields in the format 'YYYY-MM-DD HH:MM:SS"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:nil];
//        [alert show];
//
    }
    
    else
    
    {
        
        NSString *newString = _expireAt.text;
        
        NSString *expression = @"^\\d{4}\\-\\d{2}\\-\\d{2}$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Invalid Date"
                                         message:@"Please select a valid date in YYYY-MM-DD"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                        }];
            
            
            //Add your buttons to alert controller
            
            [alert addAction:yesButton];
           
            
            [self presentViewController:alert animated:YES completion:nil];
            
         }
        else
        {
            [catchDict setValue:classRow forKey:@"ClassId"];
            [catchDict setValue:_notificationTitle.text forKey:@"NotificationTitle"];
            [catchDict setValue:_notificationDescription.text forKey:@"NotificationDescription"];
            [catchDict setValue:typeValue forKey:@"NotificationType"];
            
            [catchDict setValue:_expireAt.text forKey:@"ExpiredAt"];
            NSLog(@"%@",catchDict);
            
            if ([userRoleName isEqualToString:@"Teacher"])
            {
                LUOperation *sharedSingleton = [LUOperation getSharedInstance];
                sharedSingleton.LUDelegateCall=self;
                [sharedSingleton teacherNotificationAdd:Add_teacher_notification body:catchDict];
                
            }
            else if ([userRoleName isEqualToString:@"Student"]){
                //            LUOperation *sharedSingleton = [LUOperation getSharedInstance];
                //            sharedSingleton.LUDelegateCall=self;
                //            [sharedSingleton teacherNotificationAdd:Add_teacher_notification body:catchDict];
                
            }
            
           
            
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Notification Added successfully"
                                         message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                           
                                            
                                            [datePicker resignFirstResponder];
                                            

                                            
                                            
                                            //Handle your yes please button action here
                                            //                                   [self clearAllData];
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
           
            
            
            

            
//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Added successfully"
//                                                            message:nil                                                   delegate:self
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            
            
            
            
            _addNotificationPopUP.hidden=YES;
            
            
        }
        
        //    _notificationTitle.text = @"";
        //    _notificationDescription.text = @"";
        //    _expireAt.text = @"";
        //    [_notificationTypeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        //[self initializeNotification];
        [self UpdateTable];

        }
  
        
  }

- (IBAction)cancelAddNotificationButton:(id)sender
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Are you sure you want to cancel"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                     _addNotificationPopUP.hidden=YES;
                                    
                                    
                                    
                                    
                                    //Handle your yes please button action here
                                    //                                   [self clearAllData];
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   
                                   
                                   [self.navigationController popViewControllerAnimated:YES];
                                   
                                   
                                   //Handle your yes please button action here
                                   //                                   [self clearAllData];
                               }];
    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];

   
 
}


-(void)loadData
{
    
    NSDictionary *mainResponse = [LUOperation getSharedInstance].userProfileDetails;
    
    NSDictionary *secondResponse = [mainResponse objectForKey:@"item"];
    
    userRoleName = [secondResponse objectForKey:@"RoleName"];
   
    
    

    
    
    if([userRoleName isEqualToString:@"Teacher"])
   {
       _addNotificationButton.hidden = NO;

       NSString *temp = [secondResponse objectForKey:@"UserFirstName"];
    NSLog(@"%@",temp);
    
    
    NSArray *classSubjectDataResponse = [secondResponse objectForKey:@"ClassSubjectData"];
    NSLog(@"%@",classSubjectDataResponse);

    for (int i=0; i<classSubjectDataResponse.count; i++)
    {
        
    
    
//    //NSArray *a1 = [classSubjectDataResponse objectAtIndex:0];
//   
//    
//    for (int i=0; i<[a1 count]; i++)
//    {
//        
////        newResponse = [a1 objectAtIndex:<#(NSUInteger)#>]
//        newResponse = [a1 objectAtIndex:i];
//        
//        [classNamePicker addObject:[newResponse objectForKey:@"ClassName"]];
//        
//    }
//    
  
        

        NSDictionary *responseOne_login = [classSubjectDataResponse objectAtIndex:i];
//    
//    
    for (int i=0; i<[classSubjectDataResponse count]; i++)
    {
        [ClassId_login addObject:[responseOne_login objectForKey:@"ClassId"]];
        [ClassName_login addObject:[responseOne_login objectForKey:@"ClassName"]];
        [SectionData_login addObject:[responseOne_login objectForKey:@"sectiondata"]];
    }
    
    sectionDataResponse = [SectionData_login objectAtIndex:0];
    for (int i=0; i<[sectionDataResponse count]; i++)
    {
        NSDictionary *subjectResultResponse = [sectionDataResponse objectAtIndex:i];
        NSLog(@"%@",subjectResultResponse);
        [SectionId_login addObject:[subjectResultResponse objectForKey:@"SectionId"]];
        [SectionName_login addObject:[subjectResultResponse objectForKey:@"SectionName"]];
        [Subjectresult_login addObject:[subjectResultResponse objectForKey:@"subjectresult"]];
    }
    
    for (int j=0; j<[Subjectresult_login count]; j++)
    {
        subjectnameResponse = [Subjectresult_login objectAtIndex:j];
        for (int i=0; i<[subjectnameResponse count]; i++)
        {
            NSDictionary *subjectnameResponseTwo = [subjectnameResponse objectAtIndex:i];
            NSLog(@"%@",subjectnameResponseTwo);
            [SubjectId_login addObject:[subjectnameResponseTwo objectForKey:@"SubjectId"]];
            [SubjectName_login addObject:[subjectnameResponseTwo objectForKey:@"SubjectName"]];
        }
    }
    }
       uniqClassIdLogin =[[NSOrderedSet orderedSetWithArray:ClassId_login] array] ;
       uniqSectionIdLogin = [[NSOrderedSet orderedSetWithArray:SectionId_login] array];
       
       NSLog(@"JSONArray = %@",userLoginList);
       
       classRow =[uniqClassIdLogin objectAtIndex:0];   // [ClassId_login objectAtIndex:[ClassName_login indexOfObject:[ClassName_login objectAtIndex:0]]];
       sectionRow =[uniqSectionIdLogin objectAtIndex:0]; // [SectionId_login objectAtIndex:[SectionName_login indexOfObject:[SectionName_login objectAtIndex:0]]];
       sendDict = @{
                    @"ClassId":classRow,
                    @"SectionId":sectionRow
                    };
  
       // subjectRow = [SubjectId_login objectAtIndex:[SubjectName_login indexOfObject:
    //[SubjectNameTruncated objectAtIndex:0]]];
   
    
   
   
       
    
    
    //  [_sectionSelect reloadAllComponents];
    //[_subjectSelect reloadAllComponents];
    // [self populateDataAction:sendDict];
   }
    
    tempArrayLogin = [[NSOrderedSet orderedSetWithArray:ClassName_login] array];
    NSLog(@"%@",tempArrayLogin);
     [_classNamePickerView reloadAllComponents];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return tempArrayLogin.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return tempArrayLogin[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    classRow = uniqClassIdLogin[row];
}


- (IBAction)segmentTappedNotification:(id)sender
{
    if (_notificationTypeSegment.selectedSegmentIndex==0)
    {
        _classNamePickerView.hidden = YES;
        _classLableNotification.hidden = YES;
        typeValue = @"School";
        
        
        NSLog(@"%@",typeValue);
        // NSLog(@"frist seg tapped");
    }
    else if (_notificationTypeSegment.selectedSegmentIndex==1)
    {
        typeValue = @"Class";
        
        _classNamePickerView.hidden = NO;
        _classLableNotification.hidden = NO;

        //NSLog(@"second seg tapped");
        NSLog(@"%@",typeValue);
    }
    else
        NSLog(@"Nothing tapped");
    
}




/**
 <#Description#>
 */
- (void)initializeNotification
{
  
   
    if ([userRoleName isEqualToString:@"Teacher"])
    {
       // [self loadData];
        NSLog(@"Teacher module");
    
    //_unreadCount.text = [NSString stringWithFormat:@"%d", 0];
    sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton notificationList:Teacher_notification_list_link];
    selectedNotificationType = kLUAll;
    }

    else if ([userRoleName isEqualToString:@"Student"])
    {
        NSLog(@"Student module");
    //_unreadCount.text = [NSString stringWithFormat:@"%d", 0];
    sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton notificationList:Notification_Link];
    selectedNotificationType = kLUAll;
    
    }
}

#pragma mark
#pragma mark Notification Methods
/**
 <#Description#>

 @param notificationDetails <#notificationDetails description#>
 */
-(void)notificationList:(NSDictionary *)notificationDetails
{
   
    if ([[notificationDetails objectForKey:@"message"] isEqualToString:@"Record not found" ])
    {
//        [timer invalidate];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No new notifications"
                                     message:@"Click on Add Notification to add notifications"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        [datePicker resignFirstResponder];
                                        
                                        
                                        
                                        
                                        //Handle your yes please button action here
                                        //                                   [self clearAllData];
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        

    }
    else
    {
    
    //NSLog(@"notificationDetails = %@", notificationDetails);
//    [_chatUserList addObjectsFromArray:[_chatdataDict valueForKey:@"TeacherDetails"]];

    NotificationArry =[notificationDetails objectForKey:@"NotificationData"];
      NSLog(@"%@", NotificationArry);
    for (int i=0; i<NotificationArry.count;i++)
    {
        notificationDic=[NotificationArry objectAtIndex:i];
        
    }
//    if([notificationDetails count])
//    {
        allArray = [[NSMutableArray alloc] init];
        schoolArray = [[NSMutableArray alloc] init];
        classArray = [[NSMutableArray alloc] init];
        
        [allArray removeAllObjects];
        [schoolArray removeAllObjects];
        [classArray removeAllObjects];
    
         [allArray addObjectsFromArray:NotificationArry];
    
    ////
       // [allArray addObjectsFromArray:[notificationDetails objectForKey:@"NotificationData"]];
    
        NSLog(@"%@", allArray);
        [NotificationArry enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSLog(@"%@", object);
            if([[object valueForKey:@"NotificationType"] isEqualToString:@"School"])
            {
                [schoolArray addObject:object];
            }
            else
            {
                [classArray addObject:object];
            }
        }];
        
        [self countReadUnread:kLUAll];
        [_schoolTable reloadData];
     //   timer= [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(UpdateTable) userInfo:nil repeats:YES];
    }
}

/**
 <#Description#>

 @param type <#type description#>
 */
- (void) countReadUnread:(NSInteger )type
{
    __block NSInteger unread = 0;
    _unreadCount.text = [NSString stringWithFormat:@"%d", 0];
    
    NSArray *array;
    if(selectedNotificationType == kLUAll)
    {
        array = [NSArray arrayWithArray:allArray];
    }
    else if(selectedNotificationType == kLUSchool)
    {
        array = [NSArray arrayWithArray:schoolArray];
    }
    else
    {
        array = [NSArray arrayWithArray:classArray];
    }
    
    [[array valueForKey:@"Status"] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if([object isEqualToString:@"Unread"])
        {
            unread+=1;
            
        }
        
    NSLog(@"%@", object);
        
    }];
    
    NSLog(@"Unread = %@", [NSString stringWithFormat:@"%ld",unread]);
    [_unreadCount setText:[NSString stringWithFormat:@"%ld",unread]];
    [_schoolTable reloadData];
}

-(void)fetch{
    
    
    
}
//http://setumbrella.in/learning_umbrella/notification/status_update.php?school_id=13&status=read&user_notification_id=33
/**
 <#Description#>

 @param object <#object description#>
 */
- (void) notificationIsRead: (NSArray *) object
{
    //Id
    NSLog(@"Object = %@", object);
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
    
    NSString *Id = [object valueForKey:@"Id"];
    
    
    NSString *temp = [NSString stringWithFormat:@"&UserNotificationId=%@", Id];
    NSLog(@"%@",temp);
    [body setObject:Id forKey:@"UserNotificationId"];
    
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton  notificationIsRead:temp];
    

}
    
    
    
    
    
    
    
    //    LUOperation *sharedSingleton = [LUOperation getSharedInstance];

    //    NSURL *url = [NSURL URLWithString:@"http://setumbrella.in/learning_umbrella/notification/status_update.php?school_id=13&status=read&user_notification_id=33"];
    
    //    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://setumbrella.in/learning_umbrella/notification/status_update.php"];
    
//    NSURLComponents *components = [NSURLComponents componentsWithString:NotificationIsRead_Link];
//    
//    components.queryItems = @[ [NSURLQueryItem queryItemWithName:@"school_id" value:@"13"],
//                               [NSURLQueryItem queryItemWithName:@"status" value:[object valueForKey:@"status"]],[NSURLQueryItem queryItemWithName:@"user_notification_id" value:[object valueForKey:@"user_notification_id"]] ];
//    NSURL *url = components.URL;
//    
//    
//    [sharedSingleton notificationIsRead:[url absoluteString]];
    /*
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     
     NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
     NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
     if(error)
     {
     NSLog(@"Error: %@", error);
     }
     else
     {
     NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
     NSLog(@"resultArray = %@", result);
     [sharedSingleton notificationIsRead:Notification_Link];
     
     }
     }];
     [dataTask resume];
     });
     */



/**
 <#Description#>

 @param notificationDetails <#notificationDetails description#>
 */
- (void) notificationIsReadList: (NSDictionary *) notificationDetails
{
    NSLog(@"resultArray = %@", notificationDetails);
    
    if ([userRoleName isEqualToString:@"Teacher"])
    {
        [sharedSingleton notificationList:Teacher_notification_list_link];
    }
    
    else if ([userRoleName isEqualToString:@"Student"])
    {
        [sharedSingleton notificationList:Notification_Link];

    }
    
    
    
    

// Teacher_notification_list_link

}


/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)showNotifications:(id)sender
{
    if([sender tag] == kLUAll)
    {
        //All
        selectedNotificationType = kLUAll;
        [self countReadUnread:kLUAll];
    }
    else if([sender tag] == kLUSchool)
    {
        //School
        selectedNotificationType = kLUSchool;
        [self countReadUnread:kLUSchool];
        
    }
    else
    {
        //Class
        selectedNotificationType = kLUClass;
        [self countReadUnread:kLUClass];
    }
    
}


#pragma mark
#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(selectedNotificationType == kLUAll)
    {
        return [allArray count];
    }
    else if(selectedNotificationType == kLUSchool)
    {
        return [schoolArray count];
    }
    else
    {
        return [classArray count];
    }
}

/*
 {
 "expiry_date" = "02/28/2017 12:00 AM";
 "notification_description" = "notification description 3";
 "notification_title" = "notification 3";
 status = read;
 type = Class;
 "user_id" = 3;
 "user_notification_id" = 851;
 }*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"schoolCell";
    LUStudentNotificationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell= [[LUStudentNotificationDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, cell.frame.size.height - 1, cell.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
        bottomBorder.borderWidth = 2.0f;
        bottomBorder.masksToBounds = YES;
        [cell.layer addSublayer:bottomBorder];
       
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array;
    NSString *readOrUnread;
    
    if(selectedNotificationType == kLUAll)
    {
        array = [NSArray arrayWithArray:allArray];
        readOrUnread = [[allArray objectAtIndex:indexPath.row] valueForKey:@"Status"];
        
    }
    else if(selectedNotificationType == kLUSchool)
    {
        array = [NSArray arrayWithArray:schoolArray];
        readOrUnread = [[schoolArray objectAtIndex:indexPath.row] valueForKey:@"Status"];
        
    }
    else
    {
        array = [NSArray arrayWithArray:classArray];
        readOrUnread = [[classArray objectAtIndex:indexPath.row] valueForKey:@"Status"];
        
    }
    
    // Display the notification details in cell
    if([readOrUnread isEqualToString:@"Read"])
    {
        
        cell.cellView.backgroundColor=[UIColor lightGrayColor];
        
        //cell.statusimage.image=[UIImage imageNamed:@"read"];
       // cell.notificationTitle.textColor = [UIColor greenColor];
       // cell.cellView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:0.5];//UIColor colorWithRed:171.0/255.0 green:158.0/255.0 blue:170.0/255.0 alpha:0.5
    }
    else
    {
        
        cell.cellView.backgroundColor = [UIColor whiteColor];
        //cell.statusimage.image=[UIImage imageNamed:@"unread"];
        //cell.notificationTitle.textColor = [UIColor redColor];
       // cell.cellView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:222.0/255.0 blue:153.0/255.0 alpha:0.5];
    }
    //cell.cellView.backgroundColor=[UIColor colorWithRed:171.0/255.0 green:158.0/255.0 blue:170.0/255.0 alpha:0.5];
   // cell.contentView.alpha = 0.5;
    cell.notificationTitle.text = [[array objectAtIndex:indexPath.row] valueForKey:@"NotificationTitle"];

    cell.notificationDescription.text = [[array objectAtIndex:indexPath.row] valueForKey:@"NotificationDescription"];
    
    cell.expiryDate.text=[[array objectAtIndex:indexPath.row]valueForKey:@"ExpiredAt"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Notificationdetailview.hidden=NO;
    NSArray *array;
    if([tableView isEqual:_schoolTable])
    {
        if(selectedNotificationType == kLUAll)
        {
            array = [NSArray arrayWithArray:allArray];
        }
        else if(selectedNotificationType == kLUSchool)
        {
            array = [NSArray arrayWithArray:schoolArray];
        }
        else
        {
            array = [NSArray arrayWithArray:classArray];
        }
        
        if([[[array objectAtIndex:indexPath.row] valueForKey:@"Status"] isEqualToString:@"Unread"])
        {
            [self notificationIsRead:[array objectAtIndex:indexPath.row]];
        }
        
        
        _Descriptiontext.text=[[array objectAtIndex:indexPath.row]valueForKey:@"NotificationDescription"];
        _TitleText.text=[[array objectAtIndex:indexPath.row]valueForKey:@"NotificationTitle"];
       // _Descriptiontext.sizeToFit;
        if (_Descriptiontext)
        {
            CGRect frame = _Descriptiontext.frame;
            frame.size.height = _Descriptiontext.contentSize.height;
            _Descriptiontext.frame=frame;
            _Notificationdetailview.autoresizesSubviews=YES;
        }
        
//        LUTimeTableDetailViewController *controller =[[LUTimeTableDetailViewController alloc]initWithNibName:@"LUTimeTableDetailViewController" bundle:nil];
//        controller.detailArray= @[[[array objectAtIndex:indexPath.row] valueForKey:@"NotificationTitle"], [[array objectAtIndex:indexPath.row] valueForKey:@"NotificationDescription"]];//[cellData object];
//        
//        controller.view.backgroundColor=[UIColor colorWithRed:222.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:0.5];
//        controller.detailTable.backgroundColor =[UIColor colorWithRed:222.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:0.5];
//        // present the controller
//        // on iPad, this will be a Popover
//        // on iPhone, this will be an action sheet
//        controller.modalPresentationStyle = UIModalPresentationPopover;
//        [self presentViewController:controller animated:YES completion:nil];
//        
//        // configure the Popover presentation controller
//        UIPopoverPresentationController *popController = [controller popoverPresentationController];
//        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//        popController.delegate = self;
//        
//        // in case we don't have a bar button as reference
//        popController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
//        popController.permittedArrowDirections=0;
//        popController.sourceView = self.view;
    }
}

@end
