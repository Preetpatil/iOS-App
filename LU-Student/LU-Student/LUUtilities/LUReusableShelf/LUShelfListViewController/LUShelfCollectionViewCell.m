//
//
//  LUShelfCollectionViewCell.h
//  LearningUmbrellaMaster

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUShelfCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LUShelfCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self  =  [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderColor  =  [[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0] CGColor];
    self.layer.borderWidth  =  1.0;
}

@end
