//
// DrawingTools.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//



#import "DrawingTools.h"
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#import <CoreText/CoreText.h>
#else
#import <AppKit/AppKit.h>
#endif

CGPoint midPointt(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - DrawingPenTool

@implementation DrawingPenTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;

- (id)init
{
    self  =  [super init];
    if (self !=  nil) {
        self.lineCapStyle  =  kCGLineCapRound;
        path  =  CGPathCreateMutable();
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    //[self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    //[self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint {
    
    CGPoint mid1  =  midPointt(p1Point, p2Point);
    CGPoint mid2  =  midPointt(cpoint, p1Point);
    CGMutablePathRef subpath  =  CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, p1Point.x, p1Point.y, mid2.x, mid2.y);
    CGRect bounds  =  CGPathGetBoundingBox(subpath);
    
    CGPathAddPath(path, NULL, subpath);
    CGPathRelease(subpath);
    
    return bounds;
}

- (void)draw
{
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    
	CGContextAddPath(context, path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokePath(context);
}

- (void)dealloc
{
    CGPathRelease(path);
    self.lineColor  =  nil;
    #if !_HAS_ARC
    [super dealloc];
    #endif
}

@end


#pragma mark - DrawingEraserTool

@implementation DrawingEraserTool

- (void)draw
{
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

	CGContextAddPath(context, path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end


#pragma mark - DrawingLineTool

@interface DrawingLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation DrawingLineTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;
@synthesize lineWidth  =  _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint  =  firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint  =  endPoint;
}

- (void)draw
{
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
}

- (void)dealloc
{
    self.lineColor  =  nil;
#if !_HAS_ARC
    [super dealloc];
#endif
}

@end

#pragma mark - DrawingTextTool

@interface DrawingTextTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation DrawingTextTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;
@synthesize lineWidth  =  _lineWidth;
@synthesize attributedText  =  _attributedText;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint  =  firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint  =  endPoint;
}

- (void)draw
{
    
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the text
    CGRect viewBounds  =  CGRectMake(MIN(self.firstPoint.x, self.lastPoint.x),
                                   MIN(self.firstPoint.y, self.lastPoint.y),
                                   fabs(self.firstPoint.x - self.lastPoint.x),
                                   fabs(self.firstPoint.y - self.lastPoint.y)
                                   );
    
    // Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, 0, viewBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create a path which bounds the area where you will be drawing text.
    // The path need not be rectangular.
    CGMutablePathRef path  =  CGPathCreateMutable();
    
    // In this simple example, initialize a rectangular path.
    CGRect bounds  =  CGRectMake(viewBounds.origin.x, -viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    CGPathAddRect(path, NULL, bounds );
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter  =  CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    // Create a frame.
    CTFrameRef frame  =  CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // Draw the specified frame in the given context.
    CTFrameDraw(frame, context);
    
    // Release the objects we used.
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
    CGContextRestoreGState(context);
}

- (void)dealloc
{
    self.lineColor  =  nil;
    self.attributedText  =  nil;
#if !_HAS_ARC
    [super dealloc];
#endif
}

@end


#pragma mark - DrawingRectangleTool

@interface DrawingRectangleTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation DrawingRectangleTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;
@synthesize lineWidth  =  _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint  =  firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint  =  endPoint;
}

- (void)draw
{
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the rectangle
    CGRect rectToFill  =  CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

- (void)dealloc
{
    self.lineColor  =  nil;
#if !_HAS_ARC
    [super dealloc];
#endif
}

@end


#pragma mark - DrawingEllipseTool

@interface DrawingEllipseTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation DrawingEllipseTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;
@synthesize lineWidth  =  _lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint  =  firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint  =  endPoint;
}

- (void)draw
{
    CGContextRef context  =  UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the ellipse
    CGRect rectToFill  =  CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

- (void)dealloc
{
    self.lineColor  =  nil;
#if !_HAS_ARC
    [super dealloc];
#endif
}

@end
