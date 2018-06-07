//
//	ThumbsViewController.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "ThumbsMainToolbar.h"
#import "ThumbsView.h"

@class Document;
@class ThumbsViewController;

@protocol ThumbsViewControllerDelegate <NSObject>

@required // Delegate protocols

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page;

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController;

@end

@interface ThumbsViewController : UIViewController

@property (nonatomic, weak, readwrite) id <ThumbsViewControllerDelegate> delegate;

- (instancetype)initWithDocument:(Document *)object;

@end

#pragma mark -

//
//	ThumbsPageThumb class interface
//

@interface ThumbsPageThumb : ThumbView

- (CGSize)maximumContentSize;

- (void)showText:(NSString *)text;

- (void)showBookmark:(BOOL)show;

@end
