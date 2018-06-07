//
//  LUAssignmentCell.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUAssignmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assignmentTitle;
@property (weak, nonatomic) IBOutlet UILabel *assignmentAssignedTime;
@property (weak, nonatomic) IBOutlet UILabel *assignmentDescription;
@property (weak, nonatomic) IBOutlet UIImageView *submitted;
@property (weak, nonatomic) IBOutlet UIImageView *redo;
@property (weak, nonatomic) IBOutlet UIImageView *approved;
@property (weak, nonatomic) IBOutlet UIImageView *rejected;

@end
