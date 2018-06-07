//
//  LUStudentTextBookViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentTextBookViewController.h"

@interface LUStudentTextBookViewController ()

@end

@implementation LUStudentTextBookViewController
{
    NSMutableArray *name, *imglink, *pdflink, *onlineLink;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
   // [self textBookFetcher];
    
    name = [[NSMutableArray alloc]init];
    imglink = [[NSMutableArray alloc]init];
    pdflink = [[NSMutableArray alloc]init];
    onlineLink = [[NSMutableArray alloc]init];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return name.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textbookcell" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

        NSURL *imageUrl  =  [NSURL URLWithString:[imglink objectAtIndex:indexPath.row]];
        UIImage *image  =  [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        UIImageView *myImageView  =  (UIImageView *)[cell viewWithTag:101];
        
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            myImageView.image = image;
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *docsDir  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath  =  [NSBundle pathForResource:[name objectAtIndex:indexPath.row] ofType:@"pdf" inDirectory:docsDir];
//    
//    Document *document  =  [Document withDocumentFilePath:filePath password:nil];
//    
//    if (document !=  nil)
//    {
//        ViewController *Controller  =  [[ViewController alloc]initWithDocument:document];
//        Controller.delegate  =  self;
//        
//        Controller.modalTransitionStyle  =  UIModalTransitionStyleCrossDissolve;
//        Controller.modalPresentationStyle  =  UIModalPresentationFullScreen;
//        
//        [self.navigationController presentViewController:Controller animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertController *alertController  =  [UIAlertController
//                                              alertControllerWithTitle:@"Download Request"
//                                              message:@"The Book you have selected is not available offline.\nClick OK to Download"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction  =  [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           
//                                       }];
//        
//        UIAlertAction *okAction  =  [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       UICollectionViewCell *cell  = [_ShelfCollection cellForItemAtIndexPath:indexPath];
//                                       
//                                       UIActivityIndicatorView *activityView  =  [[UIActivityIndicatorView alloc]
//                                                                                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//                                       activityView.backgroundColor  =  [UIColor colorWithWhite:0.0f alpha:0.6f];
//                                       activityView.center = cell.contentView.center;
//                                       [activityView startAnimating];
//                                       
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           [cell.contentView addSubview:activityView];
//                                       });
//                                       
//                                       NSURL *fileURL  =  [NSURL URLWithString:[pdflink objectAtIndex:indexPath.row]];
//                                       
//                                       NSURLSession *session  =  [NSURLSession sharedSession];
//                                       
//                                       [[session dataTaskWithURL:fileURL completionHandler:^(NSData *data,
//                                                                                             NSURLResponse *response,
//                                                                                             NSError *error)
//                                         {
//                                             dispatch_async(dispatch_get_main_queue(), ^{
//                                                 if(!error)
//                                                 {
//                                                     NSString *Path  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                                                     NSString *filePath  =  [Path stringByAppendingPathComponent:[response suggestedFilename]];
//                                                     [data writeToFile:filePath atomically:YES];
//                                                     [activityView stopAnimating];
//                                                 }
//                                             });
//                                             
//                                         }] resume];
//                                   }];
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}


/**
 <#Description#>
 */
-(void)textBookFetcher
{
//    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
//    sharedSingleton.LUDelegateCall=self;
//    [sharedSingleton textBookList:TextBook_link];
    
//    NSString *dataUrl  =  TextBook_link;
//    NSURLSession *session  =  [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask  =  [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                      {
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              NSArray *jresponce  =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                              for (int i = 0; i<jresponce.count; i++)
//                                              {
//                                                  NSDictionary *itrDict = [jresponce objectAtIndex:i];
//                                                  [name addObject:[itrDict objectForKey:@"name"]];
//                                                  [imglink addObject:[itrDict objectForKey:@"photo"]];
//                                                  [pdflink addObject:[itrDict objectForKey:@"pdf"]];
//                                                  [onlineLink addObject:[itrDict objectForKey:@"link"]];
//                                              }
//                                              [_ShelfCollection  reloadData];
//                                              NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
//                                              [_ShelfCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//                                          });
//                                      }];
//    [dataTask resume];
}


/**
 <#Description#>

 @param textbooklist <#textbooklist description#>
 */
-(void)textBookList:(NSArray *)textbooklist
{
    for (int i = 0; i<textbooklist.count; i++)
    {
        NSDictionary *itrDict = [textbooklist objectAtIndex:i];
        [name addObject:[itrDict objectForKey:@"name"]];
        [imglink addObject:[itrDict objectForKey:@"photo"]];
        [pdflink addObject:[itrDict objectForKey:@"pdf"]];
        [onlineLink addObject:[itrDict objectForKey:@"link"]];
    }
    [_ShelfCollection  reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    [_ShelfCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}


/**
 <#Description#>

 @param viewController <#viewController description#>
 */
//-(void)dismissViewController:(ViewController *)viewController
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
