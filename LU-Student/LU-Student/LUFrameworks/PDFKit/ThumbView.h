//
//	ThumbView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

@interface ThumbView : UIView
{
@protected // Instance variables

	UIImageView *imageView;
}

@property (atomic, strong, readwrite) NSOperation *operation;

@property (nonatomic, assign, readwrite) NSUInteger targetTag;

- (void)showImage:(UIImage *)image;

- (void)showTouched:(BOOL)touched;

- (void)reuse;

@end
