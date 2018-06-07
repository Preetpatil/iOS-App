//
//  LUStudentOnlineExamViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//


#import "LUHeader.h"

@interface LUStudentOnlineExamViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,LUDelegate>
{
    UICollectionView *collectionView;
}
@property (weak, nonatomic) IBOutlet UIView *collectionViewBase;
@property (weak, nonatomic) IBOutlet UIView *tableViewBase;
@property (weak, nonatomic) IBOutlet UILabel *Month;
@property (weak, nonatomic) IBOutlet UIButton *prevMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;
@property (retain, nonatomic) IBOutlet UICollectionView *calendar;
@property NSString*exam_Id;
@property NSMutableString*string;
@property (retain, nonatomic) UITableView *examList;
@property (weak, nonatomic)  UILabel *date;
@end

