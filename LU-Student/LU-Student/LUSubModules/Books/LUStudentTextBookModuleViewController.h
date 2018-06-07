//
//  LUStudentTextBookModuleViewController.h
//  LUStudent

//  Created by surabhi sharma on 17/05/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUStudentTextBookModuleViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *TextBookCollectionView;

@end
