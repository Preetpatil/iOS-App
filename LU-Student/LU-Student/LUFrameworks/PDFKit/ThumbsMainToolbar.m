//
//	ThumbsMainToolbar.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//


#import "Constants.h"
#import "ThumbsMainToolbar.h"

@implementation ThumbsMainToolbar

#pragma mark - Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define SHOW_CONTROL_WIDTH 78.0f
#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 19.0f
#define TITLE_HEIGHT 28.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ThumbsMainToolbar instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame title:nil];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
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

		const CGFloat buttonSpacing  =  BUTTON_SPACE; //const CGFloat iconButtonWidth  =  ICON_BUTTON_WIDTH;

		CGFloat titleX  =  BUTTON_X; CGFloat titleWidth  =  (viewWidth - (titleX + titleX));

		CGFloat leftButtonX  =  BUTTON_X; // Left-side button start X position

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

		[self addSubview:doneButton]; //leftButtonX +=  (doneButtonWidth + buttonSpacing);

		titleX +=  (doneButtonWidth + buttonSpacing); titleWidth -=  (doneButtonWidth + buttonSpacing);

#if (_BOOKMARKS  ==  TRUE) // Option

		CGFloat showControlX  =  (viewWidth - (SHOW_CONTROL_WIDTH + buttonSpacing));

		UIImage *thumbsImage  =  [UIImage imageNamed:@"-Thumbs" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
		UIImage *bookmarkImage  =  [UIImage imageNamed:@"-Mark-Y" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
		NSArray *buttonItems  =  [NSArray arrayWithObjects:thumbsImage, bookmarkImage, nil];

		BOOL useTint  =  [self respondsToSelector:@selector(tintColor)]; // iOS 7 and up

		UISegmentedControl *showControl  =  [[UISegmentedControl alloc] initWithItems:buttonItems];
		showControl.frame  =  CGRectMake(showControlX, BUTTON_Y, SHOW_CONTROL_WIDTH, BUTTON_HEIGHT);
		showControl.tintColor  =  (useTint ? [UIColor blackColor] : [UIColor colorWithWhite:0.8f alpha:1.0f]);
		showControl.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin;
		showControl.segmentedControlStyle  =  UISegmentedControlStyleBar;
		showControl.selectedSegmentIndex  =  0; // Default segment index
		//showControl.backgroundColor  =  [UIColor grayColor];
		showControl.exclusiveTouch  =  YES;

		[showControl addTarget:self action:@selector(showControlTapped:) forControlEvents:UIControlEventValueChanged];

		[self addSubview:showControl];

		titleWidth -=  (SHOW_CONTROL_WIDTH + buttonSpacing);

#endif // end of _BOOKMARKS Option

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
			titleLabel.text  =  title;
#if (_FLAT_UI  ==  FALSE) // Option
			titleLabel.shadowColor  =  [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.shadowOffset  =  CGSizeMake(0.0f, 1.0f);
#endif // end of _FLAT_UI Option

			[self addSubview:titleLabel];
		}
	}

	return self;
}

#pragma mark - UISegmentedControl action methods

- (void)showControlTapped:(UISegmentedControl *)control
{
	[delegate tappedInToolbar:self showControl:control];
}

#pragma mark - UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

@end
