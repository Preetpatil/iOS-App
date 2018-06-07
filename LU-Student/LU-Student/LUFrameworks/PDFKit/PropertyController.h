//
//  PropertyController.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//

//

#import <UIKit/UIKit.h>
#import "PopoverController.h"

@interface PropertyController : UITableViewController

@property (nonatomic , strong) UIColor *lineColor;
@property (nonatomic , strong) NSNumber *lineWidth;
@property (nonatomic , strong) NSNumber *lineAlpha;
@property (nonatomic , strong) UIButton *colorButton;
@property (strong, nonatomic) PopoverController *popover;

- (void)sliderThickAction:(UISlider *)sender;
- (void)sliderAlphaAction:(UISlider *)sender;
-(void)setImageView:(UIColor *)color;

@end
