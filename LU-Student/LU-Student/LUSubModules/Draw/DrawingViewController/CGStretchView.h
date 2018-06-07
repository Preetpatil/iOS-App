//
//  CGStretchImageView.h
//  LUStudent

//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+FloodFill.h"

@class CGStretchView;

@protocol CGStretchViewDelegate <NSObject>

- (void)stretchViewTapped:(CGStretchView*)stretchView;
@end

@interface CGStretchView : UIView <UIGestureRecognizerDelegate>

@property int Tolerance;
//Settings for the stretch view
@property (nonatomic) BOOL panningEnabled;
@property (nonatomic) BOOL rotationEnabled;
@property (nonatomic) BOOL pinchToZoomEnabled;
@property (nonatomic) BOOL tappingEnabled;
@property (nonatomic) BOOL cornerButtonHidden;
@property (nonatomic) BOOL cornerButtonOriginallyHidden;
@property (assign) BOOL isFillActive;

//Be a replacement for UIImageViews
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *fillImage;
@property(nonatomic, strong) UIImageView *cropppedImageView;
//delegate for button presses
@property (nonatomic, assign) id<CGStretchViewDelegate> delegate;

@property (nonatomic, strong) UIColor *fillColor;


@end
