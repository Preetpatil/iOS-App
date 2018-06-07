//
//	DocumentOutline.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <Foundation/Foundation.h>

@interface DocumentOutline : NSObject <NSObject>

+ (NSArray *)outlineFromFileURL:(NSURL *)fileURL password:(NSString *)phrase;

+ (void)logDocumentOutlineArray:(NSArray *)array;

@end

@interface DocumentOutlineEntry : NSObject <NSObject>

+ (instancetype)newWithTitle:(NSString *)title target:(id)target level:(NSInteger)level;

@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, strong, readwrite) NSMutableArray *children;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) id target;

@end
