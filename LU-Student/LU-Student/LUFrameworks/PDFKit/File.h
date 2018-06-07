//
//  File.h
//  KitDemo
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Annotation;

@interface File : NSManagedObject

@property (nonatomic, retain) NSDate * fileDate;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * pageCount;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSSet *annotation;
@end

@interface File (CoreDataGeneratedAccessors)

- (void)addAnnotationObject:(Annotation *)value;
- (void)removeAnnotationObject:(Annotation *)value;
- (void)addAnnotation:(NSSet *)values;
- (void)removeAnnotation:(NSSet *)values;

@end
