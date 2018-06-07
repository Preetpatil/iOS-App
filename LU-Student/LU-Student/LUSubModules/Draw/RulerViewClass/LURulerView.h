//
//  LURulerView.h
//  LUStudent

//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LURulerView;



@interface LURulerView : UIView <UIGestureRecognizerDelegate>

//Settings for the stretch view
@property (nonatomic) BOOL panningEnabled;
@property (nonatomic) BOOL rotationEnabled;
@property (nonatomic) BOOL tappingEnabled;

//Be a replacement for UIImageViews
@property (nonatomic, strong) UIImage *image;



@end
