 //
 // DrawingView.m
 //
 //
 //  Created by Abhishek P Mukundan on 20/09/16.
 //  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.


#import "DrawingView.h"
#import "DrawingTools.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0

@interface DrawingView () {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
}

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<DrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat originalFrameYPos;
@end

#pragma mark -

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame
{
    self  =  [super initWithFrame:frame];
    if (self)
    {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self  =  [super initWithCoder:aDecoder];
    if (self)
    {
        [self configure];
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    self.pathArray  =  [NSMutableArray array];
    self.bufferArray  =  [NSMutableArray array];
    
    // set the default values for the public properties
    self.lineColor  =  kDefaultLineColor;
    self.lineWidth  =  kDefaultLineWidth;
    self.lineAlpha  =  kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor  =  [UIColor clearColor];
    
    self.originalFrameYPos  =  self.frame.origin.y;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
#endif
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw)
    {
        // erase the previous image
        self.image  =  nil;
        
        // load previous image (if returning to screen)
        [[self.prev_image copy] drawInRect:self.bounds];
        
        // I need to redraw all the lines
        for (id<DrawingTool> tool in self.pathArray)
        {
            [tool draw];
        }
        
    }
    else
    {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image  =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)finishDrawing
{
    // update the image
    [self updateCacheImage:NO];
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)])
    {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
    }
    
    // clear the current tool
    self.currentTool  =  nil;
}


