//
//  PopoverView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum PopoverArrowDirection: NSUInteger {
    PopoverArrowDirectionUp  =  1UL << 0,
    PopoverArrowDirectionDown  =  1UL << 1,
    PopoverArrowDirectionLeft  =  1UL << 2,
    PopoverArrowDirectionRight  =  1UL << 3,
    PopoverNoArrow  =  1UL << 4,
    
    PopoverArrowDirectionVertical  =  PopoverArrowDirectionUp | PopoverArrowDirectionDown | PopoverNoArrow,
    PopoverArrowDirectionHorizontal  =  PopoverArrowDirectionLeft | PopoverArrowDirectionRight,
    
    PopoverArrowDirectionAny  =  PopoverArrowDirectionUp | PopoverArrowDirectionDown | 
    PopoverArrowDirectionLeft | PopoverArrowDirectionRight
    
} PopoverArrowDirection;

#ifndef PopoverArrowDirectionIsVertical
    #define PopoverArrowDirectionIsVertical(direction)    ((direction)  ==  PopoverArrowDirectionVertical || (direction)  ==  PopoverArrowDirectionUp || (direction)  ==  PopoverArrowDirectionDown || (direction)  ==  PopoverNoArrow)
#endif

#ifndef PopoverArrowDirectionIsHorizontal
#define PopoverArrowDirectionIsHorizontal(direction)    ((direction)  ==  PopoverArrowDirectionHorizontal || (direction)  ==  PopoverArrowDirectionLeft || (direction)  ==  PopoverArrowDirectionRight)
#endif

typedef enum {
    PopoverWhiteTint,
    PopoverBlackTint,
    PopoverLightGrayTint,
    PopoverGreenTint,
    PopoverRedTint,
    PopoverDefaultTint  =  PopoverBlackTint
} PopoverTint;

@interface PopoverView : UIView

@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) CGPoint relativeOrigin;
@property(nonatomic,assign) PopoverTint tint;
@property(nonatomic,assign) BOOL draw3dBorder;
@property(nonatomic,assign) BOOL border; //default YES

-(void)setArrowDirection:(PopoverArrowDirection)arrowDirection;
-(PopoverArrowDirection)arrowDirection;

-(void)addContentView:(UIView*)contentView;

@end
