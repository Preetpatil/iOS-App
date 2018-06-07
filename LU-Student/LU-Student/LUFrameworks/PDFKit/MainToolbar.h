//
//	MainToolbar.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#import "UIXToolbarView.h"

@class MainToolbar;
@class Document;

@protocol MainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(MainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(MainToolbar *)toolbar thumbsButton:(UIButton *)button;
- (void)tappedInToolbar:(MainToolbar *)toolbar exportButton:(UIButton *)button;
- (void)tappedInToolbar:(MainToolbar *)toolbar printButton:(UIButton *)button;
- (void)tappedInToolbar:(MainToolbar *)toolbar emailButton:(UIButton *)button;
- (void)tappedInToolbar:(MainToolbar *)toolbar markButton:(UIButton *)button;

@end

@interface MainToolbar : UIXToolbarView

@property (nonatomic, weak, readwrite) id <MainToolbarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(Document *)document;

- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;

@end
