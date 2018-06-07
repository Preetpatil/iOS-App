//
//  LUAlertPopup.h
//  LearningUmbrellaMaster
//
//  Created by Abhishek P Mukundan on 22/02/17.
//  Copyright © 2017 LEARNING UMBRELLA. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^LUAlertBlock) (void);

typedef enum : NSUInteger {
    LUAlertPopupStyleDropDown,
} LUAlertPopupStyle;


@interface LUAlertPopup : UIView


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(BOOL)cancelButton okButton:(BOOL)okButton sizeOfView:(CGRect)size;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(BOOL)cancelButton okButton:(BOOL)okButton sizeOfView:(CGRect)size style:(LUAlertPopupStyle)animationStyle;


-(void)show;


@property(nonatomic,copy)LUAlertBlock cancelButtonClickedBlock;
@property(nonatomic,copy)LUAlertBlock okButtonClickedBlock;


@end
