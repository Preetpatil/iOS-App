//
//  LUNotesDrawingView.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import <UIKit/UIKit.h>

#define NOTESDrawingViewVersion   1.3.7

typedef enum {
    NOTESDrawingToolTypePen,
    NOTESDrawingToolTypeLine,
    NOTESDrawingToolTypeRectagleStroke,
    NOTESDrawingToolTypeRectagleFill,
    NOTESDrawingToolTypeEllipseStroke,
    NOTESDrawingToolTypeEllipseFill,
    NOTESDrawingToolTypeEraser,
    NOTESDrawingToolTypeText,
    NOTESDrawingToolTypeMultilineText,
    NOTESDrawingToolTypeCustom,
} NOTESDrawingToolType;

typedef NS_ENUM(NSUInteger, NOTESDrawingMode)
{
    NOTESDrawingModeScale,
    NOTESDrawingModeOriginalSize
};

@protocol NOTESDrawingViewDelegate, LUNotesDrawingTool;

@interface LUNotesDrawingView : UIView<UITextViewDelegate>

@property (nonatomic, assign) NOTESDrawingToolType drawTool;
@property (nonatomic, strong) id<LUNotesDrawingTool> customDrawTool;
@property (nonatomic, assign) id<NOTESDrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, retain) NSString *fontStyle;
//@property BOOL FillActive;

@property (nonatomic, assign) CGFloat imageY;
@property (nonatomic, assign) CGFloat distance;


@property (nonatomic, strong) UITextView *textView;////
@property (nonatomic,retain) NSMutableArray *trial;///
@property (retain,nonatomic) NSString *tts1;///


@property (nonatomic, assign) NOTESDrawingMode drawMode;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, readonly) NSUInteger undoSteps;
@property (nonatomic, strong) UIImage *imageToStamp;




// load external image
- (void) loadImage: (UIImage *) image;
- (void) loadImageData: (NSData *) imageData;

// erase all
- (void) clear;

// undo / redo
- (BOOL) canUndo;
- (void) undoLatestStep;

- (BOOL) canRedo;
- (void) redoLatestStep;

/**
 @discussion Discards the tool stack and renders them to prev_image, making the current state the 'start' state.
 (Can be called before resize to make content more predictable)
 */
- (void) commitAndDiscardToolStack;

@end

#pragma mark -

@interface LUNotesDrawingView (Deprecated)
@property (nonatomic, strong) UIImage *prev_image DEPRECATED_MSG_ATTRIBUTE("Use 'backgroundImage' instead.");
@end

#pragma mark -

@protocol NOTESDrawingViewDelegate <NSObject>

@optional
- (void) drawingView: (LUNotesDrawingView *)view willBeginDrawUsingTool: (id<LUNotesDrawingTool>) tool;
- (void) drawingView: (LUNotesDrawingView *)view didEndDrawUsingTool: (id<LUNotesDrawingTool>) tool;

@end
