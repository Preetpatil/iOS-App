//
//  LUMatchQuestionCell.h
//  LUStudent
//
//  Created by //  Created by Preeti Patil on 05/06/18. PM on 19/04/17.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUMatchQuestionCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *matchOption;
@property (weak, nonatomic) IBOutlet UITextField *matchingAnswer;

@property (weak, nonatomic) IBOutlet UILabel *matchQuestions;
@end
