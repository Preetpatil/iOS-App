//
//	ThumbQueue.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <Foundation/Foundation.h>

@interface ThumbQueue : NSObject <NSObject>

+ (ThumbQueue *)sharedInstance;

- (void)addLoadOperation:(NSOperation *)operation;

- (void)addWorkOperation:(NSOperation *)operation;

- (void)cancelOperationsWithGUID:(NSString *)guid;

- (void)cancelAllOperations;

@end

#pragma mark -

//
//	ThumbOperation class interface
//

@interface ThumbOperation : NSOperation

@property (nonatomic, strong, readonly) NSString *guid;

- (instancetype)initWithGUID:(NSString *)guid;

@end
