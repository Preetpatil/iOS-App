//
//  LUOperation.h
//  LUStudent
//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUURLLink.h"

//Protocol declaration for all the json parsing
@protocol LUDelegate<NSObject>

@optional
//-(void) loginUser: (NSDictionary *)userDetails; //For user profile details.
- (void) loginUser:(NSDictionary *)userDetails;
- (void) userLoggedOut:(NSArray *)userLogoutDetails;
- (void)errorLog:(NSString *)log;

- (void) assignmentList: (NSDictionary *)assignmentDetails; //For assignment list.
- (void) assignmentSubmit: (NSDictionary *)assignmentSubmitDetails;

- (void) noteList: (NSArray *)notesList; //For notesList for self display.

- (void) studentList: (NSDictionary *)studentListDict;

- (void) examList: (NSArray *)examlist;
- (void) examsubmit:(NSDictionary*)examsubmitDetails;

- (void) questionList: (NSArray *)questionlist;
- (void) regularQuestionList: (NSArray *)regularquestionlist;
- (void) returnOptionsAnswer: (NSDictionary *)answer;

- (void) resourceLibraryList: (NSArray *)resourcelibrarylist;


- (void) timeTableList: (NSDictionary *)timetablelist;
- (void) teachetTimeTableList: (NSArray *)timetablelist;
- (void) textBookList: (NSArray*)textbooklist;


//For Messages list.
-(void)messagesList:(NSDictionary *)messageDetails;
- (void) messagesChatHistoryList: (NSDictionary *) messagesChatHistoryDict;
- (void) messagesSendMessageResponse:(NSDictionary *) sendMessageResponseArray;

//- (void) messagesList: (NSArray *) messagesDetails;
//- (void) messagesChatHistoryList: (NSArray *) emailSavedMailDetails;
//- (void) messagesSendMessageResponse:(NSArray *) sendMessageResponseArray;

//For Notification list.
- (void) notificationList: (NSDictionary *) notificationDetails;
- (void) notificationIsReadList: (NSDictionary *) notificationDetails;

//For Email
- (void) emailStudentTeacherList: (NSDictionary *) emailStudentTeacherDetails; //For Email Student/Teacher list.
- (void) emailSavedMailToServerResponse: (NSDictionary *) emailSavedMailDetails; //For Email Save Mail to Server
//For StudentAttendance

- (void) studentAttendanceResponse: (NSDictionary *) attendanceDetails;

- (void) displayTodayTimetable: (NSArray *)todayTimeTable;
- (void) dockStudentList: (NSDictionary *)studentListDict;
- (void) todayTimetablelist: (NSDictionary *)todaytimetablelist;

//For Teacher Assignment
-(void) teacherAssignmentList: (NSDictionary*) teacherAssignmentListDict;
-(void)editAssignment:(NSDictionary *)editData;
-(void)submitAssignment: (NSDictionary *)submitAssignment;
-(void)deleteAssignment: (NSDictionary *)deleteAssignment;
-(void)getPagetype:(NSDictionary *)pageType;
-(void)fetchAssignmentDetails:(NSDictionary *)asID;


//library
-(void) StudentLibrarayList:(NSDictionary *) StudentLibrarayListDetail;
-(void) studentLibraryFilterList:(NSDictionary *) StudentLibraryFilterList;

/*
//teacher resource library
-(void)teacherResourcesLibraryList:(NSDictionary *)teachersResoureList;
-(void)postResource:(NSDictionary *)teachersResoureList;


///teacher email
- (void) emailTeacherList: (NSDictionary *) emailStudentTeacherDetails; //For Email Student/Teacher list.
- (void) emailSavedMailToServerResponse: (NSDictionary *) emailSavedMailDetails;

//Teacher Notes
- (void) notesSubjectList: (NSDictionary *) subjectlist;
-(void) notesCreateResponse: (NSDictionary *) createResponse;
-(void) notesCreateInputResponse: (NSDictionary *) createResponse;

-(void) teacherNotificationAdd: (NSDictionary *)teacherNotifactionDict;

//Teacher dbsync

-(void) dbSync:(NSDictionary *)syncData;

//Get page type
-(void)getPageresponse:(NSDictionary *)pageType;


//For Online Exam
- (void) createExam: (NSDictionary *)createExamDict;

- (void) ExamList: (NSDictionary *) examlistDict;
- (void) ExamReviewList: (NSDictionary *) examReviewListDict;
- (void) ExamStudentSubmittedList: (NSDictionary *) examStudentSubmittedDict;
- (void) addQuestionsForExam: (NSDictionary *)getQuestionDetailsDict;
- (void) addQuestionsToQuestPaper: (NSDictionary *)questToQuestPaperDict;

//For Drawing Teacher
- (void) listDrawingCategory: (NSDictionary *)drawingCategoryDict;
 */
