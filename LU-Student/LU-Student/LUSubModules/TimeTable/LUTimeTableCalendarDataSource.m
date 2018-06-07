//
//  LUTimeTableCalendarDataSource.m
//  LUStudent

//  Created by Preeti Patil on 01/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUTimeTableCalendarDataSource.h"
#import "LUTimeTableSampleCalendarEvent.h"
#import "LUStudentProfileViewController.h"


@interface LUTimeTableCalendarDataSource ()

@property (strong, nonatomic) NSMutableArray *events;

@end

@implementation LUTimeTableCalendarDataSource{
    int day;
    int hour;
    int durationHour;
    int durationMinutes;
    int startMinutes;
   NSMutableArray *periodCount;
    NSMutableArray *details;
    
    BOOL enableToday;
    NSString*dayId;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    enableToday = NO;
    _events = [[NSMutableArray alloc] init];
    periodCount = [[NSMutableArray alloc] init];
    details = [[NSMutableArray alloc] init];
   
   [self getData:@"all"];
    
}

/**
 <#Description#>
 */
-(void)today
{
    enableToday = YES;
   // [_events removeAllObjects];
    [self getData:@"today"];
   
    
}

/**
 <#Description#>
 */
- (void)generateSampleData
{   //http://setumbrella.in/learning_umbrella/timetable1.php?school_id=13&class_id=2
    
    //    NSError *error;
    //    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"json"];
    //    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    
    
    
        if(enableToday)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detailAction" object:periodCount];
       
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSUInteger idx = 0; idx < periodCount.count; idx++)
                {
                    _period = [periodCount objectAtIndex:idx];
                    if ([[_period allKeys] containsObject:@"details"])
                    {
                        [details addObject:[_period objectForKey:@"details"]];
                    }else{
                        [details addObject:@""];
                    }
                    NSString *subName = [_period objectForKey:@"SubjectName"];
                    day = [self weekday: [_period objectForKey:@"DayName"]];
                    NSString *dateStartString = [_period objectForKey:@"ScheduleFromTime"];
                    NSString *dateEndString = [_period objectForKey:@"ScheduleToTime"];
                    _DayIdArry=[_period objectForKey:@"DayId"];
                    NSLog(@"%@",_DayIdArry);
                    
                    hour = [[[dateStartString substringWithRange:NSMakeRange(0, 2)] stringByReplacingOccurrencesOfString:@":" withString:@"" ]intValue]-1;
                    
                    durationHour = 1;
                    durationMinutes =[[_period objectForKey:@"Duration"] intValue];
                    startMinutes =[[[dateStartString substringWithRange:NSMakeRange(2, 3)]stringByReplacingOccurrencesOfString:@":" withString:@"" ]intValue];
                    
                    LUTimeTableSampleCalendarEvent *event = [LUTimeTableSampleCalendarEvent randomEvent:subName randomDay:day randomHour:hour randomStartTime:dateStartString randomEndTime:dateEndString   randomDuration:durationHour randomDurationMinutes:durationMinutes randomStartDurationMinutes:startMinutes];
                    
                    [self.events addObject:event];
                }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveTestNotification" object:nil];
           });
        }
        
    
    
    /*
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    
   NSArray *dayCount = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];

    
    for (NSUInteger idx = 0; idx < dayCount.count; idx++)
    {
        NSDictionary *period = [dayCount objectAtIndex:idx];
        
        NSString *subName = [period objectForKey:@"subject_name"];
        day = [self weekday: [period objectForKey:@"day"]];
        NSString *dateStartString = [period objectForKey:@"start_time"];
        NSString *dateEndString = [period objectForKey:@"end_time"];
        
        
        hour = [[[dateStartString substringWithRange:NSMakeRange(0, 2)] stringByReplacingOccurrencesOfString:@":" withString:@"" ]intValue]-1;
        
        durationHour = 1;
        durationMinutes =[[period objectForKey:@"duration"] intValue];
        startMinutes =[[[dateStartString substringWithRange:NSMakeRange(2, 3)]stringByReplacingOccurrencesOfString:@":" withString:@"" ]intValue];
        
        LUTimeTableSampleCalendarEvent *event = [LUTimeTableSampleCalendarEvent randomEvent:subName randomDay:day randomHour:hour randomDuration:durationHour randomDurationMinutes:durationMinutes randomStartDurationMinutes:startMinutes];
        
        [self.events addObject:event];
        
            }*/
}

/**
 <#Description#>

 @param key <#key description#>
 */
