//
//	Document.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <Foundation/Foundation.h>

@interface Document : NSObject <NSObject, NSCoding>

@property (nonatomic, strong, readonly) NSString *guid;
@property (nonatomic, strong, readonly) NSDate *fileDate;
@property (nonatomic, strong, readwrite) NSDate *lastOpen;
@property (nonatomic, strong, readonly) NSNumber *fileSize;
@property (nonatomic, strong, readonly) NSNumber *pageCount;
@property (nonatomic, strong, readwrite) NSNumber *pageNumber;
@property (nonatomic, strong, readonly) NSMutableIndexSet *bookmarks;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSURL *fileURL;
@property (nonatomic, strong, readwrite) NSString *filePath;

@property (nonatomic, readonly) BOOL canEmail;
@property (nonatomic, readonly) BOOL canExport;
@property (nonatomic, readonly) BOOL canPrint;

+ (Document *)withDocumentFilePath:(NSString *)filePath password:(NSString *)phrase;

+ (Document *)unarchiveFromFileName:(NSString *)filePath password:(NSString *)phrase;

- (instancetype)initWithFilePath:(NSString *)filePath password:(NSString *)phrase;

- (BOOL)archiveDocumentProperties;

- (void)updateDocumentProperties;

@end