@end

@interface LUOperation : NSObject
{
    //    LULoginModel *loginModel;
    NSDictionary *userProfileDetailsDictionary; //Holds complete details of the user.
    //  NSDictionary *userProfileDetails;
    NSArray *userLogoutDetails;
    
    NSDictionary *assisnmentListArray;  //Holds list of assignment.
    NSDictionary *assignmentSubmittedresponse;
    
    NSDictionary *studentListDict; //Holds list of students
    
    NSArray *noteListArray;  //Holds the list of notes.
    //for exam
    NSArray *examListArray;
    NSArray *questionListArray;
    NSDictionary*Examdictionry;
    
    NSDictionary *resourceLibraryListDict;
    
    NSDictionary *timeTableListArray;
    
    NSArray *teacherTimeTableListArray;
    
    NSArray *textBookListArray;
    //For Messages
    
    NSDictionary*messageListDict;
    NSDictionary*messagesChatHistoryDict;
    
    NSDictionary *messagesSendMessageDict;
    
    //student Library
    NSDictionary* StudentLibraryFilterDict;
    NSDictionary* StudentLibraryListDict;
    
    
    NSString *token;
    
    
    NSArray *messagesListArray; //For Messages list
    NSArray *messagesChatHistoryArray;
    NSArray *messagesSendMessageArray;
    
    
    // For Notification
    NSArray *notificationListArray; // For Notification list
    NSArray *notificationIsReadArray;
    NSDictionary *notificationDict;
    NSDictionary *notificationReadDict;
    NSDictionary *teacherNotifactionDict;//holds value of teacher notification
    NSDictionary *todaytimetable;
    
    
    //For Email
    NSArray *emailStudentTeacherListArray; // For Email Student/Teacher list
    NSArray *emailSavedMailToServerArray;
    NSDictionary*emailStudentTeacherListDict;
    NSDictionary*emailSavedMailToServerDict;
    NSDictionary*emailSavedMailToServerDictTeacher;
    NSArray *ClassSubjectData;
    
    //For Student
    NSDictionary *attendance;
}
@property (nonatomic,strong) NSDictionary *userProfileDetails;
@property (nonatomic,strong)id<LUDelegate>LUDelegateCall;

+ (LUOperation *) getSharedInstance;

//- (BOOL) loginStudentDetail: (NSString *) URL username :(NSString *) Username password :(NSString *) Password;
-(BOOL)userLoginWithURL:(NSString *)loginURL username:(NSString *)username password:(NSString *)password roleName:(NSString *)roleName DeviceId:(NSString *)devId;

- (BOOL)logoutUser:(NSString *)logoutURL;

#pragma mark
#pragma mark Assignment
- (BOOL) assignmentList: (NSString *) URL;
- (BOOL) assignmentSubmit: (NSDictionary *)body;

#pragma mark
#pragma mark Notes
- (BOOL) notesList: (NSString *) URL;
- (BOOL) notesSubmit: (NSDictionary *)body;

#pragma mark
#pragma mark Drawing
- (BOOL) drawingSubmit: (NSDictionary *)body;

#pragma mark
#pragma mark Online Exam
- (BOOL) examList: (NSString *) URL;
- (BOOL) questionList: (NSString *)URL;
- (BOOL) regularQuestionList: (NSString *)URL;
- (BOOL) examCall:(NSString *)url body:(NSDictionary *)body;
- (BOOL) returnOptionsAnswer:(NSDictionary *)answer;
-(BOOL) Examsubmit:(NSDictionary*)body;

#pragma mark
#pragma mark Resource library
- (BOOL) resourceLibraryList: (NSString *)URL body:(NSDictionary *)body;;


#pragma mark
#pragma mark Timetable
- (BOOL) timeTableList: (NSString *)URL;
-(BOOL) todaytimeTableList:(NSDictionary *)body;
-(BOOL) todaytimeTableList:(NSDictionary *)body;


#pragma mark
#pragma mark Textbook
- (BOOL) textBookList: (NSString *)URL;

#pragma mark
#pragma mark Messages
- (BOOL) messagesList: (NSString *) URL; //For Message list
- (BOOL) messagesChatHistoryList: (NSDictionary *)body;

