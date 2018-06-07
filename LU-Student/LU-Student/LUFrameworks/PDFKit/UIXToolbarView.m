//
//	UIXToolbarView.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//



#import "Constants.h"
#import "UIXToolbarView.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIXToolbarView

#pragma mark - Constants

#define SHADOW_HEIGHT 4.0f

#pragma mark - UIXToolbarView class methods

+ (Class)layerClass
{
#if (_FLAT_UI  ==  FALSE) // Option
	return [CAGradientLayer class];
#else
	return [CALayer class];
#endif // end of _FLAT_UI Option
}

#pragma mark - UIXToolbarView instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self  =  [super initWithFrame:frame]))
	{
		self.autoresizesSubviews  =  YES;
		self.userInteractionEnabled  =  YES;
		self.contentMode  =  UIViewContentModeRedraw;
		self.autoresizingMask  =  UIViewAutoresizingFlexibleWidth;

		if ([self.layer isKindOfClass:[CAGradientLayer class]])
		{
			self.backgroundColor  =  [UIColor clearColor];

			CAGradientLayer *layer  =  (CAGradientLayer *)self.layer;
			UIColor *liteColor  =  [UIColor colorWithWhite:0.92f alpha:0.8f];
			UIColor *darkColor  =  [UIColor colorWithWhite:0.32f alpha:0.8f];
			layer.colors  =  [NSArray arrayWithObjects:(id)liteColor.CGColor, (id)darkColor.CGColor, nil];

			CGRect shadowRect  =  self.bounds; shadowRect.origin.y +=  shadowRect.size.height; shadowRect.size.height  =  SHADOW_HEIGHT;

			UIXToolbarShadow *shadowView  =  [[UIXToolbarShadow alloc] initWithFrame:shadowRect];

			[self addSubview:shadowView]; // Add shadow to toolbar
		}
		else // Follow The Fuglyosity of Flat Fad
		{
			self.backgroundColor  =  [UIColor colorWithWhite:0.94f alpha:0.94f];

			CGRect lineRect  =  self.bounds; lineRect.origin.y +=  lineRect.size.height; lineRect.size.height  =  1.0f;

			UIView *lineView  =  [[UIView alloc] initWithFrame:lineRect];
			lineView.autoresizesSubviews  =  NO;
			lineView.userInteractionEnabled  =  NO;
			lineView.contentMode  =  UIViewContentModeRedraw;
			lineView.autoresizingMask  =  UIViewAutoresizingFlexibleWidth;
			lineView.backgroundColor  =  [UIColor colorWithWhite:0.64f alpha:0.94f];
			[self addSubview:lineView];
		}
	}

	return self;
}

@end

#pragma mark -

//
//	UIXToolbarShadow class implementation
//

@implementation UIXToolbarShadow

#pragma mark - UIXToolbarShadow class methods

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

#pragma mark - UIXToolbarShadow instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self  =  [super initWithFrame:frame]))
	{
		self.autoresizesSubviews  =  NO;
		self.userInteractionEnabled  =  NO;
		self.contentMode  =  UIViewContentModeRedraw;
		self.autoresizingMask  =  UIViewAutoresizingFlexibleWidth;
		self.backgroundColor  =  [UIColor clearColor];

		CAGradientLayer *layer  =  (CAGradientLayer *)self.layer;
		UIColor *blackColor  =  [UIColor colorWithWhite:0.24f alpha:1.0f];
		UIColor *clearColor  =  [UIColor colorWithWhite:0.24f alpha:0.0f];
		layer.colors  =  [NSArray arrayWithObjects:(id)blackColor.CGColor, (id)clearColor.CGColor, nil];
	}

	return self;
}

@end
