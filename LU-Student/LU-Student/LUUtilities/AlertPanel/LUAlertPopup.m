//
//  LUAlertPopup.h
//  LearningUmbrellaMaster
//
//  Created by Abhishek P Mukundan on 22/02/17.
//  Copyright © 2017 LEARNING UMBRELLA. All rights reserved.
//


#define COLORWITHRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLORWITHSAMEVALUE(v) [UIColor colorWithRed:v/255.0 green:v/255.0 blue:v/255.0 alpha:1.0]

#define TITLEHEIGHT     55
#define MESSAGEHEIGHT   200
#define BUTTONHEIGHT    50
#define MARGIN          15
#define MESSAGEMARGIN   15

#define FONT_TITLE    20.0f
#define FONT_MESSAGE  16.0f
#define FONT_BUTTON   16.0f


#import "LUAlertPopup.h"



@interface LUAlertPopup()

@property(nonatomic,strong)UIImageView *backgorundAlert;
@property(nonatomic,strong)UIImageView *logo;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIButton *okButton;


@end

@implementation LUAlertPopup{

    
    UIView *dimmingView;
    
    LUAlertPopupStyle type;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(BOOL)cancelButton okButton:(BOOL)okButton sizeOfView:(CGRect)size{
    
    return [self initWithTitle:title message:message cancelButton:cancelButton okButton:okButton sizeOfView:size style:LUAlertPopupStyleDropDown];
}


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(BOOL)cancelButton okButton:(BOOL)okButton sizeOfView:(CGRect)size style:(LUAlertPopupStyle)animationStyle{
    
    self = [super initWithFrame:size];
    
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
        _backgorundAlert = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.size.width,size.size.height)];
        _backgorundAlert.image = [UIImage imageNamed:@"alertBG2.png"];
        [self addSubview:_backgorundAlert];
        
        _logo = [[UIImageView alloc]initWithFrame:CGRectMake(size.size.width/2-35, 30, 75, 75)];
        _logo.image= [UIImage imageNamed:@"250x250.png"];
        [self addSubview:_logo];
        type = animationStyle;
        
        
        
        
            UILabel *heading = [[UILabel alloc]initWithFrame:CGRectMake(size.size.width/2-100,size.size.height-(size.size.height-120),200, 30)];
            heading.textAlignment = 1;
            heading.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_TITLE];
            heading.textColor = [UIColor whiteColor];
            heading.text = title;
            [_backgorundAlert addSubview:heading];
        
            UITextView *textArea = [[UITextView alloc]initWithFrame:CGRectMake(MESSAGEMARGIN, size.size.height-(size.size.height-150),size.size.width-MESSAGEMARGIN,size.size.height-200)];
            textArea.text = message;
            [textArea setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_MESSAGE]];
            textArea.backgroundColor = [UIColor clearColor];
            [textArea setScrollEnabled:YES];
            textArea.showsHorizontalScrollIndicator = NO;
            textArea.editable = NO;
            [textArea setUserInteractionEnabled:YES];
            textArea.textColor = [UIColor whiteColor];
            [_backgorundAlert addSubview:textArea];

        
        if (cancelButton && okButton == YES)
        {
            
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelButton.frame = CGRectMake(0,size.size.height-BUTTONHEIGHT,size.size.width/2,BUTTONHEIGHT);
            [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //  [self.cancelButton setTitleColor:COLORWITHSAMEVALUE(55) forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:COLORWITHSAMEVALUE(255) forState:UIControlStateHighlighted];
            self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BUTTON];
            //   self.cancelButton.backgroundColor = COLORWITHSAMEVALUE(238);
            
            
            self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.okButton.frame = CGRectMake(size.size.width/2,size.size.height-BUTTONHEIGHT,size.size.width/2,BUTTONHEIGHT);
            [self.okButton addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            // [self.otherButton setTitleColor:COLORWITHSAMEVALUE(55) forState:UIControlStateNormal];
            [self.okButton setTitleColor:COLORWITHSAMEVALUE(255) forState:UIControlStateHighlighted];
            self.okButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BUTTON];
            //  self.otherButton.backgroundColor = COLORWITHSAMEVALUE(238);
            
            [self addSubview:self.cancelButton];
            [self addSubview:self.okButton];
            
            [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
            
        } else if (cancelButton ==YES && okButton == NO)
        {
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelButton.frame = CGRectMake(0,size.size.height-BUTTONHEIGHT,size.size.width,BUTTONHEIGHT);
            [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //  [self.cancelButton setTitleColor:COLORWITHSAMEVALUE(55) forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:COLORWITHSAMEVALUE(255) forState:UIControlStateHighlighted];
            self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BUTTON];
            [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self addSubview:self.cancelButton];

        }else if (cancelButton ==NO && okButton == YES)
        {
            self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.okButton.frame = CGRectMake(0,size.size.height-BUTTONHEIGHT,size.size.width,BUTTONHEIGHT);
            [self.okButton addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            // [self.otherButton setTitleColor:COLORWITHSAMEVALUE(55) forState:UIControlStateNormal];
            [self.okButton setTitleColor:COLORWITHSAMEVALUE(255) forState:UIControlStateHighlighted];
            self.okButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BUTTON];
            //  self.otherButton.backgroundColor = COLORWITHSAMEVALUE(238);
            
            [self addSubview:self.okButton];
            
            [self.okButton setTitle:@"OK" forState:UIControlStateNormal];

        }else if (cancelButton ==NO && okButton == NO){
            
        }
    }
    
    return self;
}




-(void)show{
    
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    dimmingView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [keyWindow addSubview:dimmingView];
    
    [keyWindow addSubview:self];
    
    dimmingView.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        
        dimmingView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];

    if (type == LUAlertPopupStyleDropDown) {
        
        self.alpha = 0.0f;
        self.layer.transform = CATransform3DRotate(self.layer.transform, -M_PI/27.0, 0, 0, 1);
        
        [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.6f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.alpha = 1.0f;
            self.center = keyWindow.center;
            self.layer.transform = CATransform3DIdentity;
            
        } completion:NULL];
        
    }else{
        

    
    }
    

}

-(void)cancelButtonClicked:(UIButton *)sender{
    
    self.cancelButtonClickedBlock();
    [self dismiss];
    
}


-(void)okButtonClicked:(UIButton *)sender{
    
    self.okButtonClickedBlock();
    [self dismiss];
}



-(void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        dimmingView.alpha = 0.0f;
        self.alpha = 0.0f;
        self.center = CGPointMake(self.center.x, [UIScreen mainScreen].bounds.size.height + self.frame.size.height/2);
        self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI_4/8.0, 0, 0, 1);
        
    } completion:^(BOOL finished) {

        [self removeViews];
        
    }];

}

-(void)removeViews{
    [dimmingView removeFromSuperview];
    [self removeFromSuperview];
    dimmingView = nil;
}



@end
