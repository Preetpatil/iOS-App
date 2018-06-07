//
//
//  LUShelfContainerCellView.h
//  LearningUmbrellaMaster

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface LUShelfContainerCellView : UIView
{
    NSInteger count;
    NSMutableDictionary *selectedIdx;
}

- (void) setCollectionData: (NSArray *) collectionData;
- (void) setResourceCollectionData: (NSArray *) collectionData;
- (void) setDrawingCollectionData:(NSArray *)collectionData;

@end
