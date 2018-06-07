//
//  PopoverController.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ARCMacros.h"

#import "PopoverView.h"
#import "TouchView.h"


@class PopoverController;

@protocol PopoverControllerDelegate <NSObject>

@optional
- (void)popoverControllerDidDismissPopover:(PopoverController *)popoverController;
- (void)presentedNewPopoverController:(PopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(PopoverController*)visiblePopoverController;
@end

@interface PopoverController : UIViewController
{
    UIView *_parentView;
}
//ARC-enable and disable support
#if __has_feature(objc_arc)
    @property(nonatomic,weak) id<PopoverControllerDelegate> delegate;
#else
    @property(nonatomic,assign) id<PopoverControllerDelegate> delegate;
#endif

/** @brief PopoverArrowDirectionAny, PopoverArrowDirectionVertical or PopoverArrowDirectionHorizontal for automatic arrow direction.
 **/

/** @brief allow reading in order to integrate other open-source **/
@property(nonatomic,readonly) TouchView* touchView;
@property(nonatomic,readonly) PopoverView* contentView;

@property(nonatomic,assign) PopoverArrowDirection arrowDirection;

@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint origin;
@property(nonatomic,assign) CGFloat alpha;

/** @brief The tint of the popover. **/
@property(nonatomic,assign) PopoverTint tint;

/** @brief Popover border, default is YES **/
@property(nonatomic, assign) BOOL border;

/** @brief Initialize the popover with the content view controller
 **/
-(id)initWithViewController:(UIViewController*)viewController;
-(id)initWithViewController:(UIViewController*)viewController
				   delegate:(id<PopoverControllerDelegate>)delegate;

/** @brief Presenting the popover from a specified view **/
-(void)presentPopoverFromView:(UIView*)fromView;

/** @brief Presenting the popover from a specified point **/
-(void)presentPopoverFromPoint:(CGPoint)fromPoint;

/** @brief Dismiss the popover **/
-(void)dismissPopoverAnimated:(BOOL)animated;

/** @brief Dismiss the popover with completion block for post-animation cleanup **/
typedef void (^PopoverCompletion)();
-(void)dismissPopoverAnimated:(BOOL)animated completion:(PopoverCompletion)completionBlock;

/** @brief Hide the shadows to get better performances **/
-(void)setShadowsHidden:(BOOL)hidden;

/** @brief Refresh popover **/
-(void)setupView;


@end
