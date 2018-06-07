//
//  LUOnlineExamDateFormatter.m
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import "LUOnlineExamDateFormatter.h"

@implementation LUOnlineExamDateFormatter

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSString*)getTheCurrentDate
{
    NSDateFormatter *formatter  =  [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar  =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSLocale *usLocale  =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];

    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSString*)getTheCurrentMonth
{
    NSDateFormatter *formatter  =  [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar  =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSLocale *usLocale  =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSString*)getTheCurrentYear
{
    NSDateFormatter *formatter  =  [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar  =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSLocale *usLocale  =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];

}

/**
 <#Description#>

 @param month <#month description#>
 @param year <#year description#>
 @return <#return value description#>
 */
+(int)getDaysInMonth:(int)month year:(int)year
{
    int daysInFeb  =  28;
    if (year%4  ==  0)
    {
        daysInFeb  =  29;
    }
    int daysInMonth [12]  =  {31,daysInFeb,31,30,31,30,31,31,30,31,30,31};
    return daysInMonth[month-1];
}

/**
 <#Description#>

 @param date <#date description#>
 @param month <#month description#>
 @param year <#year description#>
 @return <#return value description#>
 */
+(NSString*)getDayOfDate:(int)date month:(int)month year:(int)year
{
    NSDateFormatter *dateFormatter  =  [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *gregorianCalendar  =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setCalendar:gregorianCalendar];
    
    NSLocale *usLocale  =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSDate *capturedStartDate  =  [dateFormatter dateFromString: [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,date]];
    
    NSDateFormatter *weekday  =  [[NSDateFormatter alloc] init];
    [weekday setLocale:usLocale];
    
    [weekday setDateFormat: @"EEEE"];
    
    return [weekday stringFromDate:capturedStartDate];
}

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSInteger)getTheCurrenthour
{
    NSDate *now  =  [NSDate date];
    NSCalendar *calendar  =  [NSCalendar currentCalendar];
    NSDateComponents *components  =  [calendar components:NSCalendarUnitHour fromDate:now];
    
    return [components hour];
}

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSInteger)getTheCurrentminute
{
    NSDate *now  =  [NSDate date];
    NSCalendar *calendar  =  [NSCalendar currentCalendar];
    NSDateComponents *components  =  [calendar components:NSCalendarUnitMinute fromDate:now];
    return [components minute];
}

/**
 <#Description#>

 @return <#return value description#>
 */
+(NSInteger)getTheCurrentsecond
{
    NSDate *now  =  [NSDate date];
    NSCalendar *calendar  =  [NSCalendar currentCalendar];
    NSDateComponents *components  =  [calendar components:NSCalendarUnitSecond fromDate:now];
    return [components second];
}

@end
