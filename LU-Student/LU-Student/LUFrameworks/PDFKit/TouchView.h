//
//  TouchView.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//

#import <UIKit/UIKit.h>

typedef void (^TouchedOutsideBlock)();
typedef void (^TouchedInsideBlock)();

@interface TouchView : UIView
{
    __strong TouchedOutsideBlock _outsideBlock;
    __strong TouchedInsideBlock  _insideBlock;
}

-(void)setTouchedOutsideBlock:(TouchedOutsideBlock)outsideBlock;

-(void)setTouchedInsideBlock:(TouchedInsideBlock)insideBlock;

@end
