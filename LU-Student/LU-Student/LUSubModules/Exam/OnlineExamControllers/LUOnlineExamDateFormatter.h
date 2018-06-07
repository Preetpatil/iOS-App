//
//  LUOnlineExamDateFormatter.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.//

#import <Foundation/Foundation.h>

@interface LUOnlineExamDateFormatter : NSObject

+(NSString*)getTheCurrentDate;
+(NSString*)getTheCurrentMonth;
+(NSString*)getTheCurrentYear;
+(NSInteger)getTheCurrenthour;
+(NSInteger)getTheCurrentminute;
+(NSInteger)getTheCurrentsecond;
+(int)getDaysInMonth:(int)month year:(int)year;
+(NSString*)getDayOfDate:(int)date month:(int)month year:(int)year;

@end
