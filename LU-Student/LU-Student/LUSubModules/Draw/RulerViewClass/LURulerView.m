//
//  LURulerView.m
//  LUStudent

//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import "LURulerView.h"

@implementation LURulerView
{
    UIPanGestureRecognizer *mainPan;
    UIRotationGestureRecognizer *mainRotation;
    
    UITapGestureRecognizer *mainTap;
    CGFloat prevRotation;
    CGFloat prevPinchScale;
    UIView *borderView;
}

- (id)initWithFrame:(CGRect)frame
{
    self  =  [super initWithFrame:frame];
    if (self) {
        
        //Set default property values
        self.clipsToBounds  =  NO;
        self.backgroundColor  =  [UIColor whiteColor];
        self.userInteractionEnabled  =  YES;
        
        borderView  =  [[UIView alloc] initWithFrame:self.bounds];
        borderView.backgroundColor  =  [UIColor clearColor];
        [self addSubview:borderView];
        
        _panningEnabled  =  YES;
        _rotationEnabled  =  YES;
        _tappingEnabled  =  YES;
        
        //Setup all the gesture recognizers
        [self setupGestureRecognizers];
        
              //finish up the view
        [self setNeedsDisplay];
        
    }
    return self;
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
    
    
    mainTap  =  [[UITapGestureRecognizer alloc]init];
    mainTap.numberOfTapsRequired  =  1;
    mainTap.delegate  =  self;
    mainTap.enabled  =  _tappingEnabled;
    [self addGestureRecognizer:mainTap];
    
}

/**
 <#Description#>

 @param recognizer <#recognizer description#>
 */
- (void)setDefaultGestureProperties:(UIPanGestureRecognizer*)recognizer
{
    recognizer.minimumNumberOfTouches  =  1;
    recognizer.delaysTouchesBegan  =  NO;
    recognizer.delegate  =  self;
}

/**
 <#Description#>

 @param panGesture <#panGesture description#>
 */
- (void)panMainView:(UIPanGestureRecognizer*)panGesture
{
    CGPoint panLocation  =  [panGesture locationInView:self.superview];
    self.center  =  panLocation;
}

/**
 <#Description#>

 @param rotationGesture <#rotationGesture description#>
 */
- (void)rotateMainView:(UIRotationGestureRecognizer*)rotationGesture
{
    CGFloat rotation  =  [rotationGesture rotation];
    [rotationGesture.view setTransform:CGAffineTransformRotate(self.transform, rotation)];
    [rotationGesture setRotation:0];
}

/**
 <#Description#>

 @param pinchGesture <#pinchGesture description#>
 */
- (void)zoomMainView:(UIPinchGestureRecognizer*)pinchGesture
{
    CGFloat scale  =  [pinchGesture scale];
    [pinchGesture.view setTransform:CGAffineTransformScale(self.transform, scale, scale)];
    [pinchGesture setScale:1.0];
}

/**
 <#Description#>

 @param gestureRecognizer <#gestureRecognizer description#>
 @param otherGestureRecognizer <#otherGestureRecognizer description#>
 @return <#return value description#>
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/**
 <#Description#>

 @param panningEnabled <#panningEnabled description#>
 */
- (void)setPanningEnabled:(BOOL)panningEnabled
{
    _panningEnabled  =  panningEnabled;
    mainPan.enabled  =  panningEnabled;
}

/**
 <#Description#>

 @param rotationEnabled <#rotationEnabled description#>
 */
- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled  =  rotationEnabled;
    mainRotation.enabled  =  rotationEnabled;
}

/**
 <#Description#>

 @param tappingEnabled <#tappingEnabled description#>
 */
- (void)setTappingEnabled:(BOOL)tappingEnabled
{
    _tappingEnabled  =  tappingEnabled;
    mainTap.enabled  =  _tappingEnabled;
}

/**
 <#Description#>

 @param image <#image description#>
 */
- (void)setImage:(UIImage *)image
{
    _image  =  image;
    [self setNeedsDisplay];
}

/**
 <#Description#>

 @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_image)
    {
        [_image drawInRect:rect];
    }
}

@end
