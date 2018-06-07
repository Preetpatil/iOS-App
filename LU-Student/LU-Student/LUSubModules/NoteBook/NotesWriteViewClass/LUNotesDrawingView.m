//
//  LUNotesDrawingView.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import "LUNotesDrawingView.h"
#import "LUNotesDrawingTool.h"
#import "CGStretchView.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor grayColor]
#define kDefaultLineWidth       0.5f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0
#define IOS8_OR_ABOVE [[[UIDevice currentDevice] systemVersion] integerValue] >=  8.0

@interface LUNotesDrawingView () {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
   
}

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<LUNotesDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGFloat originalFrameYPos;

@property(nonatomic,weak)NSData *lastTouchTime;

@end

#pragma mark -

@implementation LUNotesDrawingView

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

/**
 <#Description#>
 */
- (void)configure
{
    // init the private arrays
    self.pathArray  =  [NSMutableArray array];
    self.bufferArray  =  [NSMutableArray array];
    self.trial = [[NSMutableArray alloc]init];////////////
    
    // set the default values for the public properties
    self.lineColor  =  kDefaultLineColor;
    self.lineWidth  =  kDefaultLineWidth;
    self.lineAlpha  =  kDefaultLineAlpha;
    
    self.drawMode  =  NOTESDrawingModeOriginalSize;
    
    // set the transparent background
    self.backgroundColor  =  [UIColor clearColor];
    
    self.originalFrameYPos  =  self.frame.origin.y;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

/**
 <#Description#>

 @return <#return value description#>
 */
- (UIImage *)prev_image
{
    return self.backgroundImage;
}

/**
 <#Description#>

 @param prev_image <#prev_image description#>
 */
- (void)setPrev_image:(UIImage *)prev_image
{
    [self setBackgroundImage:prev_image];
}


#pragma mark - Drawing

/**
 <#Description#>

 @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    switch (self.drawMode)
    {
        case NOTESDrawingModeOriginalSize:
            [self.image drawAtPoint:CGPointZero];
            break;
            
        case NOTESDrawingModeScale:
            [self.image drawInRect:self.bounds];
            break;
    }
    [self.currentTool draw];
#endif
}

/**
 <#Description#>
 */
- (void)commitAndDiscardToolStack
{
    [self updateCacheImage:YES];
    self.backgroundImage  =  self.image;
    [self.pathArray removeAllObjects];
}

/**
 <#Description#>

 @param redraw <#redraw description#>
 */
- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw)
    {
        // erase the previous image
        self.image  =  nil;
        
        // load previous image (if returning to screen)
        
        switch (self.drawMode)
        {
            case NOTESDrawingModeOriginalSize:
                [[self.backgroundImage copy] drawAtPoint:CGPointZero];
                break;
            case NOTESDrawingModeScale:
                [[self.backgroundImage copy] drawInRect:self.bounds];
                break;
        }
        
        // I need to redraw all the lines
        for (id<LUNotesDrawingTool> tool in self.pathArray)
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

/**
 <#Description#>
 */
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

/**
 <#Description#>

 @param customDrawTool <#customDrawTool description#>
 */
- (void)setCustomDrawTool:(id<LUNotesDrawingTool>)customDrawTool
{
    _customDrawTool  =  customDrawTool;
    
    if (customDrawTool !=  nil)
    {
        self.drawTool  =  NOTESDrawingToolTypeCustom;
    }
}

/**
 <#Description#>

 @return <#return value description#>
 */
- (id<LUNotesDrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool)
    {
        case NOTESDrawingToolTypePen:
        {
            return NOTES_AUTORELEASE([NOTESDrawingPenTool new]);
        }
            
        case NOTESDrawingToolTypeLine:
        {
            return NOTES_AUTORELEASE([NOTESDrawingLineTool new]);
        }
            
        case NOTESDrawingToolTypeText:
        {
            return NOTES_AUTORELEASE([NOTESDrawingTextTool new]);
        }
            
        case NOTESDrawingToolTypeMultilineText:
        {
            return NOTES_AUTORELEASE([NOTESDrawingMultilineTextTool new]);
        }
            
        case NOTESDrawingToolTypeRectagleStroke:
        {
            NOTESDrawingRectangleTool *tool  =  NOTES_AUTORELEASE([NOTESDrawingRectangleTool new]);
            tool.fill  =  NO;
            return tool;
        }
            
        case NOTESDrawingToolTypeRectagleFill:
        {
            NOTESDrawingRectangleTool *tool  =  NOTES_AUTORELEASE([NOTESDrawingRectangleTool new]);
            tool.fill  =  YES;
            return tool;
        }
            
        case NOTESDrawingToolTypeEllipseStroke:
        {
            NOTESDrawingEllipseTool *tool  =  NOTES_AUTORELEASE([NOTESDrawingEllipseTool new]);
            tool.fill  =  NO;
            return tool;
        }
            
        case NOTESDrawingToolTypeEllipseFill:
        {
            NOTESDrawingEllipseTool *tool  =  NOTES_AUTORELEASE([NOTESDrawingEllipseTool new]);
            tool.fill  =  YES;
            return tool;
        }
            
        case NOTESDrawingToolTypeEraser:
        {
            return NOTES_AUTORELEASE([NOTESDrawingEraserTool new]);
        }
            
        case NOTESDrawingToolTypeCustom:
        {
            return self.customDrawTool;
        }
    }
}


