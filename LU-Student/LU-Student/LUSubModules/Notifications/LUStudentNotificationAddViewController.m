//
//  LUStudentNotificationAddViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentNotificationAddViewController.h"
//#import "LUTeacherStudentListViewController.h"


@interface LUStudentNotificationAddViewController ()

@end

@implementation LUStudentNotificationAddViewController
{
    NSDictionary   *responseObject;
    NSArray *resultArray ;
    NSArray *userLoginList;
    NSArray *userLogoutList;
    NSString *token;
    NSDictionary *sendDict;
    NSDictionary *studentList;
    NSMutableArray *Id, *AdmissionDate, *CityName, *ClassName, *CountryName, *DateOfBirth, *DocumentsImage, *EmergencyContactNumber, *Gender,
    *GradeCompleted, *PreviousSchool, *SectionName, *StateName, *StudentAddress, *StudentEmail, *StudentFirstName, *StudentLastName,
    *StudentMiddleName, *StudentMobileNumber, *StudentProfileImage, *StudentRollNumber, *StudentZipCode, *TelephoneNumber, *Transport, *Hostel;
    NSMutableArray *ClassId_login, *ClassName_login, *Id_login, *SectionId_login, *SectionName_login, *SubjectId_login,
    *SubjectName_login, *SectionData_login, *Subjectresult_login;
    NSArray *sectionDataResponse;
    NSArray *subjectnameResponse, *subjectStateArray;
    NSString *classRow, *sectionRow, *subjectRow, *pageTypeRow;
    NSDictionary *responseOne;
    
    NSMutableDictionary *tempDict;
    
    NSMutableArray *classNamePicker;
    NSMutableArray *sectionNamePicker;
    
    NSString *typeValue;

    NSMutableDictionary *catchDict;
    
}

