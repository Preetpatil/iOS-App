//
//	MainToolbar.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "Constants.h"
#import "MainToolbar.h"
#import "Document.h"

#import <MessageUI/MessageUI.h>

@implementation MainToolbar
{
	UIButton *markButton;

	UIImage *markImageN;
	UIImage *markImageY;
}

#pragma mark - Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 19.0f
#define TITLE_HEIGHT 28.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - MainToolbar instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame document:nil];
}

- (instancetype)initWithFrame:(CGRect)frame document:(Document *)document
{
	assert(document !=  nil); // Must have a valid Document

	if ((self  =  [super initWithFrame:frame]))
	{
		CGFloat viewWidth  =  self.bounds.size.width; // Toolbar view width

#if (_FLAT_UI  ==  TRUE) // Option
		UIImage *buttonH  =  nil; UIImage *buttonN  =  nil;
#else
		UIImage *buttonH  =  [[UIImage imageNamed:@"-Button-H" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImage *buttonN  =  [[UIImage imageNamed:@"-Button-N" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
#endif // end of _FLAT_UI Option

		BOOL largeDevice  =  ([UIDevice currentDevice].userInterfaceIdiom  ==  UIUserInterfaceIdiomPad);

		const CGFloat buttonSpacing  =  BUTTON_SPACE; const CGFloat iconButtonWidth  =  ICON_BUTTON_WIDTH;

		CGFloat titleX  =  BUTTON_X; CGFloat titleWidth  =  (viewWidth - (titleX + titleX));

		CGFloat leftButtonX  =  BUTTON_X; // Left-side button start X position

#if (_STANDALONE  ==  FALSE) // Option

		UIFont *doneButtonFont  =  [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
		NSString *doneButtonText  =  NSLocalizedString(@"Done", @"button");
		CGSize doneButtonSize  =  [doneButtonText sizeWithFont:doneButtonFont];
		CGFloat doneButtonWidth  =  (doneButtonSize.width + TEXT_BUTTON_PADDING);

		UIButton *doneButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
		doneButton.frame  =  CGRectMake(leftButtonX, BUTTON_Y, doneButtonWidth, BUTTON_HEIGHT);
		[doneButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
		[doneButton setTitle:doneButtonText forState:UIControlStateNormal]; doneButton.titleLabel.font  =  doneButtonFont;
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		doneButton.autoresizingMask  =  UIViewAutoresizingNone;
		//doneButton.backgroundColor  =  [UIColor grayColor];
		doneButton.exclusiveTouch  =  YES;

		[self addSubview:doneButton]; leftButtonX +=  (doneButtonWidth + buttonSpacing);

		titleX +=  (doneButtonWidth + buttonSpacing); titleWidth -=  (doneButtonWidth + buttonSpacing);

#endif // end of _STANDALONE Option

#if (_ENABLE_THUMBS  ==  TRUE) // Option

		UIButton *thumbsButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
		thumbsButton.frame  =  CGRectMake(leftButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
		[thumbsButton setImage:[UIImage imageNamed:@"-Thumbs" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
		[thumbsButton addTarget:self action:@selector(thumbsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[thumbsButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[thumbsButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		thumbsButton.autoresizingMask  =  UIViewAutoresizingNone;
		//thumbsButton.backgroundColor  =  [UIColor grayColor];
		thumbsButton.exclusiveTouch  =  YES;

		[self addSubview:thumbsButton]; //leftButtonX +=  (iconButtonWidth + buttonSpacing);

		titleX +=  (iconButtonWidth + buttonSpacing); titleWidth -=  (iconButtonWidth + buttonSpacing);

#endif // end of _ENABLE_THUMBS Option

		CGFloat rightButtonX  =  viewWidth; // Right-side buttons start X position

#if (_BOOKMARKS  ==  TRUE) // Option

		rightButtonX -=  (iconButtonWidth + buttonSpacing); // Position

		UIButton *flagButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
		flagButton.frame  =  CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
		//[flagButton setImage:[UIImage imageNamed:@"-Mark-N"] forState:UIControlStateNormal];
		[flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
		[flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
		flagButton.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin;
		//flagButton.backgroundColor  =  [UIColor grayColor];
		flagButton.exclusiveTouch  =  YES;

		[self addSubview:flagButton]; titleWidth -=  (iconButtonWidth + buttonSpacing);

		markButton  =  flagButton; markButton.enabled  =  NO; markButton.tag  =  NSIntegerMin;

		markImageN  =  [UIImage imageNamed:@"-Mark-N" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]; // N image
		markImageY  =  [UIImage imageNamed:@"-Mark-Y" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]; // Y image

#endif // end of _BOOKMARKS Option

//		if (document.canEmail  ==  YES) // Document email enabled
//		{
//			if ([MFMailComposeViewController canSendMail]  ==  YES) // Can email
//			{
//				unsigned long long fileSize  =  [document.fileSize unsignedLongLongValue];
//
//				if (fileSize < 15728640ull) // Check attachment size limit (15MB)
//				{
//					rightButtonX -=  (iconButtonWidth + buttonSpacing); // Next position
//
//					UIButton *emailButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//					emailButton.frame  =  CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
//					[emailButton setImage:[UIImage imageNamed:@"-Email" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//					[emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//					[emailButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//					[emailButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//					emailButton.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin;
//					//emailButton.backgroundColor  =  [UIColor grayColor];
//					emailButton.exclusiveTouch  =  YES;
//
//					[self addSubview:emailButton]; titleWidth -=  (iconButtonWidth + buttonSpacing);
//				}
//			}
//		}

		if ((document.canPrint  ==  YES) && (document.password  ==  nil)) // Document print enabled
		{
			Class printInteractionController  =  NSClassFromString(@"UIPrintInteractionController");

			if ((printInteractionController !=  nil) && [printInteractionController isPrintingAvailable])
			{
				rightButtonX -=  (iconButtonWidth + buttonSpacing); // Next position

				UIButton *printButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
				printButton.frame  =  CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
				[printButton setImage:[UIImage imageNamed:@"-Print" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
				[printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
				[printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
				[printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
				printButton.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin;
				//printButton.backgroundColor  =  [UIColor grayColor];
				printButton.exclusiveTouch  =  YES;

				[self addSubview:printButton]; titleWidth -=  (iconButtonWidth + buttonSpacing);
			}
		}

//		if (document.canExport  ==  YES) // Document export enabled
//		{
//			rightButtonX -=  (iconButtonWidth + buttonSpacing); // Next position
//
//			UIButton *exportButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//			exportButton.frame  =  CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
//			[exportButton setImage:[UIImage imageNamed:@"-Export" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//			[exportButton addTarget:self action:@selector(exportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//			[exportButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//			[exportButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//			exportButton.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin;
//			//exportButton.backgroundColor  =  [UIColor grayColor];
//			exportButton.exclusiveTouch  =  YES;
//
//			[self addSubview:exportButton]; titleWidth -=  (iconButtonWidth + buttonSpacing);
//		}

		if (largeDevice  ==  YES) // Show document filename in toolbar
		{
			CGRect titleRect  =  CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);

			UILabel *titleLabel  =  [[UILabel alloc] initWithFrame:titleRect];

			titleLabel.textAlignment  =  NSTextAlignmentCenter;
			titleLabel.font  =  [UIFont systemFontOfSize:TITLE_FONT_SIZE];
			titleLabel.autoresizingMask  =  UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment  =  UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor  =  [UIColor colorWithWhite:0.0f alpha:1.0f];
			titleLabel.backgroundColor  =  [UIColor clearColor];
			titleLabel.adjustsFontSizeToFitWidth  =  YES;
			titleLabel.minimumScaleFactor  =  0.75f;
			titleLabel.text  =  [document.fileName stringByDeletingPathExtension];
#if (_FLAT_UI  ==  FALSE) // Option
			titleLabel.shadowColor  =  [UIColor colorWithWhite:0.75f alpha:1.0f];
			titleLabel.shadowOffset  =  CGSizeMake(0.0f, 1.0f);
#endif // end of _FLAT_UI Option

			[self addSubview:titleLabel]; 
		}
	}

	return self;
}

- (void)setBookmarkState:(BOOL)state
{
#if (_BOOKMARKS  ==  TRUE) // Option

	if (state !=  markButton.tag) // Only if different state
	{
		if (self.hidden  ==  NO) // Only if toolbar is visible
		{
			UIImage *image  =  (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag  =  state; // Update bookmarked state tag
	}

	if (markButton.enabled  ==  NO) markButton.enabled  =  YES;

#endif // end of _BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#if (_BOOKMARKS  ==  TRUE) // Option

	if (markButton.tag !=  NSIntegerMin) // Valid tag
	{
		BOOL state  =  markButton.tag; // Bookmarked state

		UIImage *image  =  (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled  ==  NO) markButton.enabled  =  YES;

#endif // end of _BOOKMARKS Option
}

- (void)hideToolbar
{
	if (self.hidden  ==  NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha  =  0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden  =  YES;
			}
		];
	}
}

- (void)showToolbar
{
	if (self.hidden  ==  YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden  =  NO;
				self.alpha  =  1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark - UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

- (void)thumbsButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self thumbsButton:button];
}

- (void)exportButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self exportButton:button];
}

- (void)printButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self printButton:button];
}

- (void)emailButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self emailButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self markButton:button];
}

@end
