//
//	ContentView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#import "ThumbView.h"

@class ContentView;
@class ContentPage;
@class ContentThumb;

@protocol ContentViewDelegate <NSObject>

@required // Delegate protocols

- (void)contentView:(ContentView *)contentView touchesBegan:(NSSet *)touches;

@end

@interface ContentView : UIScrollView

@property (nonatomic, weak, readwrite) id <ContentViewDelegate> message;

- (instancetype)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase;

- (void)showPageThumb:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase guid:(NSString *)guid;

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer;

- (void)zoomIncrement:(UITapGestureRecognizer *)recognizer;
- (void)zoomDecrement:(UITapGestureRecognizer *)recognizer;
- (void)zoomResetAnimated:(BOOL)animated;
- (void) setContentDrawingImageView:(UIImage *) drawingImage;
@end

#pragma mark -

//
//	ContentThumb class interface
//

@interface ContentThumb : ThumbView

@end
