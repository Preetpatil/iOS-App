//
//  LUShelfContainerCellView.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//
#import "LUShelfContainerCellView.h"
#import "LUShelfCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface LUShelfContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@property (strong, nonatomic) NSArray *resourceCollectionData;
@property (strong, nonatomic) NSArray *drawingCollectionData;
@end


@implementation LUShelfContainerCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout  =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection  =  UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize  =  CGSizeMake(250.0, 200.0);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"LUShelfCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LUShelfCollectionViewCell"];
}

#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData
{
    _collectionData  =  collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}
- (void) setResourceCollectionData: (NSArray *) collectionData
{
    _resourceCollectionData  =  collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}
- (void)setDrawingCollectionData:(NSArray *)collectionData
{
    _drawingCollectionData  =  collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cnt;
    if (_collectionData!= nil)
    {
        cnt = [self.collectionData count];
    } else if(_resourceCollectionData!= nil)
    {
        cnt =  [self.resourceCollectionData count];
    }else if(_drawingCollectionData!= nil)
    {
        cnt =  [self.drawingCollectionData count];
    }
    return cnt;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LUShelfCollectionViewCell *cell  =  [collectionView dequeueReusableCellWithReuseIdentifier:@"LUShelfCollectionViewCell" forIndexPath:indexPath];
    if (_collectionData!= nil)
    {
        
        
        NSDictionary *cellData  =  [self.collectionData objectAtIndex:[indexPath row]];
        cell.UnitNoLabel.text  =  [cellData objectForKey:@"UnitName"];
        cell.UnitNameLabel.text =  [cellData objectForKey:@"TopicName"];
        NSString *temp = cellData[@"CategoryThumbinal"];
       
        UIImage *cpimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:temp]]];
        dispatch_async(dispatch_get_main_queue(), ^{

                        [cell.CoverImage setImage:cpimage];
            });
            }
                       
    else if(_resourceCollectionData!= nil)
    {
               NSDictionary *cellData  =  [_resourceCollectionData objectAtIndex:[indexPath row]];
    
        NSLog(@"%@", [cellData objectForKey:@"ResourceDocumentPath"]);
        NSLog(@"%@", [cellData objectForKey:@"ThumbnailImage"]);
        NSLog(@"%@", [cellData objectForKey:@"ResourceTitle"]);
        
        cell.UnitNoLabel.hidden =YES; //.text  =  [cellData objectForKey:@"ResourceTitle"];
        cell.UnitNameLabel.text =  [cellData objectForKey:@"ResourceTitleHeading"];
        NSString *temp = [cellData objectForKey:@"ThumbnailImage"];
        UIImage *cpimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:temp]]];
        dispatch_async(dispatch_get_main_queue(), ^{
 
                [cell.CoverImage setImage:cpimage];
       });
        
    }else if(_drawingCollectionData!= nil)
    {
        
        NSDictionary *cellData  =  [_drawingCollectionData objectAtIndex:[indexPath row]];
        //NSLog(@"%@", [cellData objectForKey:@"ResourceDocumentPath"]);
        NSLog(@"%@", [cellData objectForKey:@"ImageUrl"]);
        NSLog(@"%@", [cellData objectForKey:@"DrawingName"]);
        
        cell.UnitNoLabel.hidden =YES; //.text  =  [cellData objectForKey:@"ResourceTitle"];
        cell.UnitNameLabel.text =  [cellData objectForKey:@"DrawingName"];
        NSString *temp = [cellData objectForKey:@"ImageUrl"];
        UIImage *cpimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:temp]]];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [cell.CoverImage setImage:cpimage];
        });
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionData!= nil)
    {
        NSDictionary *cellData  =  [self.collectionData objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
    }else if(_resourceCollectionData!= nil)
    {
        NSDictionary *cellData  =  [_resourceCollectionData objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
    }else if(_drawingCollectionData!= nil)
    {
        NSDictionary *cellData  =  [_drawingCollectionData objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
    }
}
//#pragma mark - IBAction
//-(IBAction)actionRight:(UIButton *)sender {
//    NSArray *visibleItems  =  [self.collectionView indexPathsForVisibleItems];
//    NSArray *sortedIndexPaths  =  [visibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSIndexPath *path1  =  (NSIndexPath *)obj1;
//        NSIndexPath *path2  =  (NSIndexPath *)obj2;
//        return [path1 compare:path2];
//    }];
//    NSIndexPath *currentItem  =  [sortedIndexPaths objectAtIndex:2];
//    count  =  currentItem.row+1;
//    if (count<= self.collectionData.count-1) {
//        [self snapRightToCellAtIndex:count section:(int)currentItem.section withAnimation:YES];//paas index here to move to.
//    }
//    
//}
//-(IBAction)actionLeft:(UIButton *)sender {
//    NSArray *visibleItems  =  [self.collectionView indexPathsForVisibleItems];
//    NSArray *sortedIndexPaths  =  [visibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSIndexPath *path1  =  (NSIndexPath *)obj1;
//        NSIndexPath *path2  =  (NSIndexPath *)obj2;
//        return [path1 compare:path2];
//    }];
//    NSIndexPath *currentItem  =  [sortedIndexPaths objectAtIndex:0];
//    count  =  currentItem.row-1;
//    if (count>= 0) {
//       [self snapLeftToCellAtIndex:count section:(int)currentItem.section withAnimation:YES];//paas index here to move to.
//    }
//}
//
//- (void) snapRightToCellAtIndex:(NSInteger)index section:(int)currentSection withAnimation:(BOOL) animated
//{
//    NSIndexPath *nextItem  =  [NSIndexPath indexPathForItem:index inSection:currentSection];
//    [_collectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionRight animated:animated];
//}
//- (void) snapLeftToCellAtIndex:(NSInteger)index section:(int)currentSection withAnimation:(BOOL) animated
//{
//    NSIndexPath *prevItem  =  [NSIndexPath indexPathForItem:index inSection:currentSection];
//    [_collectionView scrollToItemAtIndexPath:prevItem atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
//}

@end
