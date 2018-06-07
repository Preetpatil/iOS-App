//
//	ThumbFetch.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "ThumbQueue.h"

@class ThumbRequest;

@interface ThumbFetch : ThumbOperation

- (instancetype)initWithRequest:(ThumbRequest *)options;

@end
