//
//  LUNotesDrawingTool.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import "LUNotesDrawingTool.h"
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#import <CoreText/CoreText.h>
#else
#import <AppKit/AppKit.h>
#endif

CGPoint midPointN(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - NOTESDrawingPenTool

@implementation NOTESDrawingPenTool

@synthesize lineColor  =  _lineColor;
@synthesize lineAlpha  =  _lineAlpha;

- (id)init
{
    self  =  [super init];
    if (self !=  nil)
    {
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

/**
 <#Description#>

 @param p2Point <#p2Point description#>
 @param p1Point <#p1Point description#>
 @param cpoint <#cpoint description#>
 @return <#return value description#>
 */
- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint
{
    CGPoint mid1  =  midPointN(p1Point, p2Point);
    CGPoint mid2  =  midPointN(cpoint, p1Point);
    CGMutablePathRef subpath  =  CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, p1Point.x, p1Point.y, mid2.x, mid2.y);
    CGRect bounds  =  CGPathGetBoundingBox(subpath);
    
    CGPathAddPath(path, NULL, subpath);
    CGPathRelease(subpath);
    return bounds;
}


/**
 <#Description#>
 */
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
#if !NOTES_HAS_ARC
    [super dealloc];
#endif
}

@end


#pragma mark - NOTESDrawingEraserTool

@implementation NOTESDrawingEraserTool

/**
 <#Description#>
 */
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


#pragma mark - NOTESDrawingLineTool

@interface NOTESDrawingLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation NOTESDrawingLineTool

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
#if !NOTES_HAS_ARC
    [super dealloc];
#endif
}

@end

#pragma mark - NOTESDrawingTextTool

@interface NOTESDrawingTextTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation NOTESDrawingTextTool

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
//    CFRelease(frame);
//    CFRelease(framesetter);
//    CFRelease(path);
    CGContextRestoreGState(context);
}

- (void)dealloc
{
    self.lineColor  =  nil;
    self.attributedText  =  nil;
#if !NOTES_HAS_ARC
    [super dealloc];
#endif
}

@end


#pragma mark - NOTESDrawingMultilineTextTool

@implementation NOTESDrawingMultilineTextTool
@end

#pragma mark - NOTESDrawingRectangleTool

@interface NOTESDrawingRectangleTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation NOTESDrawingRectangleTool

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
    if (self.fill)
    {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

- (void)dealloc
{
    self.lineColor  =  nil;
#if !NOTES_HAS_ARC
    [super dealloc];
#endif
}

@end


#pragma mark - NOTESDrawingEllipseTool

@interface NOTESDrawingEllipseTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation NOTESDrawingEllipseTool

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
    if (self.fill)
    {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

- (void)dealloc
{
    self.lineColor  =  nil;
#if !NOTES_HAS_ARC
    [super dealloc];
#endif
}

@end
