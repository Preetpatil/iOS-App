//
//	ThumbView.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//

#import "ThumbView.h"

@implementation ThumbView
{
	NSOperation *_operation;

	NSUInteger _targetTag;
}

#pragma mark - Properties

@synthesize operation  =  _operation;
@synthesize targetTag  =  _targetTag;

#pragma mark - ThumbView instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self  =  [super initWithFrame:frame]))
	{
		self.autoresizesSubviews  =  NO;
		self.userInteractionEnabled  =  NO;
		self.contentMode  =  UIViewContentModeRedraw;
		self.autoresizingMask  =  UIViewAutoresizingNone;
		self.backgroundColor  =  [UIColor clearColor];

		imageView  =  [[UIImageView alloc] initWithFrame:self.bounds];

		imageView.autoresizesSubviews  =  NO;
		imageView.userInteractionEnabled  =  NO;
		imageView.autoresizingMask  =  UIViewAutoresizingNone;
		imageView.contentMode  =  UIViewContentModeScaleAspectFit;

		[self addSubview:imageView];
	}

	return self;
}

- (void)showImage:(UIImage *)image
{
	imageView.image  =  image; // Show image
}

- (void)showTouched:(BOOL)touched
{
	// Implemented by ThumbView subclass
}

- (void)removeFromSuperview
{
	_targetTag  =  0; // Clear target tag

	[self.operation cancel]; // Cancel operation

	[super removeFromSuperview]; // Remove view
}

- (void)reuse
{
	_targetTag  =  0; // Clear target tag

	[self.operation cancel]; // Cancel operation

	imageView.image  =  nil; // Release image
}

@end
