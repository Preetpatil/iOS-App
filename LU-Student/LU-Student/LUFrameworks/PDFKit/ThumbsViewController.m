//
//	ThumbsViewController.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "Constants.h"
#import "ThumbsViewController.h"
#import "ThumbRequest.h"
#import "ThumbCache.h"
#import "Document.h"

#import <QuartzCore/QuartzCore.h>

@interface ThumbsViewController () <ThumbsMainToolbarDelegate, ThumbsViewDelegate>

@end

@implementation ThumbsViewController
{
	Document *document;

	ThumbsMainToolbar *mainToolbar;

	ThumbsView *theThumbsView;

	NSMutableArray *bookmarked;

	CGPoint thumbsOffset;
	CGPoint markedOffset;

	BOOL updateBookmarked;
	BOOL showBookmarked;
}

#pragma mark - Constants

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f

#define PAGE_THUMB_SMALL 160
#define PAGE_THUMB_LARGE 256

#pragma mark - Properties

@synthesize delegate;

#pragma mark - UIViewController methods

- (instancetype)initWithDocument:(Document *)object
{
	if ((self  =  [super initWithNibName:nil bundle:nil])) // Initialize superclass
	{
		if ((object !=  nil) && ([object isKindOfClass:[Document class]])) // Valid object
		{
			updateBookmarked  =  YES; bookmarked  =  [NSMutableArray new]; // Bookmarked pages

			document  =  object; // Retain the Document object for our use
		}
		else // Invalid Document object
		{
			self  =  nil;
		}
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	assert(delegate !=  nil); assert(document !=  nil);

	self.view.backgroundColor  =  [UIColor grayColor]; // Neutral gray

	CGRect scrollViewRect  =  self.view.bounds; UIView *fakeStatusBar  =  nil;

	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
	{
		if ([self prefersStatusBarHidden]  ==  NO) // Visible status bar
		{
			CGRect statusBarRect  =  self.view.bounds; // Status bar frame
			statusBarRect.size.height  =  STATUS_HEIGHT; // Default status height
			fakeStatusBar  =  [[UIView alloc] initWithFrame:statusBarRect]; // UIView
			fakeStatusBar.autoresizingMask  =  UIViewAutoresizingFlexibleWidth;
			fakeStatusBar.backgroundColor  =  [UIColor blackColor];
			fakeStatusBar.contentMode  =  UIViewContentModeRedraw;
			fakeStatusBar.userInteractionEnabled  =  NO;

			scrollViewRect.origin.y +=  STATUS_HEIGHT; scrollViewRect.size.height -=  STATUS_HEIGHT;
		}
	}

	NSString *toolbarTitle  =  [document.fileName stringByDeletingPathExtension];

	CGRect toolbarRect  =  scrollViewRect; // Toolbar frame
	toolbarRect.size.height  =  TOOLBAR_HEIGHT; // Default toolbar height
	mainToolbar  =  [[ThumbsMainToolbar alloc] initWithFrame:toolbarRect title:toolbarTitle]; // ThumbsMainToolbar
	mainToolbar.delegate  =  self; // ThumbsMainToolbarDelegate
	[self.view addSubview:mainToolbar];

	if (fakeStatusBar !=  nil) [self.view addSubview:fakeStatusBar]; // Add status bar background view

	UIEdgeInsets scrollViewInsets  =  UIEdgeInsetsZero; // Scroll view toolbar insets

	if ([UIDevice currentDevice].userInterfaceIdiom  ==  UIUserInterfaceIdiomPad) // iPad
	{
		scrollViewRect.origin.y +=  TOOLBAR_HEIGHT; scrollViewRect.size.height -=  TOOLBAR_HEIGHT;
	}
	else // Set UIScrollView insets for non-UIUserInterfaceIdiomPad case
	{
		scrollViewInsets.top  =  TOOLBAR_HEIGHT;
	}

	theThumbsView  =  [[ThumbsView alloc] initWithFrame:scrollViewRect]; // ThumbsView
	theThumbsView.contentInset  =  scrollViewInsets; theThumbsView.scrollIndicatorInsets  =  scrollViewInsets;
	theThumbsView.delegate  =  self; // ThumbsViewDelegate
	[self.view insertSubview:theThumbsView belowSubview:mainToolbar];

	if ([UIDevice currentDevice].userInterfaceIdiom  ==  UIUserInterfaceIdiomPhone)
	{
		CGRect viewRect  =  self.view.bounds; CGSize viewSize  =  viewRect.size; // View size

		CGFloat min  =  ((viewSize.width < viewSize.height) ? viewSize.width : viewSize.height);

		CGFloat thumbSize  =  ((min > 320.0f) ? floorf(min / 3.0f) : PAGE_THUMB_SMALL);

		[theThumbsView setThumbSize:CGSizeMake(thumbSize, thumbSize)];
	}
	else // Set thumb size for large (iPad) devices
	{
		[theThumbsView setThumbSize:CGSizeMake(PAGE_THUMB_LARGE, PAGE_THUMB_LARGE)];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[theThumbsView reloadThumbsCenterOnIndex:([document.pageNumber integerValue] - 1)]; // Page
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	mainToolbar  =  nil; theThumbsView  =  nil;

	[super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//if (fromInterfaceOrientation  ==  self.interfaceOrientation) return;
}
*/

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super didReceiveMemoryWarning];
}

#pragma mark - ThumbsMainToolbarDelegate methods

- (void)tappedInToolbar:(ThumbsMainToolbar *)toolbar showControl:(UISegmentedControl *)control
{
	switch (control.selectedSegmentIndex)
	{
		case 0: // Show all page thumbs
		{
			showBookmarked  =  NO; // Show all thumbs

			markedOffset  =  [theThumbsView insetContentOffset];

			[theThumbsView reloadThumbsContentOffset:thumbsOffset];

			break; // We're done
		}

		case 1: // Show bookmarked thumbs
		{
			showBookmarked  =  YES; // Only bookmarked

			thumbsOffset  =  [theThumbsView insetContentOffset];

			if (updateBookmarked  ==  YES) // Update bookmarked list
			{
				[bookmarked removeAllObjects]; // Empty the list first

				[document.bookmarks enumerateIndexesUsingBlock: // Enumerate
					^(NSUInteger page, BOOL *stop)
					{
						[bookmarked addObject:[NSNumber numberWithInteger:page]];
					}
				];

				markedOffset  =  CGPointZero; updateBookmarked  =  NO; // Reset
			}

			[theThumbsView reloadThumbsContentOffset:markedOffset];

			break; // We're done
		}
	}
}

- (void)tappedInToolbar:(ThumbsMainToolbar *)toolbar doneButton:(UIButton *)button
{
	[delegate dismissThumbsViewController:self]; // Dismiss thumbs display
}

#pragma mark - UIThumbsViewDelegate methods

- (NSUInteger)numberOfThumbsInThumbsView:(ThumbsView *)thumbsView
{
	return (showBookmarked ? bookmarked.count : [document.pageCount integerValue]);
}

- (id)thumbsView:(ThumbsView *)thumbsView thumbCellWithFrame:(CGRect)frame
{
	return [[ThumbsPageThumb alloc] initWithFrame:frame];
}

- (void)thumbsView:(ThumbsView *)thumbsView updateThumbCell:(ThumbsPageThumb *)thumbCell forIndex:(NSInteger)index
{
	CGSize size  =  [thumbCell maximumContentSize]; // Get the cell's maximum content size

	NSInteger page  =  (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));

	[thumbCell showText:[[NSString alloc] initWithFormat:@"%i", (int)page]]; // Page number place holder

	[thumbCell showBookmark:[document.bookmarks containsIndex:page]]; // Show bookmarked status

	NSURL *fileURL  =  document.fileURL; NSString *guid  =  document.guid; NSString *phrase  =  document.password; // Document info

	ThumbRequest *thumbRequest  =  [ThumbRequest newForView:thumbCell fileURL:fileURL password:phrase guid:guid page:page size:size];

	UIImage *image  =  [[ThumbCache sharedInstance] thumbRequest:thumbRequest priority:YES]; // Request the thumbnail

	if ([image isKindOfClass:[UIImage class]]) [thumbCell showImage:image]; // Show image from cache
}

