//
//  LUNotesMainDataManager.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUNotesMainDataManager.h"

static LUNotesMainDataManager *dbSharedInstance = nil;
static sqlite3 *dbDataBase  =  nil;
static sqlite3_stmt *dbStatement  =  nil;

@implementation LUNotesMainDataManager
+(LUNotesMainDataManager*)getSharedInstance
{
    if (!dbSharedInstance)
    {
        dbSharedInstance = [[super allocWithZone:NULL]init];
        //[NotesSharedInstance createNotesDB:dbName];
    }
    return dbSharedInstance;
}

/**
 <#Description#>

 @param dbName <#dbName description#>
 @return <#return value description#>
 */
-(BOOL)createDB:(NSString*)dbName
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths  =  NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir  =  dirPaths[0];
    DataBasePath  =  [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",dbName]]];
    NSLog(@"%@",docsDir);
    BOOL isSuccess  =  YES;
    NSFileManager *filemgr  =  [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:DataBasePath] == NO)
    {
        const char *dbpath = [DataBasePath UTF8String];
        if(sqlite3_open(dbpath, &dbDataBase) == SQLITE_OK)
        {
            char *errMsg;
            NSString *createSQL  =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (pageNo text primary key , pageImage BLOB)",dbName];
            const char *sql_stmt  =  [createSQL UTF8String];
            
            if (sqlite3_exec(dbDataBase, sql_stmt, NULL, NULL, &errMsg)!=  SQLITE_OK)
            {
                isSuccess  =  NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(dbDataBase);
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

/**
 <#Description#>

 @param dbName <#dbName description#>
 @param pageNo <#pageNo description#>
 @param pageImage <#pageImage description#>
 @return <#return value description#>
 */
-(BOOL)save:(NSString*)dbName pageno:(NSString*)pageNo pageimage:(NSData *)pageImage
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataBasePath UTF8String];
    if (sqlite3_open(dbpath, &dbDataBase)  ==  SQLITE_OK)
    {
        NSString *insertSQL  =  [NSString stringWithFormat:@"INSERT INTO %@ (pageNo,pageImage) VALUES (?, ?)",dbName];
        const char *insert_stmt  =  [insertSQL UTF8String];
        if( sqlite3_prepare_v2(dbDataBase, insert_stmt, -1, &dbStatement, NULL)  ==  SQLITE_OK )
        {
            sqlite3_bind_text(dbStatement, 1, [pageNo UTF8String ], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(dbStatement, 2, [pageImage bytes], (int)[pageImage length], SQLITE_TRANSIENT);
            sqlite3_step(dbStatement);
            
        }
        else
        {
            isSuccess = NO;
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dbDataBase) );
        }
        sqlite3_finalize(dbStatement);
        isSuccess = YES;
    }
    return isSuccess;
    
}

/**
 <#Description#>

 @param dbName <#dbName description#>
 @param pageNo <#pageNo description#>
 @param pageImage <#pageImage description#>
 @return <#return value description#>
 */
-(BOOL)update:(NSString*)dbName pageno:(NSString*)pageNo pageimage:(NSData *)pageImage
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataBasePath UTF8String];
    if(sqlite3_open(dbpath, &dbDataBase)  ==  SQLITE_OK)
    {
        NSString *updateQuery  =  [NSString stringWithFormat:@"UPDATE %@ SET pageImage = ? WHERE pageNo = ?",dbName];
        
        const char *update_stmt  =  [updateQuery UTF8String];
        if(sqlite3_prepare_v2(dbDataBase, update_stmt, -1, &dbStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_blob(dbStatement, 1, [pageImage bytes], (int)[pageImage length], SQLITE_TRANSIENT);
            sqlite3_bind_text(dbStatement, 2, [pageNo UTF8String ], -1, SQLITE_TRANSIENT);
        }
    }
    char* errmsg;
    sqlite3_exec(dbDataBase, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE !=  sqlite3_step(dbStatement))
    {
        isSuccess  =  NO;
        NSLog(@"Error while updating. %s", sqlite3_errmsg(dbDataBase));
    }
    else
    {
        isSuccess  =  YES;
        sqlite3_finalize(dbStatement);
        sqlite3_close(dbDataBase);
    }
    return isSuccess;
}


/**
 <#Description#>

 @param dbName <#dbName description#>
 @return <#return value description#>
 */
-(NSArray*)viewAllArt:(NSString*)dbName
{
    NSMutableArray *returnArray =  [[NSMutableArray alloc] init];
    NSMutableArray *DName  =  [[NSMutableArray alloc] init];
    NSMutableArray *DArt  =  [[NSMutableArray alloc] init];
    
    const char *utf8Dbpath  =  [DataBasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &dbDataBase)  ==  SQLITE_OK)
    {
        NSString *querySQL  =  [NSString stringWithFormat:@"select * from %@",dbName];
        const char *utf8QuerySQL  =  [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(dbDataBase, utf8QuerySQL, -1, &dbStatement, NULL)  ==  SQLITE_OK)
        {
            while (sqlite3_step(dbStatement)  ==  SQLITE_ROW)
            {
                char *dbDataAsChars  =  (char *)sqlite3_column_text(dbStatement,0);
                
                NSData *data  =  [[NSData alloc] initWithBytes:sqlite3_column_blob(dbStatement,1) length:sqlite3_column_bytes(dbStatement, 1)];
                
                [DName addObject:[NSString stringWithFormat:@"%s",dbDataAsChars]];
                [DArt addObject:data];
            }
            sqlite3_reset(dbStatement);
        }
        [returnArray addObject:DName];
        [returnArray addObject:DArt];
        
    }
    return returnArray;
}

@end
