//
//  DrawingDataManager.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "DrawingDataManager.h"
static DrawingDataManager *DrawingSharedInstance = nil;
static sqlite3 *DrawingDataBase  =  nil;
static sqlite3_stmt *DrawingStatement  =  nil;

@implementation DrawingDataManager

+(DrawingDataManager*)getSharedInstance
{
    if (!DrawingSharedInstance)
    {
        DrawingSharedInstance = [[super allocWithZone:NULL]init];
        
    }
    return DrawingSharedInstance;
}

/**
 <#Description#>

 @param DBName <#DBName description#>
 @return <#return value description#>
 */
-(BOOL)createDrawingDB:(NSString*)DBName
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths  =  NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir  =  dirPaths[0];
    DataBasePath  =  [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",DBName]]];
    NSLog(@"%@",docsDir);
    BOOL isSuccess  =  YES;
    NSFileManager *filemgr  =  [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:DataBasePath] == NO)
    {
        const char *dbpath = [DataBasePath UTF8String];
        if(sqlite3_open(dbpath, &DrawingDataBase) == SQLITE_OK)
        {
            char *errMsg;
            
            NSString *createSQL  =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (artName text primary key , artImage BLOB , artCatagory text)",DBName];
            
            const char *sql_stmt  =  [createSQL UTF8String];
            
            // const char *sql_stmt  =
            // "CREATE TABLE IF NOT EXISTS Drawing (artName text primary key , artImage BLOB)";
            if (sqlite3_exec(DrawingDataBase, sql_stmt, NULL, NULL, &errMsg)
                !=  SQLITE_OK)
            {
                isSuccess  =  NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(DrawingDataBase);
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
 
 @param artName <#artName description#>
 @param artImage <#artImage description#>
 @param DBName <#DBName description#>
 @return <#return value description#>
 */
-(BOOL)saveDrawing:(NSString*)artName page:(NSData *)artImage catagory:(NSString *)artCatagory DB:(NSString *)DBName
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataBasePath UTF8String];
    if (sqlite3_open(dbpath, &DrawingDataBase)  ==  SQLITE_OK)
    {
        NSString *insertSQL  =  [NSString stringWithFormat:@"INSERT INTO %@ (artName,artImage,artCatagory) VALUES (?, ?, ?)",DBName];
        
        const char *insert_stmt  =  [insertSQL UTF8String];
        
        if( sqlite3_prepare_v2(DrawingDataBase, insert_stmt, -1, &DrawingStatement, NULL)  ==  SQLITE_OK )
        {
            sqlite3_bind_text(DrawingStatement, 1, [artName UTF8String ], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_blob(DrawingStatement, 2, [artImage bytes], (int)[artImage length], SQLITE_TRANSIENT);
            
            
            sqlite3_bind_text(DrawingStatement, 3, [artCatagory UTF8String ], -1, SQLITE_TRANSIENT);
            
            
            sqlite3_step(DrawingStatement);
        }
        else
        {
            isSuccess = NO;
            NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(DrawingDataBase) );
        }
        sqlite3_finalize(DrawingStatement);
        isSuccess = YES;
    }
    return isSuccess;
}


/**
 <#Description#>
 
 @param artName <#artName description#>
 @param artImage <#artImage description#>
 @param DBName <#DBName description#>
 @return <#return value description#>
 */
-(BOOL)updateDrawing:(NSString*)artName page:(NSData*)artImage catagory:(NSString*)artCatagory DB:(NSString *)DBName
{
    BOOL isSuccess  =  YES;
    const char *dbpath  =  [DataBasePath UTF8String];
    if(sqlite3_open(dbpath, &DrawingDataBase)  ==  SQLITE_OK)
    {
        NSString *updateQuery  =  [NSString stringWithFormat:@"UPDATE %@ SET  artImage = ? , artCatagory = ? WHERE  artName = ?",DBName];
        
        const char *update_stmt  =  [updateQuery UTF8String];
        if(sqlite3_prepare_v2(DrawingDataBase, update_stmt, -1, &DrawingStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_blob(DrawingStatement, 1, [artImage bytes], (int)[artImage length], SQLITE_TRANSIENT);
            
            
            sqlite3_bind_text(DrawingStatement, 2, [artCatagory UTF8String ], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(DrawingStatement, 3, [artName UTF8String ], -1, SQLITE_TRANSIENT);
        }
    }
    char* errmsg;
    sqlite3_exec(DrawingDataBase, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE !=  sqlite3_step(DrawingStatement))
    {
        isSuccess  =  NO;
        NSLog(@"Error while updating. %s", sqlite3_errmsg(DrawingDataBase));
        
    }
    else
    {
        isSuccess  =  YES;
        sqlite3_finalize(DrawingStatement);
        sqlite3_close(DrawingDataBase);
    }
    return isSuccess;
}


/**
 <#Description#>
 
 @param DBName <#DBName description#>
 @return <#return value description#>
 */
-(NSArray*)viewAllArt:(NSString*)DBName
{
    NSMutableArray *returnArray =  [[NSMutableArray alloc] init];
    NSMutableArray *DName  =  [[NSMutableArray alloc] init];
    NSMutableArray *DArt  =  [[NSMutableArray alloc] init];
    NSMutableArray*Dcatagory=[[NSMutableArray alloc]init];
    
    const char *utf8Dbpath  =  [DataBasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &DrawingDataBase)  ==  SQLITE_OK)
    {
        
        NSString *querySQL  =  [NSString stringWithFormat:@"select * from %@",DBName];
        
        const char *utf8QuerySQL  =  [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(DrawingDataBase, utf8QuerySQL, -1, &DrawingStatement, NULL)  ==  SQLITE_OK)
        {
            while (sqlite3_step(DrawingStatement)  ==  SQLITE_ROW)
            {
                char *dbDataAsChars  =  (char *)sqlite3_column_text(DrawingStatement,0);
                
                NSData *data  =  [[NSData alloc] initWithBytes:sqlite3_column_blob(DrawingStatement,1) length:sqlite3_column_bytes(DrawingStatement, 1)];
                
                char *DbData =(char*)sqlite3_column_text(DrawingStatement,2);
                
                [DName addObject:[NSString stringWithFormat:@"%s",dbDataAsChars]];
                [DArt addObject:data];
                [Dcatagory addObject:[NSString stringWithFormat:@"%s",DbData]];
            }
            
            sqlite3_reset(DrawingStatement);
        }
        [returnArray addObject:DName];
        [returnArray addObject:DArt];
        [returnArray addObject:Dcatagory];
    }
    return returnArray;
}

@end
