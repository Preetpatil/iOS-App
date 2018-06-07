//
//  LUStudentTextBookModuleViewController.m
//  LUStudent

//  Created by surabhi sharma on 17/05/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentTextBookModuleViewController.h"
#import "YRCoverFlowLayout.h"
#import "ReaderViewController.h"
@interface LUStudentTextBookModuleViewController ()<ReaderViewControllerDelegate>

@end

@implementation LUStudentTextBookModuleViewController
{
    
    __weak IBOutlet YRCoverFlowLayout *_coverFlowLayout;
    
    CGSize _originalItemSize;
    CGSize _originalCollectionViewSize;
    
    NSArray*imageArray;
    NSArray*array;
    NSMutableArray *name, *imglink, *pdflink;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    name = [[NSMutableArray alloc]init];
    imglink= [[NSMutableArray alloc]init];
    pdflink = [[NSMutableArray alloc]init];
    
    
    _originalItemSize = _coverFlowLayout.itemSize;
    
    _originalCollectionViewSize = _TextBookCollectionView.bounds.size;
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"photos" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"jsonString:%@",jsonString);
    array = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    [self getdata];
    //[self imageload];
    // Do any additional setup after loading the view, typically from a nib.
    //collection view reload
    //collection view data delegate

    // Do any additional setup after loading the view.
}



-(void)getdata{
    
    
    for (int i = 0; i<array.count; i++)
    {
        NSDictionary *itrDict = [array objectAtIndex:i];
        [name addObject:[itrDict objectForKey:@"name"]];
        [imglink addObject:[itrDict objectForKey:@"picture"]];
        [pdflink addObject:[itrDict objectForKey:@"url"]];
        
    }
    //    [_ShelfCollection  reloadData];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    //    [_ShelfCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_TextBookCollectionView reloadData];
    });
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // We should invalidate layout in case we are switching orientation.
    // If we won't do that we will receive warning from collection view's flow layout that cell size isn't correct.
    [_coverFlowLayout invalidateLayout];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Now we should calculate new item size depending on new collection view size.
    _coverFlowLayout.itemSize = (CGSize){
        _TextBookCollectionView.bounds.size.width * _originalItemSize.width / _originalCollectionViewSize.width,
        _TextBookCollectionView.bounds.size.height * _originalItemSize.height / _originalCollectionViewSize.height
    };
    
    // Forcely tell collection view to reload current data.
    [_TextBookCollectionView setNeedsLayout];
    [_TextBookCollectionView layoutIfNeeded];
    [_TextBookCollectionView reloadData];
}

-(void)imageload{
    
    
    imageArray = [NSArray arrayWithObjects: @"images1.jpg", @"images2.jpg", @"images.jpg", @"nature4@2x.png",@"nature5@2x.png", nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"textbookcell" forIndexPath:indexPath];
    
    
    cell.contentView.layer.cornerRadius = 50.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    
    cell.contentView.layer.masksToBounds = YES;
    
    
    cell.layer.shadowColor = [UIColor blueColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    
    UIImageView*imageview = (UIImageView *)[cell viewWithTag:100];
    
    imageview.image = [UIImage imageNamed:[imglink objectAtIndex:indexPath.row]];
    
    // imageview = imageArray[indexPath.row];
    
    //    CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
    //                                                                                             forIndexPath:indexPath];
    //
    //    cell.photoModel = _photoModelsDatasource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *docsDir  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath  =[[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"pdf"];
    
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    
    else
    {
        UIAlertController *alertController  =  [UIAlertController
                                                alertControllerWithTitle:@"Download Request"
                                                message:@"The Book you have selected is not available offline.\nClick OK to Download"
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
                                         UICollectionViewCell *cell  = [_TextBookCollectionView cellForItemAtIndexPath:indexPath];
                                         
                                         UIActivityIndicatorView *activityView  =  [[UIActivityIndicatorView alloc]
                                                                                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                         activityView.backgroundColor  =  [UIColor colorWithWhite:0.0f alpha:0.6f];
                                         activityView.center = cell.contentView.center;
                                         [activityView startAnimating];
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [cell.contentView addSubview:activityView];
                                         });
                                         
                                         NSURL *fileURL  =  [NSURL URLWithString:[pdflink objectAtIndex:indexPath.row]];
                                         
                                         NSURLSession *session  =  [NSURLSession sharedSession];
                                         
                                         [[session dataTaskWithURL:fileURL completionHandler:^(NSData *data,
                                                                                               NSURLResponse *response,
                                                                                               NSError *error)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   if(!error)
                                                   {
                                                       NSString *Path  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                                       NSString *filePath  =  [Path stringByAppendingPathComponent:[response suggestedFilename]];
                                                       [data writeToFile:filePath atomically:YES];
                                                       [activityView stopAnimating];
                                                   }
                                               });
                                               
                                           }] resume];
                                     }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}
//String *phrase = nil; // Document password (for unlocking most encrypted PDF files)
//
//NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
//
//NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
//
//ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
//
//if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
//{
//    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
//
//    readerViewController.delegate = self; // Set the ReaderViewController delegate to self
//
//#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
//
//    [self.navigationController pushViewController:readerViewController animated:YES];
//
//#else // present in a modal view controller
//
//    readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    [self presentViewController:readerViewController animated:YES completion:NULL];
//
//#endif // DEMO_VIEW_CONTROLLER_PUSH
//}
//else // Log an error so that we know that something went wrong
//{
//    NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
//}
//
//
#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}




@end