#pragma mark - Touch Methods

/**
 <#Description#>

 @param touches <#touches description#>
 @param event <#event description#>
 */
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
    
    if ([self.currentTool class]  ==  [NOTESDrawingTextTool class])
    {
        [self initializeTextBox:currentPoint WithMultiline:NO];
    }
    else if([self.currentTool class]  ==  [NOTESDrawingMultilineTextTool class])
    {
        [self initializeTextBox:currentPoint WithMultiline:YES];
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

/**
 <#Description#>

 @param touches <#touches description#>
 @param event <#event description#>
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesArray  =  [touches allObjects];
    UITouch *touch1;
    CGPoint ptTouch;
    CGPoint ptPrevious;
       
    touch1  =  [touchesArray objectAtIndex:0];
    ptTouch  =  [touch1 locationInView:self];
    ptPrevious  =  [touch1 previousLocationInView:self];
    
    CGFloat xMove  =  ptTouch.x - ptPrevious.x;
    CGFloat yMove  =  ptTouch.y - ptPrevious.y;
    _distance =  sqrt ((xMove * xMove) + (yMove * yMove));
    
    // save all the touches in the path
    UITouch *touch  =  [touches anyObject];
    
    previousPoint2  =  previousPoint1;
    previousPoint1  =  [touch previousLocationInView:self];
    currentPoint  =  [touch locationInView:self];
    
    if ([self.currentTool isKindOfClass:[NOTESDrawingPenTool class]])
    {
        CGRect bounds  =  [(NOTESDrawingPenTool*)self.currentTool addPathPreviousPreviousPoint:previousPoint2 withPreviousPoint:previousPoint1 withCurrentPoint:currentPoint];
        
        CGRect drawBox  =  bounds;
        drawBox.origin.x -=  self.lineWidth * 2.0;
        drawBox.origin.y -=  self.lineWidth * 2.0;
        drawBox.size.width +=  self.lineWidth * 4.0;
        drawBox.size.height +=  self.lineWidth * 4.0;
        
        [self setNeedsDisplayInRect:drawBox];
    }
    else if ([self.currentTool isKindOfClass:[NOTESDrawingTextTool class]])
    {
        [self resizeTextViewFrame: currentPoint];
    }
    else
    {
        [self.currentTool moveFromPoint:previousPoint1 toPoint:currentPoint];
        [self setNeedsDisplay];
    }
    
}

/**
 <#Description#>

 @param touches <#touches description#>
 @param event <#event description#>
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch  =  [touches anyObject];
    CGPoint x = [touch locationInView:self];
    
    _imageY = x.y;
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    if ([self.currentTool isKindOfClass:[NOTESDrawingTextTool class]])
    {
        [self startTextEntry];
    }
    else
    {
        [self finishDrawing];
    }
    if(_imageToStamp )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageHolder  =  [[UIImageView alloc] initWithFrame:CGRectMake(x.x, x.y, 32,32)];
            imageHolder.image  =  _imageToStamp;
            [self addSubview:imageHolder];
        });
    }
        
}

/**
 <#Description#>

 @param touches <#touches description#>
 @param event <#event description#>
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Text Entry

/**
 <#Description#>

 @param startingPoint <#startingPoint description#>
 @param multiline <#multiline description#>
 */
- (void)initializeTextBox:(CGPoint)startingPoint WithMultiline:(BOOL)multiline
{
    if (!self.textView)
    {
        self.textView  =  [[UITextView alloc] init];
        self.textView.delegate  =  self;
        if(!multiline)
        {
            self.textView.returnKeyType  =  UIReturnKeyDone;
        }
        self.textView.autocorrectionType  =  UITextAutocorrectionTypeNo;
        self.textView.backgroundColor  =  [UIColor clearColor];
        self.textView.layer.borderWidth  =  1.0f;
        self.textView.layer.borderColor  =  [[UIColor grayColor] CGColor];
        self.textView.layer.cornerRadius  =  8;
        [self.textView setContentInset: UIEdgeInsetsZero];
        
        [self addSubview:self.textView];
    }
    
    int calculatedFontSize  =  self.lineWidth * 40; //font size is adjusted here
    
    [self.textView setFont:[UIFont fontWithName:_fontStyle size:_fontSize]];//systemFontOfSize:calculatedFontSize]];
    self.textView.textColor  =  self.lineColor;
    self.textView.alpha  =  self.lineAlpha;
    
    int defaultWidth  =  200;
    int defaultHeight  =  calculatedFontSize * 2;
    int initialYPosition  =  startingPoint.y - (defaultHeight/2);
    
    CGRect frame  =  CGRectMake(startingPoint.x, initialYPosition, defaultWidth, defaultHeight);
    frame  =  [self adjustFrameToFitWithinDrawingBounds:frame];
    
    self.textView.frame  =  frame;
    self.textView.text  =  @" ";
    self.textView.hidden  =  NO;
}

/**
 <#Description#>
 */
- (void) startTextEntry
{
    if (!self.textView.hidden)
    {
        [self.textView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(([self.currentTool class]  ==  [NOTESDrawingTextTool  class]) && [text isEqualToString:@"\n"])
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

- (void)textViewDidEndEditing:(UITextView *)textView{
    
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

/**
 <#Description#>
 */
- (void)commitAndHideTextEntry
{
    [self.textView resignFirstResponder];
   // _tts1 = [NSString stringWithString:self.textView.text];///
   // [_trial addObject:_tts1];////

    if ([self.textView.text length])
    {
        UIEdgeInsets textInset  =  self.textView.textContainerInset;
        CGFloat additionalXPadding  =  5;
        CGPoint start  =  CGPointMake(self.textView.frame.origin.x + textInset.left + additionalXPadding, self.textView.frame.origin.y + textInset.top);
        CGPoint end  =  CGPointMake(self.textView.frame.origin.x + self.textView.frame.size.width - additionalXPadding, self.textView.frame.origin.y + self.textView.frame.size.height);
        
        ((NOTESDrawingTextTool*)self.currentTool).attributedText  =  [self.textView.attributedText copy];
        
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:start]; //change this for precision accuracy of text location
        [self.currentTool moveFromPoint:start toPoint:end];
        [self setNeedsDisplay];
        
        [self finishDrawing];
    }
    //// this is where the text is stored ready to tts function ///
    self.currentTool  =  nil;
    self.textView.hidden  =  YES;
    self.textView  =  nil;
}

#pragma mark - Keyboard Events

/**
 <#Description#>

 @param notification <#notification description#>
 */
- (void)keyboardDidShow:(NSNotification *)notification
{
    self.originalFrameYPos  =  self.frame.origin.y;
    
    if (IOS8_OR_ABOVE)
    {
        [self adjustFramePosition:notification];
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            [self landscapeChanges:notification];
        }
        else
        {
            [self adjustFramePosition:notification];
        }
    }
}

/**
 <#Description#>

 @param notification <#notification description#>
 */
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frame  =  CGRectMake(self.frame.origin.x,newYPos, self.frame.size.width, self.frame.size.height);
        });
    }
}