- (BOOL) messagesfetchChatHistoryList: (NSString *) URL;////```````````
//- (BOOL) messagesSendChatMessage: (NSString *) URL;
- (BOOL) messagesSendChatMessage: (NSDictionary *)body;

#pragma mark
#pragma mark Notification
- (BOOL) notificationList: (NSString *) URL; // For Notification list
- (BOOL) notificationIsRead: (NSString *) URL;

#pragma mark
#pragma mark Email

- (BOOL) emailStudentTeacherList: (NSDictionary *) Body; //For Email Student/Teacher list
-(BOOL) emailSavedMailToServerResponse: (NSDictionary *) Body;




//- (BOOL) emailStudentTeacherList: (NSString *) URL; //For Email Student/Teacher list
//- (BOOL) emailSaveMailToServer: (NSString *) URL; // For Email

#pragma mark
#pragma mark Library
-(BOOL) StudentLibrarayList:(NSString*)URL;//for library detail list
-(BOOL) StudentLibraryFilterList:(NSString *)URL;




#pragma mark
#pragma mark TeacherAssignmentList
-(BOOL)LUTeacherAssignmentList:(NSString *)URL;
-(BOOL)LUTeacherAssignmentEdit:(NSString *)URL body:(NSDictionary *)body;
-(BOOL)LUTeacherAssignmentSubmit:(NSString *)URL body:(NSDictionary *)body;
-(BOOL)LUTeacherAssignmentDelete:(NSString *)URL body:(NSDictionary *)body;
-(BOOL)LUTeacherAssignmentPageType:(NSString *)URL;
-(BOOL)LUTeacherAssignmentGetDetails:(NSString *)URL body:(NSDictionary *)body;

#pragma mark
#pragma mark studentList
-(BOOL)studentList:(NSString *)url body:(NSDictionary *)body;



#pragma mark
#pragma mark Attendance
-(BOOL)studentAttendance:(NSString *)url body:(NSDictionary *)body;
#pragma mark
#pragma mark TimeTable
-(BOOL)teacherTimeTableList:(NSString *)URL;
#pragma mark
#pragma mark TodayTable
-(void)populateTodayTable:(NSString *)url dayNo:(NSString *)dayNo;


#pragma mark
#pragma mark TeacherResource
- (BOOL) teacherResourceLibraryList: (NSString *)URL;
-(BOOL)postResource:(NSString *)url body:(NSDictionary *)body
;

#pragma mark
#pragma mark TeacherEmail
- (BOOL) emailTeacherList: (NSDictionary *) Body; //For Email Student/Teacher list

- (BOOL) emailSavedMailToServerResponseTeacher:(NSDictionary *)Body;

#pragma mark
#pragma mark teacherNotification
-(BOOL)teacherNotificationAdd:(NSString *)url body:(NSDictionary *)body;


#pragma mark
#pragma mark DBSync

-(BOOL) syncMyDb:(NSString *)url body:(NSDictionary *)body;



#pragma mark
#pragma mark Notes Subject List
-(BOOL) notesSubjectList:(NSString *)url body:(NSDictionary *)body;
-(BOOL) notesCreateInput:(NSString *)url ;
-(BOOL) notesCreate:(NSString *)url body:(NSDictionary *)body;
-(BOOL) getPageType:(NSString *)url;






#pragma mark -
#pragma mark TeacherOnlineTest
- (BOOL) teacherExamList: (NSString *)URL; //For Teacher OnlineTeSt listing
- (BOOL) teacherCreateExam: (NSString *)url body:(NSDictionary *)body; //For creating exam
- (BOOL) teacherAddQuestions:(NSString *)url body:(NSDictionary *)body; //For adding questions to created exam
- (BOOL) teacherEditExam:(NSString *)url body:(NSDictionary *)body; //For editing created exam
- (BOOL) teacherReviewExamList: (NSString *)URL; //For Teacher Review OnlineTest listing
- (BOOL) teacherStudentSubmittedExam:(NSString *)url body:(NSDictionary *)body; //For viewing student submitted created exam
- (BOOL) teacherAddQuestToQuestPaper:(NSString *)url body:(NSDictionary *)body; //For adding questions to paper

#pragma mark -
#pragma mark TeacherDrawing
- (BOOL) teacherDrawingCategoryListing:(NSString *)url body:(NSDictionary *)body; //To list the categories of drawing the sudent submitted



@end
