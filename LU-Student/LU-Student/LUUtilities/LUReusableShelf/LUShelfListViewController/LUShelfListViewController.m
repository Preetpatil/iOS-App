//
//  LUShelfListViewController.h
//  LearningUmbrellaMaster
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUShelfListViewController.h"
#import "LUShelfContainerCellView.h"
#import "LUShelfCellTableViewCell.h"
#import "LUNotesMainDataManager.h"
@interface LUShelfListViewController ()

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sampleData;

//Teacher add resource
@property (weak, nonatomic) IBOutlet UIPickerView *unitNamePicker;
@property (weak, nonatomic) IBOutlet UIButton *addResourceButton;
@property (weak, nonatomic) IBOutlet UITextField *enterResourceTitle;
@property (weak, nonatomic) IBOutlet UITextField *enterResourceHeading;
@property (weak, nonatomic) IBOutlet UITextField *enterVideoUrl;
@property (weak, nonatomic) IBOutlet UITextField *addAttachmentLink;
@property (weak, nonatomic) IBOutlet UIImageView *getThumbnailImage;


////
@end

@implementation LUShelfListViewController
{
    
    //NSMutableArray *mainArray,*temp;
    NSArray *mainArray;
    NSArray *subjectList;
    NSString *strThumbnail ;
    UIActivityIndicatorView *activityView;
    NSData* documentData;
    NSURL *urlOfSelectedDocument;
    NSMutableArray *ClassId_login, *ClassName_login, *SectionData_login,*SectionId_login,*SectionName_login,*Subjectresult_login,*subjectnameResponse,*SubjectId_login,*SubjectName_login,*selectUnit,*selectUnitID;
    NSString *unitID,*resourceTitle,*resourceHeading,*videoUrl,*attachmentLink;
    UIWebView *webView;
    NSMutableArray *resourceClassList,*resourceClassId,*resourceSubjectList,*resourceSubjectId,*resourceUnitData,*subjectDetails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    _addResourceView.hidden = YES;
    _HeaderLbl.text = _header;
    _addResourceButton.hidden = YES;
    
    ClassId_login = [[NSMutableArray alloc]init];
    ClassName_login = [[NSMutableArray alloc]init];
    SectionData_login = [[NSMutableArray alloc]init];
    SectionId_login = [[NSMutableArray alloc]init];

    SectionName_login = [[NSMutableArray alloc]init];

    Subjectresult_login = [[NSMutableArray alloc]init];
    subjectnameResponse = [[NSMutableArray alloc]init];
    SubjectId_login = [[NSMutableArray alloc]init];
    SubjectName_login = [[NSMutableArray alloc]init];
    
    
    resourceClassList = [[NSMutableArray alloc]init];
    subjectDetails = [[NSMutableArray alloc]init];
    resourceSubjectList = [[NSMutableArray alloc]init];
    resourceUnitData = [[NSMutableArray alloc]init];
    resourceClassId = [[NSMutableArray alloc]init];
    resourceSubjectId = [[NSMutableArray alloc]init];

//        activityView  =  [[UIActivityIndicatorView alloc]
//                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    
    [self.view addSubview:[LUUtilities showActivityIndicator:self.view.bounds]];

//    activityView.center = self.view.center;
//    [activityView startAnimating];
//    [_tableView addSubview:activityView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //temp = [[NSMutableArray alloc]init];
    //mainArray = [[NSMutableArray alloc]init];
    
     [self initializeNotesView];
}






