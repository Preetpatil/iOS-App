//
//  LUStudentTextBookViewController.h
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ViewController.h"
//#import "LUHeader.h"
@interface LUStudentTextBookViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,NSURLSessionDownloadDelegate>
//LUDelegate
//ViewControllerDelegate
@property (weak, nonatomic) IBOutlet UICollectionView *ShelfCollection;

@end

