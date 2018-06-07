//
//  LUStudentAssignmentViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentAssignmentViewController.h"
#import "LUAssignmentCell.h"
#import "LUAssignmentSubmitCell.h"
#import "LUWriteNotesViewController.h"
#import "DrawingDataManager.h"
#import "LUNotesMainDataManager.h"
#import "MobileCoreServices/MobileCoreServices.h"
//#import "LUTimeTableDetailViewController.h"
@interface LUStudentAssignmentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *assignmentListTable;
@property (weak, nonatomic) IBOutlet UICollectionView *assignmentPreviewCollection;

@end

typedef enum
{
    Submit,redo, approved, rejected
} statusType;

@implementation LUStudentAssignmentViewController
{
    __weak IBOutlet UIView *DetailViewBase;
    __weak IBOutlet UILabel *assignmentCountLabel;
    __weak IBOutlet UILabel *assignmentTitleLabel;
    __weak IBOutlet UILabel *duelbl;
    __weak IBOutlet UILabel *assignedlbl;
    __weak IBOutlet UILabel *dueTime;
    __weak IBOutlet UILabel *assignedTime;
    __weak IBOutlet UILabel *assignmentDescription;
    __weak IBOutlet UIImageView *submittedImage;
    __weak IBOutlet UIImageView *redoImage;
    __weak IBOutlet UIImageView *approvedImage;
    __weak IBOutlet UIImageView *rejectedImage;
    NSArray *previewPageImageArray,*subjectNameForFilter;
    NSMutableArray *assignmentTitleArray,*assignmentDescriptionArray,*dueTimeArray,*assignedTimeArray,*statusArray,*subjectName,*titleArray,*pagetypeArray,*typeIdentifier,*assignmentId,*subjectlistarray;
   NSMutableArray *filterSubjectName;
    int index;
    NSString *assignmentIdSumbit;
    BOOL saveEnabler;
    __weak IBOutlet UIButton *write;
    __weak IBOutlet UIButton *draw;
    __weak IBOutlet UIButton *attach;
    __weak IBOutlet UIButton *submit;
    BOOL enable;
    NSData* documentData;
    NSURL *urlOfSelectedDocument;
    NSArray *filter;
    NSArray *result;
    NSString*asssignmnettitle;
    NSString*Time;
    NSString *syncAssignmentId;
    
    __weak IBOutlet UITextField *attachFileName;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    enable = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self initializeAssignmentView];
    NSArray *pageUpdation = [[DrawingDataManager getSharedInstance]viewAllArt:@"Assignment"];
    NSArray *pageNoArray = [pageUpdation objectAtIndex:0];
    previewPageImageArray = [pageUpdation objectAtIndex:1];
    filterSubjectName=[[NSMutableArray alloc]init];
    
    /*
     //Getting class id of student from plist
     NSArray *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory  =  [paths objectAtIndex:0];
     NSString *ProfileDetailsPath  = [documentsDirectory stringByAppendingPathComponent:@"StudentDetails.plist"];
     NSFileManager *fileManager  =  [NSFileManager defaultManager];
     NSMutableDictionary *profileDetailsPathPlistData;
     if ([fileManager fileExistsAtPath: ProfileDetailsPath]) {
     profileDetailsPathPlistData  =  [[NSMutableDictionary alloc] initWithContentsOfFile:ProfileDetailsPath];
     }
     //Fetching assignment list from response
     NSString *classID = [profileDetailsPathPlistData objectForKey:@"s_cid"];
     NSString *dataUrl  =  Assignment_link;
     NSURLSession *session  =  [NSURLSession sharedSession];
     NSURLSessionDataTask *dataTask  =  [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
     dispatch_async(dispatch_get_main_queue(), ^{
     NSArray *json  =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     NSDictionary *assignmentresponce = [json objectAtIndex:0];
     if ([classID isEqualToString:[assignmentresponce objectForKey:@"class_id"]])
     {
     NSArray *assignmentList = [assignmentresponce objectForKey:@"assignment"];
     for (int i = 0;i<assignmentList.count; i++) {
     NSDictionary *assignmentDictionary = [assignmentList objectAtIndex:i];
     [assignmentTitleArray addObject:[assignmentDictionary objectForKey:@"Assignment Title"]];
     [assignmentDescriptionArray addObject:[assignmentDictionary objectForKey:@"Assignment Description"]];
     [dueTimeArray addObject:[assignmentDictionary objectForKey:@"Due"]];
     [assignedTimeArray addObject:[assignmentDictionary objectForKey:@"Assigned"]];
     [statusArray addObject:[assignmentDictionary objectForKey:@"Status"]];
     [subjectName addObject:[assignmentDictionary objectForKey:@"Subject"]];
     BOOL drawBool = [assignmentDictionary objectForKey:@"Draw"]!= nil;
     if (drawBool == YES) {
     [typeIdentifier addObject:@"Draw"];
     NSDictionary *assignmentType = [assignmentDictionary objectForKey:@"Draw"];
     
     [titleArray addObject:[assignmentType objectForKey:@"Title"]];
     [pagetypeArray addObject:[assignmentType objectForKey:@"Notes Type"]];
     
     }
     BOOL writeBool = [assignmentDictionary objectForKey:@"Write"]!= nil;
     if (writeBool == YES)
     {
     [typeIdentifier addObject:@"Write"];
     NSDictionary *assignmentType = [assignmentDictionary objectForKey:@"Write"];
     
     [titleArray addObject:[assignmentType objectForKey:@"Title"]];
     [pagetypeArray addObject:[assignmentType objectForKey:@"Notes Type"]];
     }
     }
     }
     assignmentCountLabel.text = [NSString stringWithFormat:@"(%lu)",assignmentTitleArray.count];
     [_assignmentListTable reloadData];
     
     });
     }];
     [dataTask resume];
     */
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
    NSArray *pageUpdation = [[DrawingDataManager getSharedInstance]viewAllArt:@"Assignment"];
    NSArray *pageNoArray = [pageUpdation objectAtIndex:0];
    previewPageImageArray = [pageUpdation objectAtIndex:1];
    
    
    if (asssignmnettitle!=nil)
    {
        [self  assignmentExistance:[self removeSpecialCharacter]];
        [_assignmentPreviewCollection setHidden:NO];
    }
    
}