- (id<DrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool)
    {
        case DrawingToolTypePen:
        {
            return _AUTORELEASE([DrawingPenTool new]);
        }
            
        case DrawingToolTypeLine:
        {
            return _AUTORELEASE([DrawingLineTool new]);
        }
            
        case DrawingToolTypeText:
        {
            return _AUTORELEASE([DrawingTextTool new]);
        }
            
        case DrawingToolTypeRectagleStroke:
        {
            DrawingRectangleTool *tool  =  _AUTORELEASE([DrawingRectangleTool new]);
            tool.fill  =  NO;
            return tool;
        }
            
        case DrawingToolTypeRectagleFill:
        {
            DrawingRectangleTool *tool  =  _AUTORELEASE([DrawingRectangleTool new]);
            tool.fill  =  YES;
            return tool;
        }
            
        case DrawingToolTypeEllipseStroke:
        {
            DrawingEllipseTool *tool  =  _AUTORELEASE([DrawingEllipseTool new]);
            tool.fill  =  NO;
            return tool;
        }
            
        case DrawingToolTypeEllipseFill:
        {
            DrawingEllipseTool *tool  =  _AUTORELEASE([DrawingEllipseTool new]);
            tool.fill  =  YES;
            return tool;
        }
            
        case DrawingToolTypeEraser:
        {
            return _AUTORELEASE([DrawingEraserTool new]);
        }
    }
}


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.textView && !self.textView.hidden)
    {
        [self commitAndHideTextEntry];
        return;
    }
    
    // add the first touch
    UITouch *touch  =  [touches anyObject];
    previousPoint1  =  [touch previousLocationInView:self];
    currentPoint  =  [touch locationInView:self];
    
    // init the bezier path
    self.currentTool  =  [self toolWithCurrentSettings];
    self.currentTool.lineWidth  =  self.lineWidth;
    self.currentTool.lineColor  =  self.lineColor;
    self.currentTool.lineAlpha  =  self.lineAlpha;
    
    if ([self.currentTool isKindOfClass:[DrawingTextTool class]])
    {
        [self initializeTextBox: currentPoint];
    }
    else
    {
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:currentPoint];
    }
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)])
    {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch  =  [touches anyObject];
    
    previousPoint2  =  previousPoint1;
    previousPoint1  =  [touch previousLocationInView:self];
    currentPoint  =  [touch locationInView:self];
    
    if ([self.currentTool isKindOfClass:[DrawingPenTool class]]) {
        CGRect bounds  =  [(DrawingPenTool*)self.currentTool addPathPreviousPreviousPoint:previousPoint2 withPreviousPoint:previousPoint1 withCurrentPoint:currentPoint];
        
        CGRect drawBox  =  bounds;
        drawBox.origin.x -=  self.lineWidth * 2.0;
        drawBox.origin.y -=  self.lineWidth * 2.0;
        drawBox.size.width +=  self.lineWidth * 4.0;
        drawBox.size.height +=  self.lineWidth * 4.0;
        
        [self setNeedsDisplayInRect:drawBox];
    }
    else if ([self.currentTool isKindOfClass:[DrawingTextTool class]])
    {
        [self resizeTextViewFrame: currentPoint];
    }
    else
    {
        [self.currentTool moveFromPoint:previousPoint1 toPoint:currentPoint];
        [self setNeedsDisplay];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    if ([self.currentTool isKindOfClass:[DrawingTextTool class]])
    {
        [self startTextEntry];
    }
    else
    {
        [self finishDrawing];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Text Entry

- (void) initializeTextBox: (CGPoint)startingPoint
{
    
    if (!self.textView)
    {
        self.textView  =  [[UITextView alloc] init];
        self.textView.delegate  =  self;
        self.textView.returnKeyType  =  UIReturnKeyDone;
        self.textView.autocorrectionType  =  UITextAutocorrectionTypeNo;
        self.textView.backgroundColor  =  [UIColor clearColor];
        self.textView.layer.borderWidth  =  1.0f;
        self.textView.layer.borderColor  =  [[UIColor grayColor] CGColor];
        self.textView.layer.cornerRadius  =  8;
        [self.textView setContentInset: UIEdgeInsetsZero];

        [self addSubview:self.textView];
    }
    
    int calculatedFontSize  =  self.lineWidth * 3; //3 is an approximate size factor
    
    [self.textView setFont:[UIFont systemFontOfSize:calculatedFontSize]];
    self.textView.textColor  =  self.lineColor;
    self.textView.alpha  =  self.lineAlpha;
    
    int defaultWidth  =  200;
    int defaultHeight  =  calculatedFontSize * 2;
    int initialYPosition  =  startingPoint.y - (defaultHeight/2);
    
    CGRect frame  =  CGRectMake(startingPoint.x, initialYPosition, defaultWidth, defaultHeight);
    frame  =  [self adjustFrameToFitWithinDrawingBounds:frame];
    
    self.textView.frame  =  frame;
    self.textView.text  =  @"";
    self.textView.hidden  =  NO;
}

- (void) startTextEntry
{
    if (!self.textView.hidden)
    {
        [self.textView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replmentText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGRect frame  =  self.textView.frame;
    if (self.textView.contentSize.height > frame.size.height)
    {
        frame.size.height  =  self.textView.contentSize.height;
    }
    
    self.textView.frame  =  frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self commitAndHideTextEntry];
}

-(void)resizeTextViewFrame: (CGPoint)adjustedSize
{
    
    int minimumAllowedHeight  =  self.textView.font.pointSize * 2;
    int minimumAllowedWidth  =  self.textView.font.pointSize * 0.5;
    
    CGRect frame  =  self.textView.frame;
    
    //adjust height
    int adjustedHeight  =  adjustedSize.y - self.textView.frame.origin.y;
    if (adjustedHeight > minimumAllowedHeight)
    {
        frame.size.height  =  adjustedHeight;
    }
    
    //adjust width
    int adjustedWidth  =  adjustedSize.x - self.textView.frame.origin.x;
    if (adjustedWidth > minimumAllowedWidth)
    {
        frame.size.width  =  adjustedWidth;
    }
    frame  =  [self adjustFrameToFitWithinDrawingBounds:frame];
    
    self.textView.frame  =  frame;
}

- (CGRect)adjustFrameToFitWithinDrawingBounds: (CGRect)frame
{
    
    //check that the frame does not go beyond bounds of parent view
    if ((frame.origin.x + frame.size.width) > self.frame.size.width)
    {
        frame.size.width  =  self.frame.size.width - frame.origin.x;
    }
    if ((frame.origin.y + frame.size.height) > self.frame.size.height)
    {
        frame.size.height  =  self.frame.size.height - frame.origin.y;
    }
    return frame;
}

- (void)commitAndHideTextEntry
{
    [self.textView resignFirstResponder];
    
    if ([self.textView.text length]) {
        UIEdgeInsets textInset  =  self.textView.textContainerInset;
        CGFloat additionalXPadding  =  5;
        CGPoint start  =  CGPointMake(self.textView.frame.origin.x + textInset.left + additionalXPadding, self.textView.frame.origin.y + textInset.top);
        CGPoint end  =  CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width - additionalXPadding, self.textView.frame.origin.y + self.textView.frame.size.height);
        
        ((DrawingTextTool*)self.currentTool).attributedText  =  [self.textView.attributedText copy];
        
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:start]; //change this for precision accuracy of text location
        [self.currentTool moveFromPoint:start toPoint:end];
        [self setNeedsDisplay];
        
        [self finishDrawing];
    }
    
    self.currentTool  =  nil;
    self.textView.hidden  =  YES;
    self.textView  =  nil;
}

#pragma mark - Keyboard Events

- (void)keyboardDidShow:(NSNotification *)notification
{
    if(UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        [self landscapeChanges:notification];
    }
    else
    {
        [self portraitChanges:notification];
    }
}

- (void)landscapeChanges:(NSNotification *)notification
{
    CGPoint textViewBottomPoint  =  [self convertPoint:self.textView.frame.origin toView:self];
    CGFloat textViewOriginY  =  textViewBottomPoint.y;
    CGFloat textViewBottomY  =  textViewOriginY + self.textView.frame.size.height;

    CGSize keyboardSize  =  [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat offset  =  (self.frame.size.height - keyboardSize.width) - textViewBottomY;

    if (offset < 0)
    {
        CGFloat newYPos  =  self.frame.origin.y + offset;
        self.frame  =  CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);

    }
}

- (void)portraitChanges:(NSNotification *)notification
{
    CGPoint textViewBottomPoint  =  [self convertPoint:self.textView.frame.origin toView:nil];
    textViewBottomPoint.y +=  self.textView.frame.size.height;

    CGRect screenRect  =  [[UIScreen mainScreen] bounds];

    CGSize keyboardSize  =  [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat offset  =  (screenRect.size.height - keyboardSize.height) - textViewBottomPoint.y;
    
    if (offset < 0)
    {
        CGFloat newYPos  =  self.frame.origin.y + offset;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frame  =  CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);
        });
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    self.frame  =  CGRectMake(self.frame.origin.x,self.originalFrameYPos,self.frame.size.width,self.frame.size.height);
}


#pragma mark - Load Image

- (void)loadImage:(UIImage *)image
{
    self.image  =  image;
    
    //save the loaded image to persist after an undo step
    self.prev_image  =  [image copy];
    
    // when loading an external image, I'm cleaning all the paths and the undo buffer
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

- (void)loadImageData:(NSData *)imageData
{
    CGFloat imageScale;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        imageScale  =  [[UIScreen mainScreen] scale];
        
    }
    else
    {
        imageScale  =  1.0;
    }
    
    UIImage *image  =  [UIImage imageWithData:imageData scale:imageScale];
    [self loadImage:image];
}

- (void)resetTool
{
    if ([self.currentTool isKindOfClass:[DrawingTextTool class]])
    {
        self.textView.text  =  @"";
        [self commitAndHideTextEntry];
    }
    self.currentTool  =  nil;
}

#pragma mark - Actions

- (void)clear
{
    [self resetTool];
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    self.prev_image  =  nil;
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo])
    {
        [self resetTool];
        id<DrawingTool>tool  =  [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo])
    {
        [self resetTool];
        id<DrawingTool>tool  =  [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}


- (void)dealloc
{
    self.pathArray  =  nil;
    self.bufferArray  =  nil;
    self.currentTool  =  nil;
    self.image  =  nil;
    self.prev_image  =  nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
#if !_HAS_ARC
    
    [super dealloc];
#endif
}





@end
