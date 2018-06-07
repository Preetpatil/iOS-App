//
//  LUTimeTableCalendarEvent.h
//  LUStudent

//  Created by Preeti Patil on 01/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LUTimeTableCalendarEvent <NSObject>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;

@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger startHour;

@property (assign, nonatomic) NSInteger durationInHours;
@property (assign, nonatomic) NSInteger durationInMinutes;
@property (assign, nonatomic) NSInteger startHourMinutes;
@end