- (void) initializeNotesView
{
    if (_setResource != YES)
    {// JSON File...
        
        NSError *error;
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Notes" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        NSLog(@"jsonString:%@",jsonString);
        mainArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
      
            [_tableView reloadData];
            [[LUUtilities removeActivityIndicator] removeFromSuperview];
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
        
        
        
//        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
//        sharedSingleton.LUDelegateCall=self;
//        [sharedSingleton notesList:_URL_link];
    }
    else  if (_setTeacherResource==YES)
    {
        
        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
        sharedSingleton.LUDelegateCall=self;
        [sharedSingleton teacherResourceLibraryList:Teacher_resource_library];
        
    
    
        
        _addResourceButton.hidden = NO;
        
        
      /*
        
        NSLog(@"%@",_resourceSubjectList);
       
        mainArray =_resourceSubjectList;
        [_tableView reloadData];
       */
        [[LUUtilities removeActivityIndicator] removeFromSuperview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
        
        
        
        
        
    }else if (_setTeacherDrawing == YES)
    {
        mainArray = _teacherDrawingList;
         [_tableView reloadData];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
         [[LUUtilities removeActivityIndicator] removeFromSuperview];
    }
    else
    {
        NSLog(@"%@",_resourceSubjectList);
        
        mainArray =_resourceSubjectList;
        [_tableView reloadData];
        [[LUUtilities removeActivityIndicator] removeFromSuperview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];

//        NSString *dataUrl  = [NSString stringWithFormat:@"%@&subject=%@",ResourceLibrary_link,_resourceSubjectName];
//        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
//        sharedSingleton.LUDelegateCall=self;
//        [sharedSingleton resourceLibraryDetailList:dataUrl];
    }
}




-(void)teacherResourcesLibraryList:(NSDictionary *)teachersResoureList
{
    NSArray *arr1 = [teachersResoureList objectForKey:@"ResourceBank"];
    
    NSLog(@"%@ %@",_classId,_subjectId);
    
    for (int i=0; i<arr1.count; i++)
    {
        NSDictionary *dict1 = [arr1 objectAtIndex:i];
        NSLog(@"%@",dict1);
        
        if ([[dict1 objectForKey:@"Id"] isEqualToString:_classId])
        
            
        {
            //[resourceClassId addObject:[dict1 objectForKey:@"Id"]];
           // [resourceClassList addObject:[dict1 objectForKey:@"ClassName"]];
           NSArray *temp = [dict1 objectForKey:@"subjectdata"];
            
            //NSArray *arr1 = [subjectDetails objectAtIndex:indexPath.row];
            for (int i=0; i<temp.count; i++)
            {
                NSDictionary *dict1 = [temp objectAtIndex:i];
                
                if ([[dict1 objectForKey:@"Id"] isEqualToString:_subjectId])
                {
                  
                   
                    mainArray =[dict1 objectForKey:@"unitdata"];
                    [_tableView reloadData];
                }
            }
        }
    }
   
}



#pragma Delegate method
//-(void)noteList:(NSArray *)notesList
//{
//
//    mainArray=notesList;
//    [_tableView reloadData];
//    [[LUUtilities removeActivityIndicator] removeFromSuperview];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
//
//}
-(void)resourceLibraryDetailList:(NSArray *)resourcelibrarydetaillist
{
    mainArray =resourcelibrarydetaillist;
    [_tableView reloadData];
     [[LUUtilities removeActivityIndicator] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mainArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier  =  [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",indexPath.section];
    LUShelfCellTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil  ==  cell)
    {
        cell  =  [[LUShelfCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        NSDictionary *cellData  =  [mainArray objectAtIndex:[indexPath section]];
        NSArray *BlockData;
        if (_setResource!=YES)
        {
            BlockData  = [cellData objectForKey:@"units"];
            [cell setCollectionData:BlockData];
        }else if (_setTeacherDrawing == YES)
        {
            BlockData  = [cellData objectForKey:@"drawings"];
            [cell setDrawingCollectionData:BlockData];
        }
        else
        {
            BlockData  = [cellData objectForKey:@"resourceresult"];//resourceresult unitdata
            [cell setResourceCollectionData:BlockData];
        }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionData  =  [mainArray objectAtIndex:section];
    NSString *header;
    if (_setResource != YES) {
         header  =  [sectionData objectForKey:@"SubjectName"];
    }else if(_setTeacherDrawing ==YES)
    {
        header  = [sectionData objectForKey:@"DrawingCategoryName"];
    }
    else
    {
         header  =  [sectionData objectForKey:@"UnitName"];
    }
   
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}

#pragma mark - NSNotification to select table cell
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData  =  [notification object];
    NSLog(@"Data:-->%@",cellData);
    if (_setResource != YES)
    {
        LUWriteNotesViewController *pushToWrite = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentWriteNotesVC"];
        NSCharacterSet *notAllowedChars  =  [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSString* filteredUnitName  =  [[[cellData objectForKey:@"TopicName"] componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        pushToWrite.FlashCoverImage = [cellData objectForKey:@"CategoryThumbinal"];
        //pushToWrite.FlashSubjectName = [cellData objectForKey:@"subject_name"];
        pushToWrite.moduleName = @"Notes";
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
        NSDictionary *profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
        pushToWrite.studentId =  [profileDetails objectForKey:@"StudentId"] ;
        pushToWrite.subjectCategoryId = [cellData objectForKey:@"SubjectNotesCategoryId"];
        pushToWrite.FlashUniteNo = [cellData objectForKey:@"UnitName"];
        pushToWrite.FlashUniteName = filteredUnitName;
        pushToWrite.FlashPageType = [cellData objectForKey:@"PageTypeName"];
        BOOL success  =  NO;
        success  =  [[LUNotesMainDataManager getSharedInstance]createDB:filteredUnitName];
        NSLog(success ? @"Yes Notes created" : @"No notes created");
        [self.navigationController pushViewController:pushToWrite animated:YES];
    }else if (_setTeacherDrawing == YES) {
        
        
        
    }
    
    
    
    else
    {
        NSDictionary *cellData  =  [notification object];
        NSLog(@"Data:-->%@",cellData);
         LUVideoPlayerViewController *toPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentVideoVC"];
        if (! [[cellData objectForKey:@"ResourceDocumentPath"] isEqualToString:@""])
        {
            toPlayer.videoID = [cellData objectForKey:@"ResourceDocumentPath"];
            toPlayer.type = @"2";
        }
        else if (![[cellData objectForKey:@"ResourcePath"] isEqualToString:@""])
        {
            toPlayer.videoID = [cellData objectForKey:@"ResourcePath"];
            toPlayer.type = @"1";
        }
        
        
        toPlayer.header = [cellData objectForKey:@"title_heading"];
        [self.navigationController pushViewController:toPlayer animated:YES];
        
        
//
//        toPlayer.type = [cellData objectForKey:@"type"];
//        toPlayer.videoID = [cellData objectForKey:@"ResourceDocumentPath"];
//        toPlayer.header = [cellData objectForKey:@"title_heading"];
//        [self.navigationController pushViewController:toPlayer animated:YES];
//
    }
}
- (IBAction)teacherAddResource:(id)sender
{
    selectUnit = [[NSMutableArray alloc]init];
    selectUnitID = [[NSMutableArray alloc]init];
    for (int i=0; i<mainArray.count; i++)
    {
        NSDictionary *temp = [mainArray objectAtIndex:i];
        [selectUnit addObject:[temp objectForKey:@"UnitName"]];
        [selectUnitID addObject:[temp objectForKey:@"UnitSubjectId"]];
        
    }
    unitID = [selectUnitID objectAtIndex:0];
    _addResourceView.hidden = NO;
    [_unitNamePicker reloadAllComponents];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return selectUnit.count ;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return selectUnit[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    unitID = selectUnitID[row];
    
    
}

- (IBAction)teacherCancelAddView:(id)sender
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Warning"
                                 message:@"Are You Sure Want to Cancel!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    _addResourceView.hidden = YES;
                                    _enterResourceTitle.text = nil;
                                    _enterResourceHeading.text = nil;
                                    _enterVideoUrl.text = nil;
                                    _addAttachmentLink.text = nil;
                                    _getThumbnailImage.image = nil;
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                  
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
   
}

- (IBAction)doneAddingResource:(id)sender
{
    
   resourceTitle =  _enterResourceTitle.text;
   resourceHeading = _enterResourceHeading.text;
   //videoUrl = _enterVideoUrl.text;
     videoUrl = [self extractYoutubeIdFromLink:_enterVideoUrl.text];
   attachmentLink = _addAttachmentLink.text;
    if ((_enterVideoUrl.text.length == 0 && _addAttachmentLink.text.length == 0) || (_enterVideoUrl.text.length > 0 && _addAttachmentLink.text.length > 0))
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:@"Please provide Resource Path Url or Resource Document."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        NSMutableDictionary *passBody = [[NSMutableDictionary alloc]init];
        [passBody setObject:_classId forKey:@"ClassId"];
        [passBody setObject:_subjectId forKey:@"SubjectId"];
        [passBody setObject:unitID forKey:@"UnitSubjectId"];
        [passBody setObject:resourceTitle forKey:@"ResourceTitle"];
        [passBody setObject:resourceHeading forKey:@"ResourceTitleHeading"];
        
//        [passBody setObject:[attachmentLink pathExtension] forKey:@"ResourceFileExtension"];
//        [passBody setObject:videoUrl forKey:@"ResourcePath"];
        if (videoUrl != nil)
        {
            [passBody setObject:videoUrl forKey:@"ResourcePath"];
            // [passBody setObject:@"" forKey:@"ResourceAttachFileUrl"];
            [passBody setObject:strThumbnail forKey:@"ThumbnailImage"];
            [passBody setObject:@"" forKey:@"ResourceAttachFileUrl"];
            
            [passBody setObject:@"" forKey:@"ResourceFileExtension"];
            documentData = nil;
        }
        
        if (documentData!=nil)
        {
//            NSString *strResource = [documentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//            NSString *strThumbnail = [UIImagePNGRepresentation(_getThumbnailImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//            [passBody setObject:strResource forKey:@"ResourceAttachFileUrl"];
//            [passBody setObject:strThumbnail forKey:@"ThumbnailImage"];
            //documentData=nil;
            
            NSString *strResource = [documentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSString *strThumbnail = [UIImagePNGRepresentation(_getThumbnailImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [passBody setObject:@"" forKey:@"ResourcePath"];
            [passBody setObject:strResource forKey:@"ResourceAttachFileUrl"];
            [passBody setObject:strThumbnail forKey:@"ThumbnailImage"];
            [passBody setObject:[attachmentLink pathExtension] forKey:@"ResourceFileExtension"];
        }
        
        
        LUOperation *sharedSingleton = [LUOperation getSharedInstance];
        sharedSingleton.LUDelegateCall=self;
        [sharedSingleton postResource:Teacher_resource_Post body:passBody];
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (! [_enterVideoUrl.text isEqualToString:@""]) {
        NSString *vid =  [self extractYoutubeIdFromLink:_enterVideoUrl.text];
        _getThumbnailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/1.jpg",vid]]]];
        strThumbnail =  [UIImagePNGRepresentation(_getThumbnailImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
}
- (NSString *)extractYoutubeIdFromLink:(NSString *)link
{
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}



-(void)postResource:(NSDictionary *)teachersResoureList
{
    
   int code = [[teachersResoureList objectForKey:@"code"]intValue];
    
    if (code == 400)
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Caution"
                                     message:@"Invalid video resource"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                       
                                        _enterVideoUrl.text = nil;
                                        
                                    }];
        
        
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    NSString *statusMessage =[teachersResoureList objectForKey:@"message"];
    
    
    if (code == 200)
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Success"
                                     message:statusMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        _addResourceView.hidden = YES;
                                        _enterResourceTitle.text = nil;
                                        _enterResourceHeading.text = nil;
                                        _enterVideoUrl.text = nil;
                                        _addAttachmentLink.text = nil;
                                        _getThumbnailImage.image = nil;
                                        NSLog(@"%@",[teachersResoureList objectForKey:@"unitdata"]);
                                        [self initializeNotesView];
//                                        mainArray =[teachersResoureList objectForKey:@"unitdata"];
//                                        [_tableView reloadData];

//                                        (
//                                        {
//                                            UnitName = "Unit 1";
//                                            UnitSubjectId = 2;
//                                            resourceresult =     (
//                                                                  {
//                                                                      CreatedAt = "2017-07-26 12:37:14";
//                                                                      Id = 4;
//                                                                      ResourceDocumentPath = "http:/
//                                        
                                    }];
        
      
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
       
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (IBAction)attachResource:(id)sender
{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - iCloud files
-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker

{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        urlOfSelectedDocument = url;
        NSLog(@"Opened %@", url.path);
        _addAttachmentLink.text = url.path;
        documentData = [[NSData alloc] initWithContentsOfURL:url];
        documentData = [[NSData alloc] initWithContentsOfFile:[url path]];
        
        if ([[url pathExtension] isEqualToString:@"pdf"])
        {
         _getThumbnailImage.image = [self getThumbanil:urlOfSelectedDocument];
        
        } else
        {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlOfSelectedDocument];
            
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,700, 900)];
            [webView loadRequest:urlRequest];
           
            
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(targetMethod)
                                           userInfo:nil
                                            repeats:NO];
            
            
            NSLog(@"yo");
        }
        _addAttachmentLink.text = [url lastPathComponent];
        
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
-(void)targetMethod
{
_getThumbnailImage.image = [self someMethodTrial:webView];
}
/*
 *
 * Cancelled
 *
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
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



-(UIImage *)someMethodTrial:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return viewImage;
}


////////////// Thumbnail
-(UIImage *)getThumbanil:(NSURL *)finalPath
{
    //NSURL* pdfFileUrl = [NSURL fileURLWithPath:finalPath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)finalPath);
    CGPDFPageRef page;
    
    CGRect aRect = CGRectMake(0, 0, 158, 213); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage* thumbnailImage;
    
    
    NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdf);
    
    for(int i = 0; i < 1; i++ ) {
        
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, aRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextSetGrayFillColor(context, 1.0, 1.0);
        CGContextFillRect(context, aRect);
        
        
        // Grab the first PDF page
        page = CGPDFDocumentGetPage(pdf, i + 1);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
        // And apply the transform.
        CGContextConcatCTM(context, pdfTransform);
        
        CGContextDrawPDFPage(context, page);
        
        // Create the new UIImage from the context
        thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //Use thumbnailImage (e.g. drawing, saving it to a file, etc)
        
        CGContextRestoreGState(context);
        
}


UIGraphicsEndImageContext();
CGPDFDocumentRelease(pdf);
    return thumbnailImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
