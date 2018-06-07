//
//  LUStudentMainDrawingViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUDrawingViewController.h"
#import "LUDrawingCell.h"
@interface LUStudentMainDrawingViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createArtTopOffset;
@property (weak, nonatomic) IBOutlet UIView *createArtView;
@property (weak, nonatomic) IBOutlet UITextField *artName;
@property (weak, nonatomic) IBOutlet UITextField *artCategory;
@property (weak, nonatomic) IBOutlet UIButton *createArtBtn;
@property (strong, nonatomic)IBOutlet UICollectionView *DrawingCollection;


@end