/**
 initializeAssignmentView - initializes assignment title, description, time, status page and subject
 */
- (void) initializeAssignmentView
{
    [DetailViewBase setHidden:YES];
    [_assignmentPreviewCollection setHidden:YES];
    attachFileName.hidden = YES;
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton assignmentList:Assignment_link];
    
    [self allocator];
}
-(void)allocator{
    assignmentTitleArray = [[NSMutableArray alloc]init];
    assignmentDescriptionArray = [[NSMutableArray alloc]init];
    dueTimeArray = [[NSMutableArray alloc]init];
    assignedTimeArray = [[NSMutableArray alloc]init];
    statusArray = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    pagetypeArray = [[NSMutableArray alloc]init];
    typeIdentifier = [[NSMutableArray alloc]init];
    subjectName = [[NSMutableArray alloc]init];
    assignmentId = [[NSMutableArray alloc]init];
    subjectlistarray=[[NSMutableArray alloc]init];
    //filterSubjectName=[[NSMutableArray alloc]init];
}



- (void)passData:(NSString *)data;
{
    
    result = [filter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SubjectName contains[c] %@", data]];
    [self allocator];
    
    for (int i = 0;i<result.count; i++)
    {
        NSDictionary*assignmentDictionary = [result objectAtIndex:i];
        
        [assignmentTitleArray addObject:[assignmentDictionary objectForKey:@"AssignmentSubject"]];
        [assignmentDescriptionArray addObject:[assignmentDictionary objectForKey:@"AssignmentDescription"]];
        [dueTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentDueDate"]];
        [assignedTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentCreatedDate"]];
        [statusArray addObject:[assignmentDictionary objectForKey:@"Status"]];
        [subjectName addObject:[assignmentDictionary objectForKey:@"SubjectName"]];
        [typeIdentifier addObject:[assignmentDictionary objectForKey:@"AssignmentType"]];
        [assignmentId addObject:[assignmentDictionary objectForKey:@"Id"]];
        [pagetypeArray addObject:[assignmentDictionary objectForKey:@"PageTypeName"]];
    }
    [self.assignmentListTable reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_assignmentListTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_assignmentListTable didSelectRowAtIndexPath:indexPath];
    
    
}


//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//
//    result = [filter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SubjectName contains[c] %@", searchText]];
//    [self allocator];
//    for (int i = 0;i<result.count; i++)
//    {
//       NSDictionary*assignmentDictionary = [result objectAtIndex:i];
//
//        [assignmentTitleArray addObject:[assignmentDictionary objectForKey:@"AssignmentSubject"]];
//        [assignmentDescriptionArray addObject:[assignmentDictionary objectForKey:@"AssignmentDescription"]];
//        [dueTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentDueDate"]];
//        [assignedTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentCreatedDate"]];
//        [statusArray addObject:[assignmentDictionary objectForKey:@"Status"]];
//        [subjectName addObject:[assignmentDictionary objectForKey:@"SubjectName"]];
//        [typeIdentifier addObject:[assignmentDictionary objectForKey:@"AssignmentType"]];
//        [assignmentId addObject:[assignmentDictionary objectForKey:@"Id"]];
//        [pagetypeArray addObject:[assignmentDictionary objectForKey:@"PageTypeName"]];
//    }
//    [self.assignmentListTable reloadData];
//}
//
#pragma Delegate method
/**
 Delegate method
 
 @param assignmentDetails response include assignment details
 */
-(void)assignmentList:(NSArray *)assignmentDetails
{
    NSLog(@"%@",assignmentDetails);
    filter = [assignmentDetails copy];
    if (result.count==0)
    {
        for (int i = 0;i<assignmentDetails.count; i++)
        {
            NSDictionary *assignmentDictionary = [assignmentDetails objectAtIndex:i];
            
            [assignmentTitleArray addObject:[assignmentDictionary objectForKey:@"AssignmentSubject"]];
            [assignmentDescriptionArray addObject:[assignmentDictionary objectForKey:@"AssignmentDescription"]];
            [dueTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentDueDate"]];
            [assignedTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentCreatedDate"]];
            [statusArray addObject:[assignmentDictionary objectForKey:@"Status"]];
            [subjectName addObject:[assignmentDictionary objectForKey:@"SubjectName"]];
            [filterSubjectName addObject:[assignmentDictionary objectForKey:@"SubjectName"]];
            [typeIdentifier addObject:[assignmentDictionary objectForKey:@"AssignmentType"]];
            [assignmentId addObject:[assignmentDictionary objectForKey:@"Id"]];
            [pagetypeArray addObject:[assignmentDictionary objectForKey:@"PageTypeName"]];
        }
        subjectNameForFilter= [subjectName copy];
    }else
    {
        for (int i = 0;i<result.count; i++)
        {
            NSDictionary *assignmentDictionary = [assignmentDetails objectAtIndex:i];
            
            [assignmentTitleArray addObject:[assignmentDictionary objectForKey:@"AssignmentSubject"]];
            [assignmentDescriptionArray addObject:[assignmentDictionary objectForKey:@"AssignmentDescription"]];
            [dueTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentDueDate"]];
            [assignedTimeArray addObject:[assignmentDictionary objectForKey:@"AssignmentCreatedDate"]];
            [statusArray addObject:[assignmentDictionary objectForKey:@"Status"]];
            [subjectName addObject:[assignmentDictionary objectForKey:@"SubjectName"]];
            [typeIdentifier addObject:[assignmentDictionary objectForKey:@"AssignmentType"]];
            [assignmentId addObject:[assignmentDictionary objectForKey:@"Id"]];
            [pagetypeArray addObject:[assignmentDictionary objectForKey:@"PageTypeName"]];
        }
        
    }
    assignmentCountLabel.text = [NSString stringWithFormat:@"(%lu)",assignmentTitleArray.count];
    
    
    [_assignmentListTable reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_assignmentListTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_assignmentListTable didSelectRowAtIndexPath:indexPath];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Action methid Submit
 
 @param sender submit the assignment
 */
- (IBAction)submitButton:(id)sender
{
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[dateFormatter dateFromString:dueTime.text];
    NSString *strDate1=[dateFormatter stringFromDate:date1];
    
    NSDate *today = [NSDate date];
    NSLog(@" today date %@",today);
    
    NSString *strDate2=[dateFormatter stringFromDate:today];
    
    NSLog(@"date 1 : %@ and date2: %@",strDate1,strDate2);
    
    
    
    NSComparisonResult result = [strDate1 compare:strDate2];
    
    if(result==NSOrderedAscending)
    {
        NSLog(@"Time is in the future");
        
        UIAlertController *alertController  =  [UIAlertController
                                                alertControllerWithTitle:@"Alert!"
                                                message:@"Assignment submission date expired."
                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction  =  [UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                         style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction *action)
                                         {
                                             
                                         }];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    
    //    else if(result==NSOrderedDescending)
    //    {
    //
    //        NSLog(@"Time is in the past");
    //        UIAlertController *alertController  =  [UIAlertController
    //                                                alertControllerWithTitle:@"Alert!"
    //                                                message:@"Exam Date Is Over"
    //                                                preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction  =  [UIAlertAction
    //                                         actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
    //                                         style:UIAlertActionStyleCancel
    //                                         handler:^(UIAlertAction *action)
    //                                         {
    //
    //                                         }];
    //
    //        [alertController addAction:cancelAction];
    //
    //        [self presentViewController:alertController animated:YES completion:nil];
    //
    //
    //
    //    }
    else
        
    {
        NSLog(@"Both dates are the same");
        UIAlertController *alertController  =  [UIAlertController
                                                alertControllerWithTitle:@"Confirmation"
                                                message:@"Click confirm to submit your assignment.\nAfter submitting you can't edit it."
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
                                         [self submitSession];
                                         
                                         submittedImage.image = [UIImage imageNamed:@"submitted.png"];
                                         //[self getPDF:[self removeSpecialCharacter]];
                                     }
                                     ];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    //    UIAlertController *alertController  =  [UIAlertController
    //                                            alertControllerWithTitle:@"Confirmation"
    //                                            message:@"Click confirm to submit your assignment.\nAfter submitting you can't edit it."
    //                                            preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *cancelAction  =  [UIAlertAction
    //                                     actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
    //                                     style:UIAlertActionStyleCancel
    //                                     handler:^(UIAlertAction *action)
    //                                     {
    //
    //                                     }];
    //
    //    UIAlertAction *okAction  =  [UIAlertAction
    //                                 actionWithTitle:NSLocalizedString(@"OK", @"OK action")
    //                                 style:UIAlertActionStyleDefault
    //                                 handler:^(UIAlertAction *action)
    //                                 {
    //                                     [self submitSession];
    //
    //                                     submittedImage.image = [UIImage imageNamed:@"submitted.png"];
    //                                     //[self getPDF:[self removeSpecialCharacter]];
    //                                 }
    //                                 ];
    //
    //    [alertController addAction:cancelAction];
    //    [alertController addAction:okAction];
    //    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 <#Description#>
 */
-(void)submitSession
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    NSDictionary *profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    NSString *DBName = [self removeSpecialCharacter];
    NSArray *notes,*drawing,*artnameArr,*artimageArr;
    NSString *imageString,*assignmentTitle;
    if (saveEnabler == YES) {
        notes = [[LUNotesMainDataManager getSharedInstance]viewAllArt:DBName];
        artnameArr = [notes objectAtIndex:0];
        artimageArr = [notes objectAtIndex:1];
        
        
    }else if(saveEnabler == NO)
    {
        drawing = [[DrawingDataManager getSharedInstance]viewAllArt:DBName];
        artnameArr = [drawing objectAtIndex:0];
        artimageArr = [drawing objectAtIndex:1];
    }
    NSMutableArray *assignmentBodyDetails = [[NSMutableArray alloc]init];
    for (int i = 0; i<artnameArr.count; i++)
    {
        assignmentTitle = [artnameArr objectAtIndex:i];
        imageString = [[artimageArr objectAtIndex:i] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc]init];
        [bodyDictionary setValue:assignmentTitle forKey:@"pagenumber"];
        [bodyDictionary setValue:imageString forKey:@"AssignmentImageUrl"];
        
        [assignmentBodyDetails addObject:bodyDictionary];
    }
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
    [body setObject:assignmentIdSumbit forKey:@"AssignmentId"];
    NSString *newStr = [documentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (newStr.length>0) {
        [body setObject:newStr forKey:@"AssignmentSubmissionAttachment"];
    }else
    {
        [body setObject:@"" forKey:@"AssignmentSubmissionAttachment"];
    }
    [body setObject:[profileDetails objectForKey:@"StudentId"] forKey:@"StudentId"];
    [body setObject:@"" forKey:@"AttachmentType"];
    [body setObject:assignmentBodyDetails forKey:@"AssignmentSubmissionDescription"];
    
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton assignmentSubmit:body];
    
}




-(void) assignmentSubmit: (NSDictionary *)assignmentSubmitDetails
{
    UIAlertController *alertController  =  [UIAlertController
                                            alertControllerWithTitle:@"Done"
                                            message:@"Assignment submitted successfully "
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction  =  [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     
                                 }
                                 ];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    [self initializeAssignmentView];
}





/**
 <#Description#>
 
 @return <#return value description#>
 */

-(NSString *)removeSpecialCharacter
{
    
    NSString *DBName;
    NSCharacterSet *notAllowedChars  =  [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    if (assignmentTitleArray.count>0)
    {
        DBName  =  [[[assignmentTitleArray objectAtIndex:index] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        
    }
    
    return DBName;
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)writeButton:(id)sender
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    NSDictionary *profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    
    NSString *DBName = [self removeSpecialCharacter];
    [[LUNotesMainDataManager getSharedInstance]createDB:DBName];
    LUWriteNotesViewController *pushToWriting = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentWriteNotesVC"];
    pushToWriting.FlashUniteName = DBName;
    pushToWriting.FlashPageType =  [pagetypeArray objectAtIndex:index];
    pushToWriting.isAssignment = YES;
    pushToWriting.studentId = [profileDetails objectForKey:@"StudentId"];
    pushToWriting.subjectCategoryId = syncAssignmentId;
    pushToWriting.moduleName =@"Assignment";
    saveEnabler = YES;
    [self.navigationController pushViewController:pushToWriting animated:YES];
    [_assignmentPreviewCollection setHidden:NO];
    
    [self  assignmentExistance:[self removeSpecialCharacter]];
    
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)drawButton:(id)sender
{
    NSString *DBName = [self removeSpecialCharacter];
    [[DrawingDataManager getSharedInstance]createDrawingDB:DBName];
    
    NSArray * drawings = [[DrawingDataManager getSharedInstance]viewAllArt: DBName];
    NSArray * artnameArr = [drawings objectAtIndex:0];
    NSArray * artimageArr = [drawings objectAtIndex:1];
    if (artnameArr.count>0)
    {
        LUDrawingViewController *pushToDrawing = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentDrawingVC"];
        pushToDrawing.artName =[assignmentTitleArray objectAtIndex:index];
        pushToDrawing.DBName = [self removeSpecialCharacter];
        pushToDrawing.artImage =[artimageArr objectAtIndex:[artnameArr indexOfObject:[assignmentTitleArray objectAtIndex:index]]];
        pushToDrawing.isAssignment = YES;
        [self.navigationController pushViewController:pushToDrawing animated:YES];
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(1326,860));
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        UIView *base = [[UIView alloc]initWithFrame:CGRectMake(0,0,1326, 860)];
        base.backgroundColor = [UIColor whiteColor];
        [base.layer renderInContext:context];
        UIImage *img =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        BOOL success  =  NO;
        
        success = [[DrawingDataManager getSharedInstance]saveDrawing:[assignmentTitleArray objectAtIndex:index] page:[NSData dataWithData:UIImagePNGRepresentation(img)] catagory:asssignmnettitle  DB:DBName];
        LUDrawingViewController *pushToDrawing = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentDrawingVC"];
        pushToDrawing.artName = [assignmentTitleArray objectAtIndex:index];
        pushToDrawing.DBName = DBName;
        pushToDrawing.isAssignment = YES;
        //pushToDrawing.artImage =
        [self.navigationController pushViewController:pushToDrawing animated:YES];
        
        
    }
    saveEnabler = NO;
    
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)attachButton:(id)sender
{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    //UIDocumentPickerViewController*doctextfile=[[UIDocumentPickerViewController alloc]initWithDocumentTypes:@[@""] inMode:<#(UIDocumentPickerMode)#>]
    
    documentPicker.delegate = self;
    
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}
#pragma mail delegate method
/**
 <#Description#>
 
 @param controller <#controller description#>
 @param result <#result description#>
 @param error <#error description#>
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma Check for Assignment existance

/**
 <#Description#>
 
 @param dbname <#dbname description#>
 */
-(void)assignmentExistance:(NSString*)dbname
{
    
    //[[LUNotesMainDataManager getSharedInstance]createDB:dbname];
    if (enable == YES)
    {
        enable = NO;
        [[LUNotesMainDataManager getSharedInstance]createDB:dbname];
        NSArray *notesPageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:dbname];
        previewPageImageArray = [notesPageUpdation objectAtIndex:1];
        if (previewPageImageArray.count>0)
            
            [write setTitle:@"Edit" forState:UIControlStateNormal];
        else
            [write setTitle:@"Write" forState:UIControlStateNormal];
        
        saveEnabler = YES;
        
    }
    else
    {
        [[DrawingDataManager getSharedInstance]createDrawingDB:dbname];
        NSArray *drawPageUpdation = [[DrawingDataManager getSharedInstance]viewAllArt:dbname] ;
        previewPageImageArray = [drawPageUpdation objectAtIndex:1];
        if (previewPageImageArray.count>0)
            [draw setTitle:@"Edit" forState:UIControlStateNormal];
        else
            [draw setTitle:@"Draw" forState:UIControlStateNormal];
        saveEnabler = NO;
    }
    
    [_assignmentPreviewCollection reloadData];
    
    // [self getPDF:[self removeSpecialCharacter]];
}

#pragma PDF file creation

/**
 <#Description#>
 
 @param name <#name description#>
 */
-(void)getPDF:(NSString*)name
{
    // get all the page from SQLite
    if (enable==YES)
    {
        NSArray *pageUpdation = [[LUNotesMainDataManager getSharedInstance]viewAllArt:name];
        NSArray *pageNoArray = [pageUpdation objectAtIndex:0];
        previewPageImageArray = [pageUpdation objectAtIndex:1];
    }else
    {
        NSArray *pageUpdation = [[DrawingDataManager getSharedInstance]viewAllArt:name];
        NSArray *pageNoArray = [pageUpdation objectAtIndex:0];
        previewPageImageArray = [pageUpdation objectAtIndex:1];
    }
    [_assignmentPreviewCollection reloadData];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return assignmentTitleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LUAssignmentCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LUAssignmentCell"];
    }
    UILabel *assignmentTITLE  =  (UILabel *)[cell viewWithTag:100];
    assignmentTITLE.text = [assignmentTitleArray objectAtIndex:indexPath.row];
    
    asssignmnettitle=[assignmentTitleArray objectAtIndex:indexPath.row];
    
    UILabel *assignTIME  =  (UILabel *)[cell viewWithTag:101];
    assignTIME.text = [assignedTimeArray objectAtIndex:indexPath.row];
    
    UILabel *description  =  (UILabel *)[cell viewWithTag:102];
    description.text = [assignmentDescriptionArray objectAtIndex:indexPath.row];
    
    NSString *status  = [NSString stringWithFormat:@"%@",[statusArray objectAtIndex:indexPath.row]];
    if ([status isEqualToString:@"Submitted"])
    {
        UIImageView *subImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *re_doImage = (UIImageView *)[cell viewWithTag:104];
        UIImageView *appImage = (UIImageView *)[cell viewWithTag:105];
        UIImageView *rejcImage = (UIImageView *)[cell viewWithTag:106];
        
        subImage.image = [UIImage imageNamed:@"submitted"];;
        //re_doImage.image = [UIImage imageNamed:@""];;
        // appImage.image = [UIImage imageNamed:@""];;
        // rejcImage.image = [UIImage imageNamed:@""];;
        
        //        subImage.hidden = NO;
        //        re_doImage.hidden = YES;
        //        appImage.hidden = YES;
        //        rejcImage.hidden = YES;
    }
    if ([status isEqualToString:@"Redo"])
    {
        UIImageView *subImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *re_doImage = (UIImageView *)[cell viewWithTag:104];
        UIImageView *appImage = (UIImageView *)[cell viewWithTag:105];
        UIImageView *rejcImage = (UIImageView *)[cell viewWithTag:106];
        
        //subImage.image = [UIImage imageNamed:@""];;
        re_doImage.image = [UIImage imageNamed:@"arrowrightrejected"];;
        //appImage.image= [UIImage imageNamed:@""];;
        rejcImage.image = [UIImage imageNamed:@"rejected"];;
    }
    if ([status isEqualToString:@"Approved"])
    {
        UIImageView *subImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *re_doImage = (UIImageView *)[cell viewWithTag:104];
        UIImageView *appImage = (UIImageView *)[cell viewWithTag:105];
        UIImageView *rejcImage = (UIImageView *)[cell viewWithTag:106];
        
        subImage.image = [UIImage imageNamed:@"submitted"];;
        // re_doImage.image = [UIImage imageNamed:@""];;
        appImage.image = [UIImage imageNamed:@"approved"];;
        // rejcImage.image = [UIImage imageNamed:@""];;
    }
    if ([status isEqualToString:@"Rejected"])
    {
        UIImageView *subImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *re_doImage = (UIImageView *)[cell viewWithTag:104];
        UIImageView *appImage = (UIImageView *)[cell viewWithTag:105];
        UIImageView *rejcImage = (UIImageView *)[cell viewWithTag:106];
        
        subImage.image = [UIImage imageNamed:@"submitted"];;
        //re_doImage.image = [UIImage imageNamed:@""];;
        //appImage.image = [UIImage imageNamed:@""];;
        rejcImage.image = [UIImage imageNamed:@"rejected"];;
    }
    if ([status isEqualToString:@"Not Submitted"])
    {
        UIImageView *subImage = (UIImageView *)[cell viewWithTag:103];
        UIImageView *re_doImage = (UIImageView *)[cell viewWithTag:104];
        UIImageView *appImage = (UIImageView *)[cell viewWithTag:105];
        UIImageView *rejcImage = (UIImageView *)[cell viewWithTag:106];
        
        subImage.image = [UIImage imageNamed:@"submittedicongrey"];;
        re_doImage.image = [UIImage imageNamed:@"arrowsrightgrey"];;
        appImage.image = [UIImage imageNamed:@"approvedicongrey"];;
        rejcImage.image = [UIImage imageNamed:@"rejected-icon-grey"];;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *status =[NSString stringWithFormat:@"%@",[statusArray objectAtIndex:indexPath.row]];
    
    if ([status isEqualToString:@"Not Submitted"])
    {
        write.userInteractionEnabled = YES;
        submit.userInteractionEnabled = YES;
        attach.userInteractionEnabled = YES;
        draw.userInteractionEnabled = YES;
        submittedImage.image = [UIImage imageNamed:@"submitted-gray.png"];
        approvedImage.image = [UIImage imageNamed:@"approved-gray.png"];
        rejectedImage.image = [UIImage imageNamed:@"rejected-gray.png"];
        redoImage.image = [UIImage imageNamed:@"redo-Gray.png"];
    }else if ([status isEqualToString:@"Submitted"])
    {
        write.userInteractionEnabled = NO;
        submit.userInteractionEnabled = NO;
        attach.userInteractionEnabled = NO;
        draw.userInteractionEnabled = NO;
        submittedImage.image = [UIImage imageNamed:@"submittedStatus.png"];
        approvedImage.image = [UIImage imageNamed:@"approved-gray.png"];
        rejectedImage.image = [UIImage imageNamed:@"rejected-gray.png"];
        redoImage.image = [UIImage imageNamed:@"redo-Gray.png"];
    }
    else if ([status isEqualToString:@"Redo"])
    {
        write.userInteractionEnabled = YES;
        submit.userInteractionEnabled = YES;
        attach.userInteractionEnabled = YES;
        draw.userInteractionEnabled = YES;
        submittedImage.image = [UIImage imageNamed:@"submitted-gray.png"];
        approvedImage.image = [UIImage imageNamed:@"approved-gray.png"];
        rejectedImage.image = [UIImage imageNamed:@"rejectedStatus.png"];
        redoImage.image = [UIImage imageNamed:@"redoStatus.png"];
    }
    else if ([status isEqualToString:@"Approved"])
    {
        write.userInteractionEnabled = NO;
        draw.userInteractionEnabled = NO;
        submit.userInteractionEnabled = NO;
        attach.userInteractionEnabled = NO;
        draw.userInteractionEnabled = NO;
        submittedImage.image = [UIImage imageNamed:@"submittedStatus.png"];
        redoImage.image = [UIImage imageNamed:@"redo-Gray.png"];
        approvedImage.image = [UIImage imageNamed:@"approvedStatus.png"];
        rejectedImage.image = [UIImage imageNamed:@"rejected-gray.png"];
    }
    else if ([status isEqualToString:@"Rejected"])
    {
        write.userInteractionEnabled = YES;
        submit.userInteractionEnabled = YES;
        attach.userInteractionEnabled = YES;
        draw.userInteractionEnabled = YES;
        submittedImage.image = [UIImage imageNamed:@"submitted-gray.png"];
        approvedImage.image = [UIImage imageNamed:@"approved-gray.png"];
        redoImage.image = [UIImage imageNamed:@"redoStatus.png"];
        rejectedImage.image = [UIImage imageNamed:@"rejectedStatus.png"];
    }
    
    if([[typeIdentifier objectAtIndex:indexPath.row] isEqualToString:@"Write"])
    {
        enable=YES;
        write.hidden = NO;
        draw.hidden = YES;
    }
    else if ([[typeIdentifier objectAtIndex:indexPath.row] isEqualToString:@"Draw"])
    {
        
        write.hidden = YES;
        draw.hidden = NO;
        
    }
    [_assignmentPreviewCollection setHidden:NO];
    index = (int)indexPath.row;
    
    attachFileName.hidden = NO;
    [self  assignmentExistance:[self removeSpecialCharacter]];
    //[self getPDF:[self removeSpecialCharacter]];
    [DetailViewBase setHidden:NO];
    assignmentTitleLabel.text = [assignmentTitleArray objectAtIndex:indexPath.row];
    dueTime.text = [dueTimeArray objectAtIndex:indexPath.row];
    assignedTime.text = [assignedTimeArray objectAtIndex:indexPath.row];
    
    assignmentDescription.text = [assignmentDescriptionArray objectAtIndex:indexPath.row];
    assignmentIdSumbit =[assignmentId objectAtIndex:indexPath.row];
    syncAssignmentId = [assignmentId objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return previewPageImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 2.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    UIImage *cache = [UIImage imageWithData:[previewPageImageArray objectAtIndex:indexPath.row]];
    UIImageView *preview =  (UIImageView *)[cell viewWithTag:200];
    preview.image = cache;
    return  cell;
}
#pragma mark - iCloud files
-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker

{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        urlOfSelectedDocument = url;
        
        documentData = [[NSData alloc] initWithContentsOfURL:url];
        documentData = [[NSData alloc] initWithContentsOfFile:[url path]];
        
        // File Name
        
        attachFileName.text = [url lastPathComponent];
        
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully attached %@", [url lastPathComponent]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}
/*
 *
 * Cancelled
 *
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Cancelled");
    
    NSString *alertMessage = @"Cancelled attachment";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}
- (IBAction)filterAssignment:(id)sender
{
    //      [self filterContentForSearchText:@"English"
    //                              scope:nil];
    //
    //    [self filterContentForSearchText:@"Music" scope:nil];
    //
    LUTimeTableDetailViewController *controller =[[LUTimeTableDetailViewController alloc]initWithNibName:@"LUTimeTableDetailViewController" bundle:nil];
    
    
    //controller.detailArray =@[@"Title",@"Author",@"ISBN",@"Edition",@"Published"];
    controller.delegatemethod=self;
    
    //    NSSet *set= [NSOrderedSet orderedSetWithArray:subjectName];
    //    subjectlistarray = [set allObjects];
    subjectlistarray = [[NSSet setWithArray:filterSubjectName] allObjects];
    controller.detailArray= subjectlistarray;//[cellData object];
    //
    
    
    controller.view.backgroundColor=[UIColor lightGrayColor];
    //colorWithRed:222.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:0.5
    controller.detailTable.backgroundColor =[UIColor lightGrayColor];
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    // in case we don't have a bar button as reference
    popController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
    popController.sourceRect = CGRectMake(50,140,0,0);
    controller.preferredContentSize =CGSizeMake(200, 400);
    popController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    popController.sourceView = self.view;
    
    
}
@end