- (void)thumbsView:(ThumbsView *)thumbsView refreshThumbCell:(ThumbsPageThumb *)thumbCell forIndex:(NSInteger)index
{
	NSInteger page  =  (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));

	[thumbCell showBookmark:[document.bookmarks containsIndex:page]]; // Show bookmarked status
}

- (void)thumbsView:(ThumbsView *)thumbsView didSelectThumbWithIndex:(NSInteger)index
{
	NSInteger page  =  (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));

	[delegate thumbsViewController:self gotoPage:page]; // Show the selected page

	[delegate dismissThumbsViewController:self]; // Dismiss thumbs display
}

- (void)thumbsView:(ThumbsView *)thumbsView didPressThumbWithIndex:(NSInteger)index
{
	NSInteger page  =  (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));

	if ([document.bookmarks containsIndex:page]) [document.bookmarks removeIndex:page]; else [document.bookmarks addIndex:page];

	updateBookmarked  =  YES; [thumbsView refreshThumbWithIndex:index]; // Refresh page thumb
}

@end

#pragma mark -

//
//	ThumbsPageThumb class implementation
//

@implementation ThumbsPageThumb
{
	UIView *backView;

	UIView *tintView;

	UILabel *textLabel;

	UIImageView *bookMark;

	CGSize maximumSize;

	CGRect defaultRect;
}

#pragma mark - Constants

#define CONTENT_INSET 8.0f

#pragma mark - ThumbsPageThumb instance methods

