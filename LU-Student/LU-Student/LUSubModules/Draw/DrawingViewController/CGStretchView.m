//
//  CGStretchImageView.m
//  LUStudent

//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import "CGStretchView.h"

@implementation CGStretchView
{
    UIPanGestureRecognizer *mainPan;
    UIRotationGestureRecognizer *mainRotation;
    UIPinchGestureRecognizer *mainPinch;
    UITapGestureRecognizer *mainTap;
    CGFloat prevRotation;
    CGFloat prevPinchScale;
    UIView *borderView;
    UIImageView *fillImage;
}

@synthesize fillImage;

- (id)initWithFrame:(CGRect)frame
{
    self  =  [super initWithFrame:frame];
    if (self) {
        
      //  _isFillActive=YES;
       // if (_fillActive==1)
//        {
//            fillImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1021, 808)];
//            [self addSubview:fillImage];
//        }
        //Set default property values
        self.clipsToBounds  =  NO;
        self.backgroundColor  =  [UIColor clearColor];
        self.userInteractionEnabled  =  YES;
        
        
        _panningEnabled  =  YES;
        _rotationEnabled  =  YES;
        _pinchToZoomEnabled  =  YES;
        _tappingEnabled  =  YES;
        
        //Setup all the gesture recognizers
        [self setupGestureRecognizers];
       // if (_cropActive==1)
        {
      //      _cropppedImageView = [[UIImageView alloc] initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
     //       [self addSubview:_cropppedImageView];
        }
        [self isFillActiveOrCropActive:frame];
        [self setNeedsDisplay];
        
    }
    return self;
}

/**
 <#Description#>

 @param frame <#frame description#>
 */
-(void)isFillActiveOrCropActive: (CGRect)frame
{
    if (_isFillActive)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            fillImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1021/2, 808/2)];
            [self addSubview:fillImage];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        _cropppedImageView = [[UIImageView alloc] initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
               [self addSubview:_cropppedImageView];
        });
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //allow the gestures to go outside the bounds of the view
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0)
    {
        for (UIView *subview in self.subviews.reverseObjectEnumerator)
        {
            CGPoint subPoint  =  [subview convertPoint:point fromView:self];
            UIView *result  =  [subview hitTest:subPoint withEvent:event];
            if (result !=  nil)
            {
                return result;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

/**
 <#Description#>
 */
- (void)setupGestureRecognizers
{
    //setup the main recognizers that change the CGStretchView's location, scale, and rotation
    mainPan  =  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMainView:)];
    [self setDefaultGestureProperties:mainPan];
    mainPan.enabled  =  _panningEnabled;
    [self addGestureRecognizer:mainPan];
    
    mainRotation  =  [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateMainView:)];
    mainRotation.delegate  =  self;
    mainRotation.enabled  =  _rotationEnabled;
    [self addGestureRecognizer:mainRotation];
    
    mainPinch  =  [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMainView:)];
    mainPinch.delegate  =  self;
    mainPinch.enabled  =  _pinchToZoomEnabled;
    [self addGestureRecognizer:mainPinch];
    
    mainTap  =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTapped:)];
    mainTap.numberOfTapsRequired  =  1;
    mainTap.delegate  =  self;
    mainTap.enabled  =  _tappingEnabled;
    [self addGestureRecognizer:mainTap];
    
}

- (void)setDefaultGestureProperties:(UIPanGestureRecognizer*)recognizer
{
    recognizer.minimumNumberOfTouches  =  1;
    recognizer.delaysTouchesBegan  =  NO;
    recognizer.delegate  =  self;
}

- (void)panMainView:(UIPanGestureRecognizer*)panGesture
{
    CGPoint panLocation  =  [panGesture locationInView:self.superview];
    self.center  =  panLocation;
}

- (void)rotateMainView:(UIRotationGestureRecognizer*)rotationGesture
{
    CGFloat rotation  =  [rotationGesture rotation];
    [rotationGesture.view setTransform:CGAffineTransformRotate(self.transform, rotation)];
    [rotationGesture setRotation:0];
}

- (void)zoomMainView:(UIPinchGestureRecognizer*)pinchGesture
{
    CGFloat scale  =  [pinchGesture scale];
    [pinchGesture.view setTransform:CGAffineTransformScale(self.transform, scale, scale)];
    [pinchGesture setScale:1.0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)mainViewTapped:(UITapGestureRecognizer*)tap
{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(stretchViewTapped:)])
            [_delegate stretchViewTapped:self];
    }
}

- (void)setPanningEnabled:(BOOL)panningEnabled
{
    _panningEnabled  =  panningEnabled;
    mainPan.enabled  =  panningEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled  =  rotationEnabled;
    mainRotation.enabled  =  rotationEnabled;
}

- (void)setPinchToZoomEnabled:(BOOL)pinchToZoomEnabled
{
    _pinchToZoomEnabled  =  pinchToZoomEnabled;
    mainPinch.enabled  =  pinchToZoomEnabled;
}

- (void)setTappingEnabled:(BOOL)tappingEnabled
{
    _tappingEnabled  =  tappingEnabled;
    mainTap.enabled  =  _tappingEnabled;
}

- (void)setImage:(UIImage *)image
{
    _image  =  image;
    if(_isFillActive)
    {
       self.fillImage.image = _image;
    }
    else
    {
        _cropppedImageView.image=_image;
    }
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_image)
    {
        [_image drawInRect:rect];
    }
}

#pragma Lonpress for cut copy paste
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"long press");
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (![menu isMenuVisible])
    {
        [self becomeFirstResponder];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count]  ==  1)
    {
        UITouch * touch  =  [touches anyObject];
        
        //Get touch Point
        CGPoint tpoint = [[[event allTouches] anyObject] locationInView:self];
        
        //Convert Touch Point to pixel of Image
        //This code will be according to your need
        tpoint.x = tpoint.x * 2 ;
        tpoint.y = tpoint.y * 2 ;

            
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *filledImage = [_image floodFillFromPoint:[touch locationInView:self.fillImage] withColor:_fillColor andTolerance:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               // fillImage.image  =  filledImage;
               [self setImage: filledImage];
            });
        });
    }
}


@end
