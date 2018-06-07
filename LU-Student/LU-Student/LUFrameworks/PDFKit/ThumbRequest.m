//
//	ThumbRequest.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "ThumbRequest.h"
#import "ThumbView.h"

@implementation ThumbRequest
{
	NSURL *_fileURL;

	NSString *_guid;

	NSString *_password;

	NSString *_cacheKey;

	NSString *_thumbName;

	ThumbView *_thumbView;

	NSUInteger _targetTag;

	NSInteger _thumbPage;

	CGSize _thumbSize;

	CGFloat _scale;
}

#pragma mark - Properties

@synthesize guid  =  _guid;
@synthesize fileURL  =  _fileURL;
@synthesize password  =  _password;
@synthesize thumbView  =  _thumbView;
@synthesize thumbPage  =  _thumbPage;
@synthesize thumbSize  =  _thumbSize;
@synthesize thumbName  =  _thumbName;
@synthesize targetTag  =  _targetTag;
@synthesize cacheKey  =  _cacheKey;
@synthesize scale  =  _scale;

#pragma mark - ThumbRequest class methods

+ (instancetype)newForView:(ThumbView *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size
{
	return [[ThumbRequest alloc] initForView:view fileURL:url password:phrase guid:guid page:page size:size];
}

#pragma mark - ThumbRequest instance methods

- (instancetype)initForView:(ThumbView *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size
{
	if ((self  =  [super init])) // Initialize object
	{
		NSInteger w  =  size.width; NSInteger h  =  size.height;

		_thumbView  =  view; _thumbPage  =  page; _thumbSize  =  size;

		_fileURL  =  [url copy]; _password  =  [phrase copy]; _guid  =  [guid copy];

		_thumbName  =  [[NSString alloc] initWithFormat:@"%07i-%04ix%04i", (int)page, (int)w, (int)h];

		_cacheKey  =  [[NSString alloc] initWithFormat:@"%@+%@", _thumbName, _guid];

		_targetTag  =  [_cacheKey hash]; _thumbView.targetTag  =  _targetTag;

		_scale  =  [[UIScreen mainScreen] scale]; // Thumb screen scale
	}

	return self;
}

@end
