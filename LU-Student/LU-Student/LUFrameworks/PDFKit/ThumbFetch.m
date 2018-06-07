//
//	ThumbFetch.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "ThumbFetch.h"
#import "ThumbRender.h"
#import "ThumbCache.h"
#import "ThumbView.h"

#import <ImageIO/ImageIO.h>

@implementation ThumbFetch
{
	ThumbRequest *request;
}

#pragma mark - ThumbFetch instance methods

- (instancetype)initWithRequest:(ThumbRequest *)options
{
	if ((self  =  [super initWithGUID:options.guid]))
	{
		request  =  options;
	}

	return self;
}

- (void)cancel
{
	[super cancel]; // Cancel the operation

	request.thumbView.operation  =  nil; // Break retain loop

	request.thumbView  =  nil; // Release target thumb view on cancel

	[[ThumbCache sharedInstance] removeNullForKey:request.cacheKey];
}

- (NSURL *)thumbFileURL
{
	NSString *cachePath  =  [ThumbCache thumbCachePathForGUID:request.guid]; // Thumb cache path

	NSString *fileName  =  [[NSString alloc] initWithFormat:@"%@.png", request.thumbName]; // Thumb file name

	return [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:fileName]]; // File URL
}

- (void)main
{
	CGImageRef imageRef  =  NULL; NSURL *thumbURL  =  [self thumbFileURL];

	CGImageSourceRef loadRef  =  CGImageSourceCreateWithURL((__bridge CFURLRef)thumbURL, NULL);

	if (loadRef !=  NULL) // Load the existing thumb image
	{
		imageRef  =  CGImageSourceCreateImageAtIndex(loadRef, 0, NULL); // Load it

		CFRelease(loadRef); // Release CGImageSource reference
	}
	else // Existing thumb image not found - so create and queue up a thumb render operation on the work queue
	{
		ThumbRender *thumbRender  =  [[ThumbRender alloc] initWithRequest:request]; // Create a thumb render operation

		[thumbRender setQueuePriority:self.queuePriority]; [thumbRender setThreadPriority:(self.threadPriority - 0.1)]; // Priority

		if (self.isCancelled  ==  NO) // We're not cancelled - so update things and add the render operation to the work queue
		{
			request.thumbView.operation  =  thumbRender; // Update the thumb view operation property to the new operation

			[[ThumbQueue sharedInstance] addWorkOperation:thumbRender]; return; // Queue the operation
		}
	}

	if (imageRef !=  NULL) // Create a UIImage from a CGImage and show it
	{
		UIImage *image  =  [UIImage imageWithCGImage:imageRef scale:request.scale orientation:UIImageOrientationUp];

		CGImageRelease(imageRef); // Release the CGImage reference from the above thumb load code

		UIGraphicsBeginImageContextWithOptions(image.size, YES, request.scale); // Graphics context

		[image drawAtPoint:CGPointZero]; // Decode and draw the image on this background thread

		UIImage *decoded  =  UIGraphicsGetImageFromCurrentImageContext(); // Newly decoded image

		UIGraphicsEndImageContext(); // Cleanup after the bitmap-based graphics drawing context

		[[ThumbCache sharedInstance] setObject:decoded forKey:request.cacheKey]; // Cache it

		if (self.isCancelled  ==  NO) // Show the image in the target thumb view on the main thread
		{
			ThumbView *thumbView  =  request.thumbView; // Target thumb view for image show

			NSUInteger targetTag  =  request.targetTag; // Target reference tag for image show

			dispatch_async(dispatch_get_main_queue(), // Queue image show on main thread
			^{
				if (thumbView.targetTag  ==  targetTag) [thumbView showImage:decoded];
			});
		}
	}

	request.thumbView.operation  =  nil; // Break retain loop
}

@end
