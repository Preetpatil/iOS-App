//
//  Annotation.h
//  KitDemo
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File;

@interface Annotation : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) File *file;

@end
