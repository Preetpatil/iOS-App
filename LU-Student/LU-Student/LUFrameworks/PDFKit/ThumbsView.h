//
//	ThumbsView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//

#import <UIKit/UIKit.h>

#import "ThumbView.h"

@class ThumbsView;

@protocol ThumbsViewDelegate <NSObject, UIScrollViewDelegate>

@required // Delegate protocols

- (NSUInteger)numberOfThumbsInThumbsView:(ThumbsView *)thumbsView;

- (id)thumbsView:(ThumbsView *)thumbsView thumbCellWithFrame:(CGRect)frame;

- (void)thumbsView:(ThumbsView *)thumbsView updateThumbCell:(id)thumbCell forIndex:(NSInteger)index;

- (void)thumbsView:(ThumbsView *)thumbsView didSelectThumbWithIndex:(NSInteger)index;

@optional // Delegate protocols

- (void)thumbsView:(ThumbsView *)thumbsView refreshThumbCell:(id)thumbCell forIndex:(NSInteger)index;

- (void)thumbsView:(ThumbsView *)thumbsView didPressThumbWithIndex:(NSInteger)index;

@end

@interface ThumbsView : UIScrollView

@property (nonatomic, weak, readwrite) id <ThumbsViewDelegate> delegate;

- (void)setThumbSize:(CGSize)thumbSize;

- (void)reloadThumbsCenterOnIndex:(NSInteger)index;

- (void)reloadThumbsContentOffset:(CGPoint)newContentOffset;

- (void)refreshThumbWithIndex:(NSInteger)index;

- (void)refreshVisibleThumbs;

- (CGPoint)insetContentOffset;

@end
