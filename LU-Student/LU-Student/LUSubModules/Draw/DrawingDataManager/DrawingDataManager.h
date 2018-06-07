//
//  DrawingDataManager.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DrawingDataManager : NSObject
{
    NSString *DataBasePath;
}
+(DrawingDataManager*)getSharedInstance;
-(BOOL)createDrawingDB:(NSString*)DBName;
-(BOOL)saveDrawing:(NSString*)artName page:(NSData *)artImage catagory:(NSString *)artCatagory DB:(NSString *)DBName ;
-(BOOL)updateDrawing:(NSString*)artName page:(NSData*)artImage catagory:(NSString*)artCatagory DB:(NSString *)DBName;
-(NSArray*)viewAllArt:(NSString*)DBName;

@end




