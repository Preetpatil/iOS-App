//
//  TouchView.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//

#import "TouchView.h"
#import "ARCMacros.h"

@implementation TouchView

-(void)dealloc
{
#ifdef _DEBUG
    NSLog(@"TouchView dealloc");
#endif
    
    SAFE_ARC_RELEASE(_insideBlock);
    SAFE_ARC_RELEASE(_outsideBlock);
    SAFE_ARC_SUPER_DEALLOC();
}

-(void)setTouchedOutsideBlock:(TouchedOutsideBlock)outsideBlock
{
    SAFE_ARC_RELEASE(_outsideBlock);
    _outsideBlock  =  [outsideBlock copy];
}

-(void)setTouchedInsideBlock:(TouchedInsideBlock)insideBlock
{
    SAFE_ARC_RELEASE(_insideBlock);
    _insideBlock  =  [insideBlock copy];
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *subview  =  [super hitTest:point withEvent:event];

    if(UIEventTypeTouches  ==  event.type)
    {
        BOOL touchedInside  =  subview !=  self;
        if(!touchedInside)
        {
            for(UIView *s in self.subviews)
            {
                if(s  ==  subview)
                {
                    //touched inside
                    touchedInside  =  YES;
                    break;
                }
            }            
        }
        
        if(touchedInside && _insideBlock)
        {
            _insideBlock();
        }
        else if(!touchedInside && _outsideBlock)
        {
            _outsideBlock();
        }
    }
    
    return subview;
}


@end
