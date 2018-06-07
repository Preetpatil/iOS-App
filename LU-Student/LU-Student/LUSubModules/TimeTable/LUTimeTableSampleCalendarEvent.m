//
//  LUTimeTableSampleCalendarEvent.m
//  LUStudent

//  Created by Preeti Patil on 01/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUTimeTableSampleCalendarEvent.h"

@implementation LUTimeTableSampleCalendarEvent

@synthesize title = _title;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;

@synthesize day = _day;
@synthesize startHour = _startHour;
@synthesize durationInHours = _durationInHours;
@synthesize durationInMinutes = _durationInMinutes;
@synthesize startHourMinutes = _startHourMinutes;

/**
 <#Description#>

 @param title <#title description#>
 @param randomDay <#randomDay description#>
 @param randomStartHour <#randomStartHour description#>
 @param randomStartTime <#randomStartTime description#>
 @param randomEndTime <#randomEndTime description#>
 @param randomDuration <#randomDuration description#>
 @param randomDurationMinutes <#randomDurationMinutes description#>
 @param randomStartDurationMinutes <#randomStartDurationMinutes description#>
 @return <#return value description#>
 */
+ (instancetype)randomEvent:(NSString *)title randomDay:(int)randomDay randomHour:(int)randomStartHour randomStartTime:(NSString *)randomStartTime randomEndTime:(NSString *)randomEndTime randomDuration:(int)randomDuration randomDurationMinutes:(int)randomDurationMinutes randomStartDurationMinutes:(int)randomStartDurationMinutes

{
//    //(NSString *)title randomDay:(int)randomDay randomHour:(int)randomStartHour randomDuration:(int)randomDuration
//    
//   // ret =   [self eventWithTitle:title day:randomDay startHour:randomStartHour durationInHours:randomDuration];
//  //  }
//
//    uint32_t randomID = arc4random_uniform(10000);
//    NSString *title = [NSString stringWithFormat:@"Event #%u", randomID];
//    
//    uint32_t randomDay = arc4random_uniform(7);
//    uint32_t randomStartHour =arc4random_uniform(20);
//    uint32_t randomDuration = arc4random_uniform(5) + 1;
    
    return [self eventWithTitle:title day:randomDay startHour:randomStartHour StartTime:randomStartTime EndTime:randomEndTime  durationInHours:randomDuration durationInMinutes:randomDurationMinutes durationStartInMinutes:randomStartDurationMinutes];
}

/**
 <#Description#>

 @param title <#title description#>
 @param day <#day description#>
 @param startHour <#startHour description#>
 @param StartTime <#StartTime description#>
 @param EndTime <#EndTime description#>
 @param durationInHours <#durationInHours description#>
 @param durationInMinutes <#durationInMinutes description#>
 @param durationStartInMinutes <#durationStartInMinutes description#>
 @return <#return value description#>
 */
+ (instancetype)eventWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour StartTime:(NSString *)StartTime EndTime:(NSString *)EndTime durationInHours:(NSUInteger)durationInHours durationInMinutes:(NSInteger)durationInMinutes durationStartInMinutes:(NSInteger)durationStartInMinutes
{
    return [[self alloc] initWithTitle:title day:day startHour:startHour StartTime:StartTime EndTime:EndTime  durationInHours:durationInHours durationInMinutes:durationInMinutes durationStartInMinutes:durationStartInMinutes];
}

/**
 <#Description#>

 @param title <#title description#>
 @param day <#day description#>
 @param startHour <#startHour description#>
 @param StartTime <#StartTime description#>
 @param EndTime <#EndTime description#>
 @param durationInHours <#durationInHours description#>
 @param durationInMinutes <#durationInMinutes description#>
 @param durationStartInMinutes <#durationStartInMinutes description#>
 @return <#return value description#>
 */
- (instancetype)initWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour StartTime:(NSString *)StartTime EndTime:(NSString *)EndTime durationInHours:(NSUInteger)durationInHours durationInMinutes:(NSInteger)durationInMinutes durationStartInMinutes:(NSInteger)durationStartInMinutes
{
    self = [super init];
    if (self != nil) {
        _title = [title copy];
        _day = day;
        _startHour = startHour;
        _durationInHours = durationInHours;
        _durationInMinutes = durationInMinutes;
        _startHourMinutes = durationStartInMinutes;
        _startTime =StartTime;
        _endTime = EndTime;
    }
    return self;
}

/**
 <#Description#>

 @return <#return value description#>
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: Day %ld - Hour %ld - startTime %@ - endTime %@ - Duration %ld - Minutes %ld - StartMinutes %ld", self.title, self.day, self.startHour, self.startTime,self.endTime, self.durationInHours, self.durationInMinutes,self.startHourMinutes];
}

@end
