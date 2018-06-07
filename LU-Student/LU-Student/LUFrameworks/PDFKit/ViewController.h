//
//	ViewController.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "Document.h"



@class ViewController;

@protocol ViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissViewController:(ViewController *)viewController;

@end

@class DrawingView;

@interface ViewController : UIViewController
{
}
@property (nonatomic, strong) DrawingView *drawingView;
@property (nonatomic , strong) UIColor *lineColor;
@property (nonatomic , strong) NSNumber *lineWidth;
@property (nonatomic , strong) NSNumber *lineAlpha;

@property (nonatomic, weak, readwrite) id <ViewControllerDelegate> delegate;

- (instancetype)initWithDocument:(Document *)object;

@end