- (void)viewDidLoad {
    
    catchDict = [[NSMutableDictionary alloc]init];
    classNamePicker = [[NSMutableArray alloc]init];
    sectionNamePicker = [[NSMutableArray alloc]init];
    Id= [[NSMutableArray alloc]init];
    AdmissionDate = [[NSMutableArray alloc]init];
    CityName = [[NSMutableArray alloc]init];
    ClassName = [[NSMutableArray alloc]init];
    CountryName = [[NSMutableArray alloc]init];
    DateOfBirth = [[NSMutableArray alloc]init];
    DocumentsImage = [[NSMutableArray alloc]init];
    EmergencyContactNumber = [[NSMutableArray alloc]init];
    Gender = [[NSMutableArray alloc]init];
    GradeCompleted = [[NSMutableArray alloc]init];
    PreviousSchool = [[NSMutableArray alloc]init];
    SectionName = [[NSMutableArray alloc]init];
    StateName = [[NSMutableArray alloc]init];
    StudentAddress = [[NSMutableArray alloc]init];
    StudentEmail = [[NSMutableArray alloc]init];
    StudentFirstName = [[NSMutableArray alloc]init];
    StudentLastName = [[NSMutableArray alloc]init];
    StudentMiddleName = [[NSMutableArray alloc]init];
    StudentMobileNumber = [[NSMutableArray alloc]init];
    StudentProfileImage = [[NSMutableArray alloc]init];
    StudentRollNumber = [[NSMutableArray alloc]init];
    StudentZipCode = [[NSMutableArray alloc]init];
    TelephoneNumber = [[NSMutableArray alloc]init];
    Hostel = [[NSMutableArray alloc]init];
    Transport = [[NSMutableArray alloc]init];
    
    ClassId_login = [[NSMutableArray alloc] init];
    ClassName_login = [[NSMutableArray alloc] init];
    Id_login = [[NSMutableArray alloc] init];
    SectionId_login = [[NSMutableArray alloc] init];
    SectionName_login = [[NSMutableArray alloc] init];
    SubjectId_login = [[NSMutableArray alloc] init];
    SubjectName_login = [[NSMutableArray alloc] init];
    SectionData_login = [[NSMutableArray alloc] init];
    Subjectresult_login = [[NSMutableArray alloc] init];
    
    [_notificationTypeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    _notificationDescription.layer.cornerRadius = 5;
    _notificationDescription.layer.masksToBounds = YES;
    _notificationDescription.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _notificationDescription.layer.borderWidth = 0.9;
    
    
    
    
    self.classNamePickerView.dataSource = self;
    self.classNamePickerView.delegate = self;
    
    [self loadData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData
{
    
    NSDictionary *mainResponse = [LUOperation getSharedInstance].userProfileDetails;
    
    NSDictionary *secondResponse = [mainResponse objectForKey:@"item"];
    
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
    //  _messageText.text = @"User Logged In";
    NSLog(@"JSONArray = %@",userLoginList);
    classRow = [ClassId_login objectAtIndex:[ClassName_login indexOfObject:[ClassName_login objectAtIndex:0]]];
    sectionRow = [SectionId_login objectAtIndex:[SectionName_login indexOfObject:[SectionName_login objectAtIndex:0]]];
    sendDict = @{
                 @"ClassId":classRow,
                 @"SectionId":sectionRow
                 };
    //                                                           subjectRow = [SubjectId_login objectAtIndex:[SubjectName_login indexOfObject:
    //[SubjectNameTruncated objectAtIndex:0]]];
    [_classNamePickerView reloadAllComponents];
    //  [_sectionSelect reloadAllComponents];
    //[_subjectSelect reloadAllComponents];
    // [self populateDataAction:sendDict];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return classNamePicker.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return classNamePicker[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    classRow = classNamePicker[row];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentTappedNotification:(id)sender
{
    if (_notificationTypeSegment.selectedSegmentIndex==0)
    {
        
        typeValue = @"School";

        
        NSLog(@"%@",typeValue);
       // NSLog(@"frist seg tapped");
    }
    else if (_notificationTypeSegment.selectedSegmentIndex==1)
    {
        typeValue = @"Class";
        
        
        //NSLog(@"second seg tapped");
        NSLog(@"%@",typeValue);
    }
    else
        NSLog(@"Nothing tapped");
    
}
- (IBAction)addNotificationTapped:(id)sender
{
    if (_notificationTitle.text.length <= 0)
    {
        NSLog(@"textEMpty");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Title Empty"
                                                        message:@"Please enter the empty fields"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok",nil];
        [alert show];
       // [alert release];
        
    }
    else if (_notificationDescription.text.length <= 0)
    {
        NSLog(@"descEMpty");

    }
    else if (_expireAt.text.length <= 0)
    {
        NSLog(@"Date empty");
    }
    
    
    [catchDict setValue:classRow forKey:@"ClassId"];
    [catchDict setValue:_notificationTitle.text forKey:@"NotificationTitle"];
    [catchDict setValue:_notificationDescription.text forKey:@"NotificationDescription"];
    [catchDict setValue:typeValue forKey:@"NotificationType"];
    [catchDict setValue:_expireAt.text forKey:@"ExpiredAt"];
    NSLog(@"%@",catchDict);
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton teacherNotificationAdd:Add_teacher_notification body:catchDict];
    
//    _notificationTitle.text = @"";
//    _notificationDescription.text = @"";
//    _expireAt.text = @"";
//    [_notificationTypeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];

    }



- (IBAction)cancelButton:(id)sender
{
    
    
    _notificationTitle.text = @"";
  //  _notificationDescription.text = @"";
    _expireAt.text = @"";
    
   
//    
//    LUStudentNotificationViewController *pushToTeacherNotification = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentNotificationVC"];
//    [self.navigationController pushViewController:pushToTeacherNotification animated:YES];
//    
    
 //   [self.navigationController popToRootViewControllerAnimated:YES];
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:sender];
    
}
@end
