//
//	ThumbsMainToolbar.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#import "UIXToolbarView.h"

@class ThumbsMainToolbar;

@protocol ThumbsMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(ThumbsMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(ThumbsMainToolbar *)toolbar showControl:(UISegmentedControl *)control;

@end

@interface ThumbsMainToolbar : UIXToolbarView

@property (nonatomic, weak, readwrite) id <ThumbsMainToolbarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
