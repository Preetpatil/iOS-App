//
//  LUCoverFlowLayout.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//
@import UIKit;

/**
 *  Layout to add cover flow effect to collection view scrolling.
 *  Applicable only for horizontal flow direction.
 */
@interface LUCoverFlowLayout : UICollectionViewFlowLayout

/**
 *  Max degree that can be applied to individual item.
 *  Default to 45 degrees.
 */
@property (nonatomic) CGFloat maxCoverDegree;

/**
 *  Determines how elements covers each other.
 *  Should be in range 0..1.
 *  Default to 0.25.
 *  Examples:
 *  0 means that items are placed within a continuous line.
 *  0.5 means that half of 3rd and 1st item will be behind 2nd.
 */
@property (nonatomic) CGFloat coverDensity;

/**
 *  Min opacity that can be applied to individual item.
 *  Default to 1.0 (alpha 100%).
 */
@property (nonatomic) CGFloat minCoverOpacity;

/**
 *  Min scale that can be applied to individual item.
 *  Default to 1.0 (no scale).
 */
@property (nonatomic) CGFloat minCoverScale;

@end
