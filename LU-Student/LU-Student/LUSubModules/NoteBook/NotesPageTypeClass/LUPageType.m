//  LUPageType.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
#import "LUPageType.h"

@implementation LUPageType

/**
 <#Description#>

 @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect
{
    if ([_Type isEqual:@"Ruled"])
    {
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        int j = 60;
            
        for (int i = 0;i<19; i++)
        {
            CGContextMoveToPoint(context, 5, j);
            CGContextAddLineToPoint(context,self.bounds.size.width-5, j);
            j = j+41+_slide;
        }
        
        CGContextStrokePath(context);
        CGContextRef context1  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 2.0);
        CGContextSetStrokeColorWithColor(context1, [UIColor redColor].CGColor);
        CGContextMoveToPoint(context1, 100, 5);
        CGContextAddLineToPoint(context1, 100, self.bounds.size.height-10);
        CGContextStrokePath(context1);
    }
    else if([_Type isEqual:@"Checked"])
    {
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        int k = 20;
        
        for (int i = 0;i<20; i++)
        {
            CGContextMoveToPoint(context, 20, k);
            CGContextAddLineToPoint(context, self.bounds.size.width-23, k);
            k = k+50+_slide-1;
        }
        int j = 20;
        for (int i = 0;i<28; i++)
        {
            CGContextMoveToPoint(context, j, 20);
            CGContextAddLineToPoint(context, j, self.bounds.size.height-40);
            j = j+50+_slide-1;
        }
        CGContextStrokePath(context);
    }
    else if ([_Type isEqual:@"Ruled Activity"])
    {
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        int j = 60;
        for (int i = 0;i<20; i++)
        {
            CGContextMoveToPoint(context, 5, j);
            CGContextAddLineToPoint(context, self.bounds.size.width-5, j);
            j = j+40+_slide-1;
        }
        
        CGContextStrokePath(context);
        CGContextRef context1  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 2.0);
        CGContextSetStrokeColorWithColor(context1, [UIColor redColor].CGColor);
        
        CGContextMoveToPoint(context, 150, 5);
        CGContextAddLineToPoint(context, 150, self.bounds.size.height-5);
        
        CGContextMoveToPoint(context, 900, 5);
        CGContextAddLineToPoint(context, 900, self.bounds.size.height-5);
        
        CGContextStrokePath(context1);
    }
    else if ([_Type isEqual:@"Plain Activity"])
    {
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextRef context1  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 2.0);
        CGContextSetStrokeColorWithColor(context1, [UIColor redColor].CGColor);
        
        CGContextMoveToPoint(context, 150, 5);
        CGContextAddLineToPoint(context, 150, self.bounds.size.height-5);
        CGContextMoveToPoint(context, 900, 5);
        CGContextAddLineToPoint(context, 900, self.bounds.size.height-5);
        CGContextStrokePath(context1);

    }
    else if ([_Type isEqual:@"Left margin"])
    {
        CGContextRef context1  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 1.5);
        CGContextSetStrokeColorWithColor(context1, [UIColor redColor].CGColor);
        CGContextMoveToPoint(context1, 5, 100);
        CGContextAddLineToPoint(context1, self.bounds.size.width-5, 100);
        
        CGContextMoveToPoint(context1, 5, 105);
        CGContextAddLineToPoint(context1, self.bounds.size.width-5, 105);
        CGContextMoveToPoint(context1, 150, 5);
        CGContextAddLineToPoint(context1, 150, self.bounds.size.height-5);
        CGContextStrokePath(context1);
    }
    else if ([_Type isEqual:@"Cursive"])
    {
        int j = 25;
        int k = 50;
        for (int l = 0; l<7; l++)
        {
            CGContextRef context  =  UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 2.0);
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            for (int i = 0;i<2; i++)
            {
                CGContextMoveToPoint(context, 5, j);
                CGContextAddLineToPoint(context, self.bounds.size.width-5, j);
                j = j+80;
            }
            
            CGContextStrokePath(context);
            j = j+10;
            
            CGContextRef context1  =  UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context1, 1.5);
            CGContextSetStrokeColorWithColor(context1, [UIColor blueColor].CGColor);
            
            for (int i = 0;i<2; i++)
            {
                CGContextMoveToPoint(context1, 5, k);
                CGContextAddLineToPoint(context1, self.bounds.size.width-5,k);
                k = k+30;
            }
            CGContextStrokePath(context1);
            j = j-60;
            k = k+50;
        }
    }
    else if ([_Type isEqual:@"Graph"])
    {
        int l = 26;
        int m = 26;
        CGContextRef inner  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(inner, 1.5);
        CGContextSetStrokeColorWithColor(inner, [UIColor lightGrayColor].CGColor);
        
        for (int n = 0;n<13;n++)
        {
            for (int i = 0;i<9; i++)
            {
                CGContextMoveToPoint(inner, 21, l);
                CGContextAddLineToPoint(inner, self.bounds.size.width-25, l);
                l = l+6;
            }
            l = l+6;
        }
        for (int n = 0;n<22;n++)
        {
            for (int i = 0;i<9; i++)
            {
                CGContextMoveToPoint(inner, m, 21);
                CGContextAddLineToPoint(inner, m, self.bounds.size.height-45);
                m = m+6;
            }
            m = m+6;
        }
        
        CGContextStrokePath(inner);
        CGContextRef outer  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(outer, 1.5);
        CGContextSetStrokeColorWithColor(outer, [UIColor redColor].CGColor);
        int k = 20;
        for (int i = 0;i<14; i++)
        {
            
            CGContextMoveToPoint(outer,19, k);
            CGContextAddLineToPoint(outer, self.bounds.size.width-25, k);
            k = k+60;
        }
        int j = 20;
        
        for (int i = 0;i<23; i++)
        {
            
            CGContextMoveToPoint(outer, j, 21);
            CGContextAddLineToPoint(outer, j, self.bounds.size.height-45);
            
            j = j+60;
            
        }
        CGContextStrokePath(outer);
    }
    else if ([_Type isEqual:@"Diary"])
    {
        int j = 40;
        CGContextRef context  =  UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        
        for (int i = 0;i<2; i++)
        {
            CGContextMoveToPoint(context, 20, j);
            CGContextAddLineToPoint(context, self.bounds.size.width-300, j);
            j = j+45;
        }
        for (int i = 0;i<16; i++)
        {
            CGContextMoveToPoint(context,20, j);
            CGContextAddLineToPoint(context, self.bounds.size.width-20, j);
            j = j+45;
        }
//        CGContextMoveToPoint(context, 60, j);
//        CGContextAddLineToPoint(context, self.bounds.size.width-300, j);
        CGContextStrokePath(context);
    }
}
@end
