//
//  LUShelfListViewController.h
//  LearningUmbrellaMaster
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"
#import "LUOperation.h"
#import "LUWriteNotesViewController.h"

@interface LUShelfListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentPickerDelegate,LUDelegate>

@property NSString *URL_link;
@property NSArray *resourceSubjectList;
@property NSArray *teacherDrawingList;
@property BOOL setResource;
@property BOOL setTeacherResource;
@property BOOL setTeacherDrawing;
@property NSString *resourceSubjectName,*classId,*subjectId;
@property NSString *header;
@property (weak, nonatomic) IBOutlet UILabel *HeaderLbl;

@property (weak, nonatomic) IBOutlet UIView *addResourceView;

@end

