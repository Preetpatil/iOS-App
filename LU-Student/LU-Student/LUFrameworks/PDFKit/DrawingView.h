//
// DrawingView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#define DrawingViewVersion   1.0.0

typedef enum {
    DrawingToolTypePen,
    DrawingToolTypeLine,
    DrawingToolTypeRectagleStroke,
    DrawingToolTypeRectagleFill,
    DrawingToolTypeEllipseStroke,
    DrawingToolTypeEllipseFill,
    DrawingToolTypeEraser,
    DrawingToolTypeText
} DrawingToolType;

@protocol DrawingViewDelegate, DrawingTool;

@interface DrawingView : UIView<UITextViewDelegate>

@property (nonatomic, assign) DrawingToolType drawTool;
@property (nonatomic, assign) id<DrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *prev_image;
@property (nonatomic, readonly) NSUInteger undoSteps;

// load external image
- (void)loadImage:(UIImage *)image;
- (void)loadImageData:(NSData *)imageData;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

@end

#pragma mark -

@protocol DrawingViewDelegate <NSObject>

@optional
- (void)drawingView:(DrawingView *)view willBeginDrawUsingTool:(id<DrawingTool>)tool;
- (void)drawingView:(DrawingView *)view didEndDrawUsingTool:(id<DrawingTool>)tool;

@end