/**
 <#Description#>

 @param notification <#notification description#>
 */
- (void)adjustFramePosition:(NSNotification *)notification
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


/**
 <#Description#>

 @param notification <#notification description#>
 */
-(void)keyboardDidHide:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame  =  CGRectMake(self.frame.origin.x,self.originalFrameYPos,self.frame.size.width,self.frame.size.height);
    });
}


#pragma mark - Load Image

/**
 <#Description#>

 @param image <#image description#>
 */
- (void)loadImage:(UIImage *)image
{
    self.image  =  image;

    //save the loaded image to persist after an undo step
    self.backgroundImage  = image;// [image copy];
    // when loading an external image, I'm cleaning all the paths and the undo buffer
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

/**
 <#Description#>

 @param imageData <#imageData description#>
 */
- (void)loadImageData:(NSData *)imageData
{
    CGFloat imageScale;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        imageScale  =  [[UIScreen mainScreen] scale];
    }
    else
    {
        imageScale  =  0.0;
    }
    
    UIImage *image  =  [UIImage imageWithData:imageData scale:imageScale];
    [self loadImage:image];
}

/**
 <#Description#>
 */
- (void)resetTool
{
    if ([self.currentTool isKindOfClass:[NOTESDrawingTextTool class]])
    {
        self.textView.text  =  @" ";
        [self commitAndHideTextEntry];
    }
    self.currentTool  =  nil;
}

#pragma mark - Actions

/**
 <#Description#>
 */
- (void)clear
{
    [self resetTool];
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    self.backgroundImage  =  nil;
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

/**
 <#Description#>

 @return <#return value description#>
 */
- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

/**
 <#Description#>

 @return <#return value description#>
 */
- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

/**
 <#Description#>
 */
- (void)undoLatestStep
{
    if ([self canUndo])
    {
        [self resetTool];
        id<LUNotesDrawingTool>tool  =  [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

/**
 <#Description#>

 @return <#return value description#>
 */
- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

/**
 <#Description#>
 */
- (void)redoLatestStep
{
    if ([self canRedo])
    {
        [self resetTool];
        id<LUNotesDrawingTool>tool  =  [self.bufferArray lastObject];
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
    self.backgroundImage  =  nil;
    self.customDrawTool  =  nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
#if !NOTES_HAS_ARC
    
    [super dealloc];
#endif
}


@end
