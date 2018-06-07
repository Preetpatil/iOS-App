//
//  LUExamDataManager.m
//  LUStudent

//  Created by Preeti Patil on 03/11/17.
//  Copyright © 2017 Set Infotech. All rights reserved.
//

#import "LUExamDataManager.h"

static  LUExamDataManager* ExamSharedinstance = nil;
static sqlite3 *ExamDataBase  =  nil;
static sqlite3_stmt *ExamStatement  =  nil;


@implementation LUExamDataManager

+(LUExamDataManager*)getSharedInstance
{
    if (!ExamSharedinstance)
    {
        ExamSharedinstance = [[super allocWithZone:NULL]init];
        
    }
    return ExamSharedinstance;
}

-(BOOL)createExamDB:(NSString*)DBName
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths  =  NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir  =  dirPaths[0];
    DataPath  =  [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",DBName]]];
    NSLog(@"%@",docsDir);
    BOOL isSuccess  =  YES;
    NSFileManager *filemgr  =  [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:DataPath] == NO)
    {
        const char *dbpath = [DataPath UTF8String];
        if(sqlite3_open(dbpath, &ExamDataBase ) == SQLITE_OK)
        {
            char *errMsg;
            //(NSString*)QNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage pageno:(NSString *)PageNo DB:(NSString *)DBName
            NSString *createSQL  =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (PageNo text primary key , QuestionTypeID Text  ,QuestionTypeName Text,QuestionID Text, CorrectOption Text,PageImage BLOB, QNo Text)",DBName];
            
            const char *sql_stmt  =  [createSQL UTF8String];
            
            
            if (sqlite3_exec(ExamDataBase , sql_stmt, NULL, NULL, &errMsg)
                !=  SQLITE_OK)
            {
                isSuccess  =  NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(ExamDataBase );
            return  isSuccess;
        }
        else
        {
            isSuccess  =  NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)saveExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName 
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataPath UTF8String];
    if (sqlite3_open(dbpath, &ExamDataBase)  ==  SQLITE_OK)
    {
        NSString *insertSQL  =  [NSString stringWithFormat:@"INSERT INTO %@ (PageNo,QuestionTypeID, QuestionTypeName,QuestionID,CorrectOption,PageImage,QNo) VALUES (?, ?, ?, ?, ?, ?, ?)",DBName];
        
        const char *insert_stmt  =  [insertSQL UTF8String];
        
        if( sqlite3_prepare_v2(ExamDataBase, insert_stmt, -1, &ExamStatement, NULL)  ==  SQLITE_OK )
        {
            sqlite3_bind_text(ExamStatement, 1, [PageNo UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 2, [QuestionTypeID UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 3, [QuestionTypeName UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 4, [QuestionID UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 5, [CorrectOption UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_blob(ExamStatement, 6, [PageImage bytes], (int)[PageImage length], SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 7, [QNo UTF8String ], -1, SQLITE_TRANSIENT);
            
            
            
            
            sqlite3_step(ExamStatement);
        }
        else
        {
            isSuccess = NO;
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(ExamDataBase) );
        }
        sqlite3_finalize(ExamStatement);
        isSuccess = YES;
    }
    return isSuccess;
}

//(NSString*)QNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage pageno:(NSString *)PageNo DB:(NSString *)DBName

-(BOOL)updateExamDB:(NSString*)PageNo QusetiontypeId:(NSString *)QuestionTypeID QusetiontypeName:(NSString *)QuestionTypeName QusetionId:(NSString *)QuestionID Correctoption:(NSString *)CorrectOption Pageimage:(NSData *)PageImage questionno:(NSString *)QNo DB:(NSString *)DBName  


{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataPath UTF8String];
    if(sqlite3_open(dbpath, &ExamDataBase)  ==  SQLITE_OK)
    {
        NSString *updateQuery  =  [NSString stringWithFormat:@"UPDATE %@ SET QuestionTypeID = ? , QuestionTypeName = ? , QuestionID = ?, CorrectOption = ?, PageImage = ?, QNo = ? WHERE  PageNo = ?",DBName];
        
        const char *update_stmt  =  [updateQuery UTF8String];
        if(sqlite3_prepare_v2(ExamDataBase, update_stmt, -1, &ExamStatement, NULL) == SQLITE_OK)
        {
            
            
            
            sqlite3_bind_text(ExamStatement, 1, [QuestionTypeID UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 2, [QuestionTypeName UTF8String ], -1, SQLITE_TRANSIENT);
            
             sqlite3_bind_text(ExamStatement, 3, [QuestionID UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 4, [CorrectOption UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_blob(ExamStatement, 5, [PageImage bytes], (int)[PageImage length], SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 6, [QNo UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(ExamStatement, 7, [PageNo UTF8String ], -1, SQLITE_TRANSIENT);
            
            
        }
    }
    char* errmsg;
    sqlite3_exec(ExamDataBase, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE !=  sqlite3_step(ExamStatement))
    {
        isSuccess  =  NO;
        NSLog(@"Error while updating. %s", sqlite3_errmsg(ExamDataBase));
        
    }
    else
    {
        isSuccess  =  YES;
        sqlite3_finalize(ExamStatement);
        sqlite3_close(ExamDataBase);
    }
    return isSuccess;
}
//
//
///**
// <#Description#>
//
// @param DBName <#DBName description#>
// @return <#return value description#>
// */
-(NSArray*)ShowAllExam:(NSString*)DBName qno:(NSString *)qNo
{
    
    NSMutableArray *returnArray =  [[NSMutableArray alloc] init];
    NSMutableArray *page_no  =  [[NSMutableArray alloc] init];
    NSMutableArray *Qtype_id  =  [[NSMutableArray alloc] init];
    NSMutableArray*Qtype_name =[[NSMutableArray alloc]init];
    NSMutableArray*QId =[[NSMutableArray alloc]init];
    NSMutableArray*Correct_Option =[[NSMutableArray alloc]init];
    NSMutableArray*Page_image =[[NSMutableArray alloc]init];
    NSMutableArray*Qno =[[NSMutableArray alloc]init];
    

    const char *utf8Dbpath  =  [DataPath UTF8String];

    if (sqlite3_open(utf8Dbpath, &ExamDataBase)  ==  SQLITE_OK)
    {
                                                          //SELECT * FROM Customers WHERE City= 'Berlin';
        NSString *querySQL  =  [NSString stringWithFormat:@"select * from %@ where QNo= '%@'",DBName,qNo];

        const char *utf8QuerySQL  =  [querySQL UTF8String];
        // sqlite3_bind_text(ExamStatement, 7, [qNo UTF8String ], -1, SQLITE_TRANSIENT);
        if (sqlite3_prepare_v2(ExamDataBase, utf8QuerySQL, -1, &ExamStatement, NULL)  ==  SQLITE_OK)
        {
           
            
            while (sqlite3_step(ExamStatement)  ==  SQLITE_ROW)
            {
               
                char *DbpageNo =  (char *)sqlite3_column_text(ExamStatement,0);
                
                char *dbquestionTypeID  =  (char *)sqlite3_column_text(ExamStatement,1);

                char *dbquestiontypeName  =  (char *)sqlite3_column_text(ExamStatement,2);

                char *dbquestionID  =  (char *)sqlite3_column_text(ExamStatement,3);

                char *dbcorrectOption  =  (char *)sqlite3_column_text(ExamStatement,4);

                

                NSData *data  =  [[NSData alloc] initWithBytes:sqlite3_column_blob(ExamStatement,5) length:sqlite3_column_bytes(ExamStatement, 5)];

                char *dbquestionNo  =(char*)sqlite3_column_text(ExamStatement,6);
                [page_no addObject:[NSString stringWithFormat:@"%s",DbpageNo]];
                
                [Qtype_id addObject:[NSString stringWithFormat:@"%s",dbquestionTypeID]];
                [Qtype_name addObject:[NSString stringWithFormat:@"%s",dbquestiontypeName]];
                [QId addObject:[NSString stringWithFormat:@"%s",dbquestionID]];
                [Correct_Option addObject:[NSString stringWithFormat:@"%s",dbcorrectOption]];
                [Page_image addObject:data];
                [Qno addObject:[NSString stringWithFormat:@"%s",dbquestionNo]];
            }

            sqlite3_reset(ExamStatement);
        }
        [returnArray addObject:page_no];
        [returnArray addObject:Qtype_id];
        [returnArray addObject:Qtype_name];
        [returnArray addObject:QId];
        [returnArray addObject:Correct_Option];
        [returnArray addObject:Page_image];
        [returnArray addObject:Qno];
        
    }
    return returnArray;
}




@end
