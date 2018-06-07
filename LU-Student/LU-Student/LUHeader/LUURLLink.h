
//  LUURLLink.h
//  LUStudent
//
//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#ifndef LUURLLink_h
#define LUURLLink_h

//TODO Remove all the Old links once New Links are added
#pragma mark New Links
#pragma mark Login
#define Login_link @"http://setumbrella.com/luservice/controller/api/adminController.php?Action=login"

#define Logout_Link @"http://setumbrella.com/luservice/controller/api/adminController.php?Action=logOut"

//@"http://setumbrella.com/luservice/controller/api/adminController.php?rquest=login"


#pragma mark -
#pragma mark Old Links
/*
 #define Login_link @"http://132.148.12.68/ios/profile/login.php"
 */

#define Assignment_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=StudentListingAssignment"
#define AssignmentSubmit_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=StudentSubmitAssignment"
#define Evaluation_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherReviewAssignment"
//#define Assignment_link @"http://setumbrella.com/learning_umbrella/assignment/new_assignment.php?school_id=13"

#define ExamList_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTestListing"
#define GetQuestions_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetQuestionListing"
//student exam submit
#define submitExam_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=SubmitTest"
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=SubmitTest

//#define ExamList_link @"http://setumbrella.com/learning_umbrella/onlinetest/test.php?school_id=13"

#define NotesList_link @"http://setumbrella.com/luservice/controller/api/demoController.php?Action=GetAllNotes"
#define NotesSubmit_link @"http://setumbrella.com/luservice/controller/api/demoController.php?Action=InsertNotes"
#define NotesSubjectList @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=NotesSubjectUnitDetails"
#define NotesCreateInput @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=NotesCategoryInsertDetails"

//#define NotesList_link  @"http://setumbrella.com/learning_umbrella/notes/notes_subject.php?school_id=13&class_id=2"

#define DrawingSubmit_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=insertDrawing"
#define ResourceLibrary_link @"http://setumbrella.com/luservice/controller/api/demoController.php?Action=GetAllResourceBank&ClassId=1"
//@"http://setumbrella.com/learning_umbrella/resource_bank/resource_bank.php?school_id=13&class_id=2"



//@"http://132.148.12.68/ios/assignment/assignment.php"
#define TextBook_link @"http://132.148.12.68/ios/books.php"
//@"http://132.148.12.68/ios/onlinetest/test.php"//@"http://132.148.12.68/ios/exam.php"

#define Coverpage_extra @"http://132.148.12.68/ios/notes/cover_page/Extra.jpg"
#define Coverpage_diary @"http://132.148.12.68/ios/notes/cover_page/diary.png"
#define Coverpage_rough @"http://132.148.12.68/ios/notes/cover_page/rough.jpg"
// For Message
#define Messages_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=ChatListStudent"
//#define Messages_Link @"http://setumbrella.com/learning_umbrella/chat/chat.php?school_id=13&student_id=3"
#define MessagesFetchChatHistory_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=ChatList"

//#define MessagesFetchChatHistory_Link @"http://setumbrella.com/learning_umbrella/chat/chat_receive.php"
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMessage
//http://setumbrella.com/learning_umbrella/chat/save_chat.php
#define MessagesSendChatMessage_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMessage"

// For Notification
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetNotificationListing
//http://setumbrella.com/learning_umbrella/notification/notification.php?school_id=13&student_id=3
#define Notification_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetNotificationListing"

#define NotificationIsRead_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=NotificationReadStatus"
//@"http://setumbrella.com/learning_umbrella/notification/status_update.php"

// For Email
#define EmailStudentTeacherList_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=MailListStudent"
//http://abc.setumbrella.com/learning_umbrella/email/email.php"
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=MailListStudent
#define EmailSaveMailToServer_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMail"
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMail
//http://abc.setumbrella.com/learning_umbrella/email/email.php

#define Timetable_Link  @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTimeTableByClassId"
//http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTimeTableByClassId&ClassId=1&SectionId=1
#define TodayTimeTable_Link  @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTodayTimeTableByClassId"
//"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTodayTimeTableByClassId&ClassId=1&SectionId=1&DayId=4

#define StudentLibrary_Link @"http://setumbrella.com/luservice/controller/api/libraryController.php?Action=GetViewBook&BookName=&SearchType=BookName"

#define FilterLibrary_Link @"http://setumbrella.com/luservice/controller/api/libraryController.php?Action=GetViewBook&BookName=java&SearchType=BookName"

#define Teacher_notification_list_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetNotificationListing"


#define Teacher_notificationIsRead_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=NotificationReadStatus&UserNotificationId=75"


// For Attendance
#define Student_attendance_details @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=AttendanceList"

#define Send_attendance @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=AttendanceStatus"



//For Teacher StudentList
#define Student_details @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=ListStudent"

//Assignment Links
#define Listing_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherListingAssignment"

#define Submit_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=SubmittedAssignment"

#define Add_assignment @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=insertTeacherAssignment"

#define Delete_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherDeleteAssignment"

#define Edit_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherEditAssignment"

#define Page_type_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetPageTypeListing"

#define Add_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=insertTeacherAssignment"


#define getAssignmentDetails @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherSubmittedStudentAssignmentList"

//Time table

#define Time_table @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTimeTableByTeacher"

#define Today_time_table @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTodayTimeTableByTeacher"
#define TodayTimeTable_Link  @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=GetTodayTimeTableByClassId"


//Teacher resource library
#define Teacher_resource_library @"http://setumbrella.com/luservice/controller/api/demoController.php?Action=TeacherAllResourceBank"
#define Teacher_resource_Post @"http://setumbrella.com/luservice/controller/api/demoController.php?Action=InsertResource"

//For Teacher Notification
#define Add_teacher_notification @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertNotification"

//For MessageTeacher

#define Message_teacher_list @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=ChatListTeacher"

#define Message_teacher_insert @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMessage"

#define Message_teacher_chatHistory @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=ChatList"



// teacher Email
//#define EmailTeacherList_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=MailListTeacher"
#define EmailTeacherList_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=MailListTeacher"
#define EmailSaveMailToServerTeacher_Link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=InsertMail"




//BD Sync

#define DBSync @"http://setumbrella.com/luservice/controller/api/adminController.php?Action=DbSync"


// teacher OnlineExam

#define ExamListTeacher_link @"http://setumbrella.com/luservice/controller/api/adminController.php?Action=GetTestListing"
#define CreateExamTeacher_link @"http://setumbrella.com/luservice/controller/api/teacherController.php?Action=AddTestDetails"
#define AddQuestionsTeacher_link @"http://setumbrella.com/luservice/controller/api/teacherController.php?Action=AddQuestionDetail"
#define EditExamteacher_link @"http://setumbrella.com/luservice/controller/api/teacherController.php?Action=ViewTestDetails"
#define AddQuestToQuestPaper_link @"http://setumbrella.com/luservice/controller/api/teacherController.php?Action=AddQuestion"

// teacher OnlineExam Review

#define ExamListReview_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TeacherTestListDetails"
#define ExamListStudentSubmitted_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=TestSubmitStudentList"
#define ExamAnswerScript_link @""
// teacher Drawing Links

#define DrawingCategoryList_link @"http://setumbrella.com/luservice/controller/api/studentController.php?Action=DrawingCategoryDetails"



#endif /* LUURLLink_h */



