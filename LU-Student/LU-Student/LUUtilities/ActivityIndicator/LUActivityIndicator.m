//
//  LUActivityIndicator.m
//  LearningUmbrellaMaster
//
//  Created by Abhishek P Mukundan on 21/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUActivityIndicator.h"

@implementation LUActivityIndicator

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    NSArray *imageNames = @[@"a1.png", @"a2.png", @"a3.png"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    UIImageView *activityIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-32, self.frame.size.height/2-32, 64, 64)];
    activityIndicator.animationImages = images;
    activityIndicator.animationDuration = 1.0f;
    activityIndicator.animationRepeatCount = 0;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    
}

@end
