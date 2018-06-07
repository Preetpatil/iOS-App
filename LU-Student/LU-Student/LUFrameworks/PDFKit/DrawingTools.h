//
// DrawingTools.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define _HAS_ARC 1
#define _RETAIN(exp) (exp)
#define _RELEASE(exp)
#define _AUTORELEASE(exp) (exp)
#else
#define _HAS_ARC 0
#define _RETAIN(exp) [(exp) retain]
#define _RELEASE(exp) [(exp) release]
#define _AUTORELEASE(exp) [(exp) autorelease]
#endif


@protocol DrawingTool <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end

#pragma mark -

@interface DrawingPenTool : UIBezierPath<DrawingTool> {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end

#pragma mark -

@interface DrawingEraserTool : DrawingPenTool

@end

#pragma mark -

@interface DrawingLineTool : NSObject<DrawingTool>

@end

#pragma mark -

@interface DrawingTextTool : NSObject<DrawingTool>
@property (strong, nonatomic) NSAttributedString* attributedText;
@end

#pragma mark -

@interface DrawingRectangleTool : NSObject<DrawingTool>

@property (nonatomic, assign) BOOL fill;

@end

#pragma mark -

@interface DrawingEllipseTool : NSObject<DrawingTool>

@property (nonatomic, assign) BOOL fill;

@end
