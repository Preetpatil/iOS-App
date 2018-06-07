//
//	ThumbCache.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>

#import "ThumbRequest.h"

@interface ThumbCache : NSObject <NSObject>

+ (ThumbCache *)sharedInstance;

+ (void)touchThumbCacheWithGUID:(NSString *)guid;

+ (void)createThumbCacheWithGUID:(NSString *)guid;

+ (void)removeThumbCacheWithGUID:(NSString *)guid;

+ (void)purgeThumbCachesOlderThan:(NSTimeInterval)age;

+ (NSString *)thumbCachePathForGUID:(NSString *)guid;

- (id)thumbRequest:(ThumbRequest *)request priority:(BOOL)priority;

- (void)setObject:(UIImage *)image forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeNullForKey:(NSString *)key;

- (void)removeAllObjects;

@end
