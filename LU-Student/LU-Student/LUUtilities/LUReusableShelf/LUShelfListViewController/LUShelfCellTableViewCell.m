//
//
//  LUShelfCellTableViewCell.h
//  LearningUmbrellaMaster
//

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//
#import "LUShelfCellTableViewCell.h"
#import "LUShelfContainerCellView.h"
@interface LUShelfCellTableViewCell ()
@property (strong, nonatomic) LUShelfContainerCellView *collectionView;
@end
@implementation LUShelfCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _collectionView  =  [[NSBundle mainBundle] loadNibNamed:@"LUShelfContainerCellView" owner:self options:nil][0];
        _collectionView.frame  =  self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData
{
    [_collectionView setCollectionData:collectionData];
}
- (void)setResourceCollectionData:(NSArray *)collectionData
{
    [_collectionView setResourceCollectionData:collectionData];
}
- (void)setDrawingCollectionData:(NSArray *)collectionData
{
     [_collectionView setDrawingCollectionData:collectionData];
}
@end
