//
//  WriteViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUHeader.h"
#import "LUPageType.h"
#import "LURulerView.h"
#import "CGStretchView.h"
#import <CoreData/CoreData.h>
@class LUNotesDrawingView;
@interface LUWriteNotesViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,CGStretchViewDelegate,LUDelegate>
@property(nonatomic,strong)UIImageView *ruler;

@property (weak, nonatomic) IBOutlet LUPageType *PageType_view;

@property (weak, nonatomic) IBOutlet UIView *writeBaseView;

@property (weak, nonatomic) IBOutlet LUNotesDrawingView *DrawView;

@property (weak, nonatomic) IBOutlet UIImageView *previewWrite;

@property (weak, nonatomic) IBOutlet UIButton *undo;
@property (weak, nonatomic) IBOutlet UIButton *redo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topoffset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorPickerTopOffet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insertImageTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InsertImageViewTopOffset;

@property (weak, nonatomic) IBOutlet UILabel *PreviewColor;


@property (weak, nonatomic) IBOutlet UIView *WriteToolSelectView;
@property (weak, nonatomic) IBOutlet UIView *correctionWriteToolSelectView;
@property (weak, nonatomic) IBOutlet UIView *ColorPickerView;
@property (weak, nonatomic) IBOutlet UIView *insertImageView;
@property (weak, nonatomic) IBOutlet UIView *thumbnailView;

@property (weak, nonatomic) IBOutlet UIView *InsertImageThumbnailView;


@property (weak, nonatomic) IBOutlet UILabel *PageNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *TimeDateStamp;


@property (weak, nonatomic) IBOutlet UIView *previewNotesView;
@property (weak, nonatomic) IBOutlet UIImageView *previewNotesImage;
@property (weak, nonatomic) IBOutlet UILabel *previewSubject_Name;
@property (weak, nonatomic) IBOutlet UILabel *previewUnit_No;
@property (weak, nonatomic) IBOutlet UILabel *previewUnit_name;


@property (weak, nonatomic) IBOutlet UILabel *DiaryDay;
@property (weak, nonatomic) IBOutlet UILabel *DiaryMonth;
@property (weak, nonatomic) IBOutlet UILabel *DiaryWeek;
@property (weak, nonatomic) IBOutlet UILabel *DiaryYear;


//exam
@property BOOL isExam;
@property BOOL isCorrection;
@property BOOL isAssignment;
@property BOOL isTeacherAssignment;
@property BOOL isTeacherNotes;

@property (weak, nonatomic) IBOutlet UIView *examQuestionView;

@property (weak, nonatomic) IBOutlet UILabel *qNo;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) NSArray *fillQuestions;
@property NSString *ExamQuestionNo;
@property NSString *ExamQuestion;
@property NSString*QuestionType;
@property NSString*QuestionType_Id;
@property NSString*QuestionType_Name;
@property NSString*Question_Id;
@property NSString*correctoption;
@property NSString*pageimage;
@property NSString*pageno;
@property NSString*DBname;


@property (weak, nonatomic) IBOutlet UIView *examViewBase;
@property (weak, nonatomic) IBOutlet UITableView *fillTable;





@property (weak, nonatomic) IBOutlet UIButton *prevBtn;

@property (weak, nonatomic) IBOutlet UIButton *nxtBtn;



@property (weak, nonatomic) IBOutlet UIView *evaluationView;



@property NSString *FlashCoverImage;
@property NSString *FlashSubjectName;
@property NSString *FlashUniteNo;
@property NSString *FlashUniteName;
@property NSString *FlashPageType;

@property NSString *moduleName;
@property NSString *subjectCategoryId;
@property NSString *studentId;
@property NSString *teacherId;
@property NSString *studentClassId;
@property NSString *studentSectionId;

@property  int tempsecondsLeft;

@end
