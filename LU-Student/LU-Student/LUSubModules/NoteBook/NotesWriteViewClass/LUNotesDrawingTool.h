//
//  LUNotesDrawingTool.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//


#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define NOTES_HAS_ARC 1
#define NOTES_RETAIN(exp) (exp)
#define NOTES_RELEASE(exp)
#define NOTES_AUTORELEASE(exp) (exp)
#else
#define NOTES_HAS_ARC 0
#define NOTES_RETAIN(exp) [(exp) retain]
#define NOTES_RELEASE(exp) [(exp) release]
#define NOTES_AUTORELEASE(exp) [(exp) autorelease]
#endif


@protocol LUNotesDrawingTool <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end

#pragma mark -

@interface NOTESDrawingPenTool : UIBezierPath<LUNotesDrawingTool> {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end

#pragma mark -

@interface NOTESDrawingEraserTool : NOTESDrawingPenTool

@end

#pragma mark -

@interface NOTESDrawingLineTool : NSObject<LUNotesDrawingTool>

@end

#pragma mark -

@interface NOTESDrawingTextTool : NSObject<LUNotesDrawingTool>
@property (strong, nonatomic) NSAttributedString* attributedText;
@end

@interface NOTESDrawingMultilineTextTool : NOTESDrawingTextTool
@end

#pragma mark -

@interface NOTESDrawingRectangleTool : NSObject<LUNotesDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark -

@interface NOTESDrawingEllipseTool : NSObject<LUNotesDrawingTool>

@property (nonatomic, assign) BOOL fill;

@end
