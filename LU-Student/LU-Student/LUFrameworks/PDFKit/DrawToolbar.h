//
//  DrawToolbar.h
//  KitDemo
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIXToolbarView.h"

@class DrawToolbar;
@class Document;

@protocol DrawToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(DrawToolbar *)toolbar drawButton:(UIButton *)button;

@end

@interface DrawToolbar : UIXToolbarView

@property (nonatomic, weak, readwrite) id <DrawToolbarDelegate> delegate;
@property (nonatomic,strong) UIButton *penButton;
@property (nonatomic,strong) UIButton *textButton;
@property (nonatomic,strong) UIButton *highlightButton;
@property (nonatomic,strong) UIButton *lineButton;
@property (nonatomic,strong) UIButton *squareButton;
@property (nonatomic,strong) UIButton *circleButton;
@property (nonatomic,strong) UIButton *circleFillButton;
@property (nonatomic,strong) UIButton *eraserButton;
@property (nonatomic,strong) UIButton *colorButton;
@property (nonatomic,strong) UIButton *undoButton;
@property (nonatomic,strong) UIButton *redoButton;
@property (nonatomic,strong) UIButton *clearButton;

- (instancetype)initWithFrame:(CGRect)frame document:(Document *)document;
- (void)hideToolbar;
- (void)showToolbar;
- (UIImage *)getColorButtonImage:(UIColor *)color withSize:(NSNumber *)size;
- (void)clearButtonSelection:(NSInteger)upto;
@end
