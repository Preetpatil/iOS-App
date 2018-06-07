//
//  LUStudentMainDrawingViewController.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentMainDrawingViewController.h"
#import "DrawingDataManager.h"
@interface LUStudentMainDrawingViewController ()

@end

@implementation LUStudentMainDrawingViewController
{
    NSArray *artnameArr;
    NSArray *artimageArr;
    NSArray *drawings;
    NSArray *artcatagoryArry;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[DrawingDataManager getSharedInstance]createDrawingDB:@"Drawing"];
    [self dataFetcher];
    //[self drawingcollectonMthd];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self dataFetcher];
    //dispatch_async(dispatch_get_main_queue(), ^{
    [_DrawingCollection reloadData];
    //});
}

/**
 <#Description#>
 */
-(void)dataFetcher
{
    drawings = [[DrawingDataManager getSharedInstance]viewAllArt:@"Drawing"];
    artnameArr = [drawings objectAtIndex:0];
    artimageArr = [drawings objectAtIndex:1];
    artcatagoryArry=[drawings objectAtIndex:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark CollectionView Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return artimageArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"artCELL" forIndexPath:indexPath];
    
    [cell.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setShadowRadius:5.0];
    [cell.layer setShadowOpacity:0.8];
    
    UIImageView *img  =  (UIImageView *)[cell viewWithTag:100];
    img.image = [UIImage imageWithData:[artimageArr objectAtIndex:indexPath.row]];
    UILabel *imgName  =  (UILabel *)[cell viewWithTag:101];
    imgName.text = [artnameArr objectAtIndex:indexPath.row];
    UILabel *imgCatagory  =  (UILabel *)[cell viewWithTag:102];
    imgCatagory.text = [artcatagoryArry  objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LUDrawingViewController *pushToDraw = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentDrawingVC"];
    
    pushToDraw.artName = [artnameArr objectAtIndex:indexPath.row];
    pushToDraw.artImage = [artimageArr objectAtIndex:indexPath.row];
    pushToDraw.artCatagory=[artcatagoryArry objectAtIndex:indexPath.row];
    pushToDraw.DBName = @"Drawing";
    [self.navigationController pushViewController:pushToDraw animated:YES];
}

#pragma mark -
int createArtTap = 0;
/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)createArt:(id)sender
{
    createArtTap++;
    if (createArtTap == 1)
    {
        _createArtTopOffset.constant = 136;
        [UIView animateWithDuration:1.0 animations:^{
            [_createArtView layoutIfNeeded];
        }];
    }else if (createArtTap == 2)
    {
        createArtTap = 0;
        _createArtTopOffset.constant = -57;
        [UIView animateWithDuration:1.0 animations:^{
            [_createArtView layoutIfNeeded];
        }];
    }
}

/**
 <#Description#>
 */
-(void)closeCreate
{
    createArtTap = 0;
    _createArtTopOffset.constant = -57;
    [UIView animateWithDuration:1.0 animations:^{
        [_createArtView layoutIfNeeded];
    }];
}

/**
 <#Description#>
 
 @return <#return value description#>
 */
- (NSString *) checkMandatoryFields
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString * resultString = @"";
    if([_artName.text isEqualToString:@""])
    {
        [array addObject:@"Name"];
        resultString = [resultString stringByAppendingString:@"'Name'"];
    }
    
    if([_artCategory.text isEqualToString:@""])
    {
        [array addObject:@"Category"];
        resultString = [resultString stringByAppendingString:@"'Category'"];
    }
    
    
    return resultString;
}







/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)createArtBoardBtn:(id)sender
{
    
    NSString *mandatoryFields = [self checkMandatoryFields];
    if(mandatoryFields && [mandatoryFields isEqualToString:@""])
    {
        
        [_createArtBtn setSelected:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([artnameArr containsObject:_artName.text])
            {
                NSLog(@"art exists");
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
                
                success = [[DrawingDataManager getSharedInstance]saveDrawing:_artName.text page:[NSData dataWithData:UIImagePNGRepresentation(img)] catagory:_artCategory.text DB:@"Drawing" ];
                
                
                LUDrawingViewController *pushToDraw = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentDrawingVC"];
                pushToDraw.DBName = @"Drawing";
                pushToDraw.artName = _artName.text;
                pushToDraw.artCatagory=_artCategory.text;
                
                [self.navigationController pushViewController:pushToDraw animated:YES];
            }
            [self closeCreate];
            [self dataFetcher];
            [_DrawingCollection reloadData];
        });
        
    }
    else{
        
        
        
        NSString *alertMessage = [NSString stringWithFormat:@"Update the fields %@",mandatoryFields];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Alert"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }
    
}

/**
 <#Description#>
 
 @param sender <#sender description#>
 */
- (IBAction)search:(id)sender
{
    
}


@end

