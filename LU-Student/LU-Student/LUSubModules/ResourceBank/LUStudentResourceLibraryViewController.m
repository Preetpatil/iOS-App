//
//  LUStudentResourceLibraryViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 24/01/17.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentResourceLibraryViewController.h"

@interface LUStudentResourceLibraryViewController ()

@end

@implementation LUStudentResourceLibraryViewController{
    
    NSMutableArray*resourcelist;
    NSMutableArray *resourceSubjectList;
    NSMutableArray*ResourceUnitData;
    NSMutableArray*resourceunitname;
    NSMutableArray*ResourceResultArray;
    NSMutableArray*resourceTitle;
    NSMutableArray*titlearry;
    
    NSMutableDictionary*resourceunitDic;
    NSMutableDictionary*resourcelistDict;
    NSMutableDictionary*ResourcesResultDict;
    
    __weak IBOutlet UICollectionView *resourceSubjectCollection;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resourcelist=  [[NSMutableArray alloc]init];
    resourceSubjectList=  [[NSMutableArray alloc]init];
    resourceunitname=  [[NSMutableArray alloc]init];
    ResourceResultArray=[[NSMutableArray alloc]init];
    resourceTitle=  [[NSMutableArray alloc]init];
    titlearry=[[NSMutableArray alloc]init];
    
    
    resourcelistDict= [[NSMutableDictionary alloc]init];
    ResourceUnitData=[[NSMutableArray alloc]init];
    resourceunitDic= [[NSMutableDictionary alloc]init];
    ResourcesResultDict=[[NSMutableDictionary alloc]init];
    
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self fetchResource];
    // Do any additional setup after loading the view.
}

/**
 <#Description#>
 */
-(void)fetchResource
{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    NSDictionary *profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton resourceLibraryList:ResourceLibrary_link body:@{@"ClassId":[profileDetails objectForKey:@"ClassId"]}];
    
    
    
    
    // [resourceSubjectCollection reloadData];
    //    NSString *dataUrl  =  ResourceLibrary_link;
    //    NSURLSession *session  =  [NSURLSession sharedSession];
    //    NSURLSessionDataTask *dataTask  =  [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    //                                        {
    //                                            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                                         NSDictionary *response =  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //                                                for (int i=0; i<response.count; i++)
    //                                                {
    //                                                    resourceSubjectList = [response objectForKey:@"subject"];
    //                                                }
    //                                                [resourceSubjectCollection reloadData];
    //                                            });
    //                                        }];
    //    [dataTask resume];
    
}


/**
 <#Description#>
 
 @param resourcelibrarylist description
 */
-(void)resourceLibraryList:(NSDictionary *)resourcelibrarylist
{
    
    resourcelist=[resourcelibrarylist objectForKey:@"ResourceBank"];
    NSLog(@"%@",resourcelist);
    
    if ([resourcelist count]==0)
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Empty"
                                     message:@"No resource found"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* OK = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 
                                 
                             }];
        
        
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        // [[LUUtilities removeActivityIndicator] removeFromSuperview];
        
        
        for (int i=0; i<resourcelist.count; i++)
        {
            
            resourcelistDict=[resourcelist objectAtIndex:i];
            // resourceSubjectList =[resourcelistDict objectForKey:@"SubjectName"];
            [resourceSubjectList addObject:[resourcelistDict objectForKey:@"SubjectName"]];
            //unitdata
            [ResourceUnitData addObject:[resourcelistDict objectForKey:@"unitdata"]];
            
            
            //        for (int i=0;i<ResourceUnitData.count; i++)
            //        {
            //            resourceunitDic =[ResourceUnitData objectAtIndex:i];
            //             [resourceunitname addObject:[resourceunitDic objectForKey:@"UnitName"]];
            //           // resourceunitname=[resourceunitDic objectForKey:@"UnitName"];
            //
            //           // ResourceResultArray=[resourceunitDic objectForKey:@"resourceresult"];
            //            [ResourceResultArray addObject:[resourceunitDic objectForKey:@"resourceresult"]];
            //            NSLog(@"%@",ResourceResultArray);
            //            for (int i=0; i<ResourceResultArray.count; i++)
            //            {
            //
            //
            //                ResourcesResultDict= [ResourceResultArray objectAtIndex:i];
            //                //[resourceTitle addObject:[ResourcesResultDict objectForKey:@"resourceresult"]];
            //                resourceTitle=[ResourcesResultDict objectForKey:@"ResourceTitle"];
            //                [titlearry addObject:resourceTitle];
            //
            //            }
            // NSLog(@"%@",ResourceResultArray);
            //  }
            
            // NSLog(@"%@",ResourceUnitData);
            
            
        }
        
        // NSLog(@"%@",ResourceUnitData);
        //}
        
        [resourceSubjectCollection reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return resourceSubjectList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resourceCELL" forIndexPath:indexPath];
    UILabel *subLbl = (UILabel *)[cell viewWithTag:100];
    subLbl.text = [resourceSubjectList objectAtIndex:indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LUShelfListViewController *pushToShelf = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentNotesVC"];
    pushToShelf.setResource = YES;
    pushToShelf.header = [resourceSubjectList objectAtIndex:indexPath.row];
    pushToShelf.resourceSubjectName = [resourceSubjectList objectAtIndex:indexPath.row];
    pushToShelf.resourceSubjectList = [ResourceUnitData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pushToShelf animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
