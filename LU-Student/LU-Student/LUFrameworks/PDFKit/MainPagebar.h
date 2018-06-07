//
//	MainPagebar.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#import "ThumbView.h"

@class MainPagebar;
@class TrackControl;
@class PagebarThumb;
@class Document;

@protocol MainPagebarDelegate <NSObject>

@required // Delegate protocols

- (void)pagebar:(MainPagebar *)pagebar gotoPage:(NSInteger)page;

@end

@interface MainPagebar : UIView

@property (nonatomic, weak, readwrite) id <MainPagebarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(Document *)object;

- (void)updatePagebar;

- (void)hidePagebar;
- (void)showPagebar;

@end

#pragma mark -

//
//	TrackControl class interface
//

@interface TrackControl : UIControl

@property (nonatomic, assign, readonly) CGFloat value;

@end

#pragma mark -

//
//	PagebarThumb class interface
//

@interface PagebarThumb : ThumbView

- (instancetype)initWithFrame:(CGRect)frame small:(BOOL)small;

@end

#pragma mark -

//
//	PagebarShadow class interface
//

@interface PagebarShadow : UIView

@end
