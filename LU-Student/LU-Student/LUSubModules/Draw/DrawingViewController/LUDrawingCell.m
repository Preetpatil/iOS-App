//
//  LUDrawingCell.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUDrawingCell.h"

@implementation LUDrawingCell
- (id)initWithFrame:(CGRect)aRect
{
    self  =  [super initWithFrame:aRect];
    {
        _Drawings  =  [[UIImageView alloc] init];
        //[self addSubview:_Drawings];
    }
    return self;
}
@end