-(void)getData:(NSString *)key
{
    //NSString *url =@"http://setumbrella.in/luservice/controller/api/studentController.php?Action=GetTimeTableByClassId&ClassId=1&SectionId=1" ;
    
    NSString*url=@"http://setumbrella.in/luservice/controller/api/studentController.php?Action=GetTimeTableByClassId";
    
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton timeTableList:url];
// share the  components
    
//    NSString *url =@"http://setumbrella.in/learning_umbrella/timetable1.php?school_id=13&class_id=2" ;
//    NSString *dataUrl  =[NSString stringWithFormat:@"%@&key=%@",url,key] ;
//    
//    NSURLSession *session  =  [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask  =  [session dataTaskWithURL:[NSURL URLWithString:dataUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        NSArray *dayCount = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [periodCount removeAllObjects];
//            [details removeAllObjects];
//        for (int i=0; i<dayCount.count; i++)
//        {
//            
//            NSArray *dayarr = [dayCount objectAtIndex:i];
//            NSLog(@"%lu",dayarr.count);
//            for (int i=0; i<dayarr.count;i++)
//            {
//                [periodCount addObject:[dayarr objectAtIndex:i]];
//            
//            }
//        }
//            [self generateSampleData];
//        });
//        
//    }];
//    [dataTask resume];
}


/**
 <#Description#>

 @param timetablelist <#timetablelist description#>
 */
-(void)timeTableList:(NSDictionary *)timetablelist
{
    
    [periodCount removeAllObjects];
    [details removeAllObjects];
    periodCount = [[[timetablelist objectForKey:@"Timetable"] objectAtIndex:0] objectForKey:@"ScheduleData"];

//    for (int i=0; i<periodCount.count; i++)
//    {
//        NSMutableDictionary*dict =[periodCount objectAtIndex:i];
//        NSMutableArray *temp =[dict objectForKey:@"DayId"];
//        NSLog(@"%@",temp);
//    }
//    
//    
    
    //
//    for (int i=0; i<timetablelist.count; i++)
//    {
//        
//        NSArray *dayarr = [timetablelist objectAtIndex:i];
//        NSLog(@"%lu",dayarr.count);
//        for (int i=0; i<dayarr.count;i++)
//        {
//            [periodCount addObject:[dayarr objectAtIndex:i]];
//            
//        }
//    }
    [self generateSampleData];
    
}

/**
 <#Description#>

 @param weekday <#weekday description#>
 @return <#return value description#>
 */
-(int)weekday:(NSString*)weekday
{
    if ([weekday isEqualToString:@"Monday"])
    {
        day = Monday;
    }else if ([weekday isEqualToString:@"Tuesday"])
    {
        day = Tuesday;
    }
    else if ([weekday isEqualToString:@"Wednesday"])
    {
        day = Wednesday;
    }
    else if ([weekday isEqualToString:@"Thursday"])
    {
        day = Thursday;
    }
    else if ([weekday isEqualToString:@"Friday"])
    {
        day = Friday;
    }
    else if ([weekday isEqualToString:@"Saturday"])
    {
        day = Saturday;
    }
    else if ([weekday isEqualToString:@"Sunday"])
    {
        day = Sunday;
    }
    return day;
}
#pragma mark - LUTimeTableCalendarDataSource

// The layout object calls these methods to identify the events that correspond to
// a given index path or that are visible in a certain rectangle

/**
 <#Description#>

 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (id<LUTimeTableCalendarEvent>)eventAtIndexPath:(NSIndexPath *)indexPath
{
    return self.events[indexPath.item];
}


/**
 <#Description#>

 @param minDayIndex <#minDayIndex description#>
 @param maxDayIndex <#maxDayIndex description#>
 @param minStartHour <#minStartHour description#>
 @param maxStartHour <#maxStartHour description#>
 @return <#return value description#>
 */
- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.events enumerateObjectsUsingBlock:^(id event, NSUInteger idx, BOOL *stop) {
        if ([event day] >= minDayIndex && [event day] <= maxDayIndex && [event startHour] >= minStartHour && [event startHour] <= maxStartHour)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    return indexPaths;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<LUTimeTableCalendarEvent> event = self.events[indexPath.item];
    LUTimeTableCalendarEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LUTimeTableCalendarEventCell" forIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, event);
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    LUHeaderView *LUHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"LUHeaderView" forIndexPath:indexPath];
    if (self.configureHeaderViewBlock)
    {
        self.configureHeaderViewBlock(LUHeaderView, kind, indexPath);
    }
    return LUHeaderView;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (enableToday )
//    {
//        NSDictionary *temp = [details objectAtIndex:indexPath.row];
//        if (![temp  isEqual: @""])
//        {
//            NSArray *tempDetail =[temp allValues];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"detailAction" object:tempDetail];
//       
//        }
//        
//    }
//  
//}

@end
