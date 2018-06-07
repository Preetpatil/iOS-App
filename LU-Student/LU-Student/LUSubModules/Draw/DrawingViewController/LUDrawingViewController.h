//
//  LUDrawingViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"
#import "LURulerView.h"
#import "DTColorPickerImageView.h"
#import "CGStretchView.h"
#import "NLImageCropperView.h"
#import "DrawingDataManager.h"

@class LUNotesDrawingView;
@interface LUDrawingViewController : UIViewController<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DTColorPickerImageViewDelegate,CGStretchViewDelegate,LUDelegate>
{
    NLImageCropperView* _imageCropper;
}


@property (strong, nonatomic) NSString *stdntID;
@property (strong, nonatomic) NSString *ClassID;

@property (strong, nonatomic) NSDictionary *profiledata;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FontStyleTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MoreTopOffset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EraserTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WriteToolTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorPickerTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clipArtTopOffset;



@property (weak, nonatomic) IBOutlet UIView *moreView;

@property (weak, nonatomic) IBOutlet UIView *textStyleView;
@property (weak, nonatomic) IBOutlet UIView *eraserView;
@property (weak, nonatomic) IBOutlet UIView *writeToolView;
@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
@property (weak, nonatomic) IBOutlet UIView *StdColorPickerView;
@property (weak, nonatomic) IBOutlet UIView *clipArtView;

@property (weak, nonatomic) IBOutlet LUNotesDrawingView *DrawingView;
@property (weak, nonatomic) IBOutlet UIView *DrawingViewBase;


@property (weak, nonatomic) IBOutlet UIView *viewForPreviewArt;


@property (weak, nonatomic) IBOutlet UIButton *undo;
@property (weak, nonatomic) IBOutlet UIButton *redo;

@property (weak, nonatomic) IBOutlet UISlider *writeSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *eraserSizeSlider;
@property (weak, nonatomic) IBOutlet UIPickerView *fontStyle;

@property (strong, nonatomic) UILongPressGestureRecognizer *lpRecognizer;
@property BOOL isAssignment;
@property NSString *DBName;
@property NSString *artName;
@property NSString*artCatagory;
@property NSData *artImage;
@property (weak, nonatomic) IBOutlet UILabel *timelbl;
@property (weak, nonatomic) IBOutlet UILabel *datelbl;


@end