- (CGRect)markRectInImageView
{
	CGRect iconRect  =  bookMark.frame; iconRect.origin.y  =  (-2.0f);

	iconRect.origin.x  =  (imageView.bounds.size.width - bookMark.image.size.width - 8.0f);

	return iconRect; // Frame position rect inside of image view
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self  =  [super initWithFrame:frame]))
	{
		imageView.contentMode  =  UIViewContentModeCenter;

		defaultRect  =  CGRectInset(self.bounds, CONTENT_INSET, CONTENT_INSET);

		maximumSize  =  defaultRect.size; // Maximum thumb content size

		CGFloat newWidth  =  ((defaultRect.size.width / 4.0f) * 3.0f);

		CGFloat offsetX  =  ((defaultRect.size.width - newWidth) * 0.5f);

		defaultRect.size.width  =  newWidth; defaultRect.origin.x +=  offsetX;

		imageView.frame  =  defaultRect; // Update the image view frame

		CGFloat fontSize  =  (([UIDevice currentDevice].userInterfaceIdiom  ==  UIUserInterfaceIdiomPad) ? 19.0f : 16.0f);

		textLabel  =  [[UILabel alloc] initWithFrame:defaultRect];

		textLabel.autoresizesSubviews  =  NO;
		textLabel.userInteractionEnabled  =  NO;
		textLabel.contentMode  =  UIViewContentModeRedraw;
		textLabel.autoresizingMask  =  UIViewAutoresizingNone;
		textLabel.textAlignment  =  NSTextAlignmentCenter;
		textLabel.font  =  [UIFont systemFontOfSize:fontSize];
		textLabel.textColor  =  [UIColor colorWithWhite:0.24f alpha:1.0f];
		textLabel.backgroundColor  =  [UIColor whiteColor];

		[self insertSubview:textLabel belowSubview:imageView];

		backView  =  [[UIView alloc] initWithFrame:defaultRect];

		backView.autoresizesSubviews  =  NO;
		backView.userInteractionEnabled  =  NO;
		backView.contentMode  =  UIViewContentModeRedraw;
		backView.autoresizingMask  =  UIViewAutoresizingNone;
		backView.backgroundColor  =  [UIColor whiteColor];

#if (_SHOW_SHADOWS  ==  TRUE) // Option

		backView.layer.shadowOffset  =  CGSizeMake(0.0f, 1.0f);
		backView.layer.shadowRadius  =  3.0f; backView.layer.shadowOpacity  =  1.0f;
		backView.layer.shadowPath  =  [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of _SHOW_SHADOWS Option

		[self insertSubview:backView belowSubview:textLabel];

		tintView  =  [[UIView alloc] initWithFrame:imageView.bounds];

		tintView.hidden  =  YES;
		tintView.autoresizesSubviews  =  NO;
		tintView.userInteractionEnabled  =  NO;
		tintView.contentMode  =  UIViewContentModeRedraw;
		tintView.autoresizingMask  =  UIViewAutoresizingNone;
		tintView.backgroundColor  =  [UIColor colorWithWhite:0.0f alpha:0.25f];

		[imageView addSubview:tintView];

		UIImage *image  =  [UIImage imageNamed:@"-Mark-Y" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

		bookMark  =  [[UIImageView alloc] initWithImage:image];

		bookMark.hidden  =  YES;
		bookMark.autoresizesSubviews  =  NO;
		bookMark.userInteractionEnabled  =  NO;
		bookMark.contentMode  =  UIViewContentModeCenter;
		bookMark.autoresizingMask  =  UIViewAutoresizingNone;
		bookMark.frame  =  [self markRectInImageView];

		[imageView addSubview:bookMark];
	}

	return self;
}

- (CGSize)maximumContentSize
{
	return maximumSize;
}

- (void)showImage:(UIImage *)image
{
	NSInteger x  =  (self.bounds.size.width * 0.5f);
	NSInteger y  =  (self.bounds.size.height * 0.5f);

	CGPoint location  =  CGPointMake(x, y); // Center point

	CGRect viewRect  =  CGRectZero; viewRect.size  =  image.size;

	textLabel.bounds  =  viewRect; textLabel.center  =  location; // Position

	imageView.bounds  =  viewRect; imageView.center  =  location; imageView.image  =  image;

	bookMark.frame  =  [self markRectInImageView]; // Position bookmark image

	tintView.frame  =  imageView.bounds; backView.bounds  =  viewRect; backView.center  =  location;

#if (_SHOW_SHADOWS  ==  TRUE) // Option

	backView.layer.shadowPath  =  [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of _SHOW_SHADOWS Option
}

- (void)reuse
{
	[super reuse]; // Reuse thumb view

	textLabel.text  =  nil; textLabel.frame  =  defaultRect;

	imageView.image  =  nil; imageView.frame  =  defaultRect;

	bookMark.hidden  =  YES; bookMark.frame  =  [self markRectInImageView];

	tintView.hidden  =  YES; tintView.frame  =  imageView.bounds; backView.frame  =  defaultRect;

#if (_SHOW_SHADOWS  ==  TRUE) // Option

	backView.layer.shadowPath  =  [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of _SHOW_SHADOWS Option
}

- (void)showBookmark:(BOOL)show
{
	bookMark.hidden  =  (show ? NO : YES);
}

- (void)showTouched:(BOOL)touched
{
	tintView.hidden  =  (touched ? NO : YES);
}

- (void)showText:(NSString *)text
{
	textLabel.text  =  text;
}

@end
