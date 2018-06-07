//
//	ThumbQueue.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "ThumbQueue.h"

@implementation ThumbQueue
{
	NSOperationQueue *loadQueue;

	NSOperationQueue *workQueue;
}

#pragma mark - ThumbQueue class methods

+ (ThumbQueue *)sharedInstance
{
	static dispatch_once_t predicate  =  0;

	static ThumbQueue *object  =  nil; // Object

	dispatch_once(&predicate, ^{ object  =  [self new]; });

	return object; // ThumbQueue singleton
}

#pragma mark - ThumbQueue instance methods

- (instancetype)init
{
	if ((self  =  [super init])) // Initialize
	{
		loadQueue  =  [NSOperationQueue new];

		[loadQueue setName:@"ThumbLoadQueue"];

		[loadQueue setMaxConcurrentOperationCount:1];

		workQueue  =  [NSOperationQueue new];

		[workQueue setName:@"ThumbWorkQueue"];

		[workQueue setMaxConcurrentOperationCount:1];
	}

	return self;
}

- (void)addLoadOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[ThumbOperation class]])
	{
		[loadQueue addOperation:operation]; // Add to load queue
	}
}

- (void)addWorkOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[ThumbOperation class]])
	{
		[workQueue addOperation:operation]; // Add to work queue
	}
}

- (void)cancelOperationsWithGUID:(NSString *)guid
{
	[loadQueue setSuspended:YES]; [workQueue setSuspended:YES];

	for (ThumbOperation *operation in loadQueue.operations)
	{
		if ([operation isKindOfClass:[ThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	for (ThumbOperation *operation in workQueue.operations)
	{
		if ([operation isKindOfClass:[ThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	[workQueue setSuspended:NO]; [loadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
	[loadQueue cancelAllOperations]; [workQueue cancelAllOperations];
}

@end

#pragma mark -

//
//	ThumbOperation class implementation
//

@implementation ThumbOperation
{
	NSString *_guid;
}

@synthesize guid  =  _guid;

#pragma mark - ThumbOperation instance methods

- (instancetype)initWithGUID:(NSString *)guid
{
	if ((self  =  [super init]))
	{
		_guid  =  guid;
	}

	return self;
}

@end
