//
//  DataManager.h
//  KitDemo
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "File.h"
#import "Annotation.h"

@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataManager *)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)addAnnotation:(NSMutableDictionary *)annDict;
- (File *)getFileByPath:(NSString *)filePath;
- (Annotation *)getAnnotation:(NSString *)filePath withPage:(NSNumber *)page;
- (UIImage *)getAnnotationImage:(NSString *)filePath withPage:(NSNumber *)page;
- (void)deleteFileByPath:(NSString *)filePath;
@end
