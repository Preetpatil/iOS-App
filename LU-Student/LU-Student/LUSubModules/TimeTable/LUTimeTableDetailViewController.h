//
//  LUTimeTableDetailViewController.h
//  LUStudent

//  Created by Preeti Patil on 10/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataDelegate <NSObject>
@required
- (void)passData:(NSString *)data;

@end
@interface LUTimeTableDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) id<DataDelegate> delegatemethod;

@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property NSArray *detailArray;
@property NSString*data;
@end
