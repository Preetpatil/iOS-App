//
//  LUOptionalQuestionDataManager.m
//  LUStudent

//  Created by Preeti Patil on 02/11/17.
//  Copyright © 2017 Set Infotech. All rights reserved.
//

#import "LUOptionalQuestionDataManager.h"


static  LUOptionalQuestionDataManager*DrawingSharedInstance = nil;
static sqlite3 * OptionalQuestionDataBase  =  nil;
static sqlite3_stmt *OptionalQuestionStatement  =  nil;

@implementation LUOptionalQuestionDataManager

+(LUOptionalQuestionDataManager*)getSharedInstance
{
    if (!DrawingSharedInstance)
    {
        DrawingSharedInstance = [[super allocWithZone:NULL]init];
        
    }
    return DrawingSharedInstance;
}


-(BOOL)createOptinalQuestionDB:(NSString*)DBName
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
        if(sqlite3_open(dbpath, &OptionalQuestionDataBase ) == SQLITE_OK)
        {
            char *errMsg;
            
            NSString *createSQL  =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (QNo text primary key , QuestionType Text , OptionSelect text)",DBName];
            
            const char *sql_stmt  =  [createSQL UTF8String];
            
            
            if (sqlite3_exec(OptionalQuestionDataBase , sql_stmt, NULL, NULL, &errMsg)
                !=  SQLITE_OK)
            {
                isSuccess  =  NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(OptionalQuestionDataBase );
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



-(BOOL)saveOptinalQusetion:(NSString*)QNo Qusetion:(NSString *)QuestionType Options:(NSString *)OptionSelect DB:(NSString *)DBName ;
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataPath UTF8String];
    if (sqlite3_open(dbpath, &OptionalQuestionDataBase)  ==  SQLITE_OK)
    {
        NSString *insertSQL  =  [NSString stringWithFormat:@"INSERT INTO %@ (QNo,QuestionType,OptionSelect) VALUES (?, ?, ?)",DBName];
        
        const char *insert_stmt  =  [insertSQL UTF8String];
        
        if( sqlite3_prepare_v2(OptionalQuestionDataBase, insert_stmt, -1, &OptionalQuestionStatement, NULL)  ==  SQLITE_OK )
        {
            sqlite3_bind_text(OptionalQuestionStatement, 1, [QNo UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(OptionalQuestionStatement, 2, [QuestionType UTF8String ], -1, SQLITE_TRANSIENT);
            
            
            sqlite3_bind_text(OptionalQuestionStatement, 3, [OptionSelect UTF8String ], -1, SQLITE_TRANSIENT);
            
            
            sqlite3_step(OptionalQuestionStatement);
        }
        else
        {
            isSuccess = NO;
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(OptionalQuestionDataBase) );
        }
        sqlite3_finalize(OptionalQuestionStatement);
        isSuccess = YES;
    }
    return isSuccess;
}



-(BOOL)updateOptinalQusetion:(NSString*)QNo Qusetion:(NSString *)QuestionType  Options:(NSString *)OptionSelect DB:(NSString *)DBName;
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataPath UTF8String];
    if(sqlite3_open(dbpath, &OptionalQuestionDataBase)  ==  SQLITE_OK)
    {
        NSString *updateQuery  =  [NSString stringWithFormat:@"UPDATE %@ SET QuestionType = ? , OptionSelect = ? WHERE  QNo = ?",DBName];

        const char *update_stmt  =  [updateQuery UTF8String];
        if(sqlite3_prepare_v2(OptionalQuestionDataBase, update_stmt, -1, &OptionalQuestionStatement, NULL) == SQLITE_OK)
        {

             sqlite3_bind_text(OptionalQuestionStatement, 1, [QuestionType UTF8String ], -1, SQLITE_TRANSIENT);


            sqlite3_bind_text(OptionalQuestionStatement, 2, [OptionSelect UTF8String ], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(OptionalQuestionStatement, 3, [QNo UTF8String ], -1, SQLITE_TRANSIENT);
        }
    }
    char* errmsg;
    sqlite3_exec(OptionalQuestionDataBase, "COMMIT", NULL, NULL, &errmsg);

    if(SQLITE_DONE !=  sqlite3_step(OptionalQuestionStatement))
    {
        isSuccess  =  NO;
        NSLog(@"Error while updating. %s", sqlite3_errmsg(OptionalQuestionDataBase));

    }
    else
    {
        isSuccess  =  YES;
        sqlite3_finalize(OptionalQuestionStatement);
        sqlite3_close(OptionalQuestionDataBase);
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
//-(NSArray*)viewAllArt:(NSString*)DBName
//{
//    NSMutableArray *returnArray =  [[NSMutableArray alloc] init];
//    NSMutableArray *DName  =  [[NSMutableArray alloc] init];
//    NSMutableArray *DArt  =  [[NSMutableArray alloc] init];
//    NSMutableArray*Dcatagory=[[NSMutableArray alloc]init];
//
//    const char *utf8Dbpath  =  [DataBasePath UTF8String];
//
//    if (sqlite3_open(utf8Dbpath, &DrawingDataBase)  ==  SQLITE_OK)
//    {
//
//        NSString *querySQL  =  [NSString stringWithFormat:@"select * from %@",DBName];
//
//        const char *utf8QuerySQL  =  [querySQL UTF8String];
//
//        if (sqlite3_prepare_v2(DrawingDataBase, utf8QuerySQL, -1, &DrawingStatement, NULL)  ==  SQLITE_OK)
//        {
//            while (sqlite3_step(DrawingStatement)  ==  SQLITE_ROW)
//            {
//                char *dbDataAsChars  =  (char *)sqlite3_column_text(DrawingStatement,0);
//
//                NSData *data  =  [[NSData alloc] initWithBytes:sqlite3_column_blob(DrawingStatement,1) length:sqlite3_column_bytes(DrawingStatement, 1)];
//
//                char *DbData =(char*)sqlite3_column_text(DrawingStatement,2);
//
//                [DName addObject:[NSString stringWithFormat:@"%s",dbDataAsChars]];
//                [DArt addObject:data];
//                [Dcatagory addObject:[NSString stringWithFormat:@"%s",DbData]];
//            }
//
//            sqlite3_reset(DrawingStatement);
//        }
//        [returnArray addObject:DName];
//        [returnArray addObject:DArt];
//        [returnArray addObject:Dcatagory];
//    }
//    return returnArray;
//}


@end
