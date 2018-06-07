//
//  LUTimeTableWeekCalendarLayout.m
//  LUStudent

//  Created by Preeti Patil on 01/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUTimeTableWeekCalendarLayout.h"
#import "LUTimeTableCalendarDataSource.h"

static const NSUInteger DaysPerWeek = 7;
static const NSUInteger HoursPerDay = 24;
static const CGFloat HorizontalSpacing = 0;
static const CGFloat HeightPerHour = 60;
static const CGFloat DayHeaderHeight = 40;
static const CGFloat HourHeaderWidth = 100;

@interface LUTimeTableWeekCalendarLayout ()

@end

@implementation LUTimeTableWeekCalendarLayout

#pragma mark - UICollectionViewLayout Implementation

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;

    // Scroll vertically to display a full day
    CGFloat contentHeight = DayHeaderHeight + (HeightPerHour * HoursPerDay);
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];

    // Cells
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }

    // Supplementary views
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"HourHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LUTimeTableCalendarDataSource *dataSource = self.collectionView.dataSource;
    id<LUTimeTableCalendarEvent> event = [dataSource eventAtIndexPath:indexPath];
   
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForEvent:event];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - HourHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        attributes.zIndex = -20;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * indexPath.item, totalWidth, HeightPerHour);
        attributes.zIndex = -10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Helpers

/**
 <#Description#>

 @param rect <#rect description#>
 @return <#return value description#>
 */
- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
//    NSLog(@"rect: %@, days: %d-%d, hours: %d-%d", NSStringFromCGRect(rect), minVisibleDay, maxVisibleDay, minVisibleHour, maxVisibleHour);
    
    LUTimeTableCalendarDataSource *dataSource = self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minStartHour:minVisibleHour maxStartHour:maxVisibleHour];
    return indexPaths;
}

/**
 <#Description#>

 @param xPosition <#xPosition description#>
 @return <#return value description#>
 */
- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition
{
    CGFloat contentWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = contentWidth / DaysPerWeek;
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)((xPosition - HourHeaderWidth) / widthPerDay));
    return dayIndex;
}

/**
 <#Description#>

 @param yPosition <#yPosition description#>
 @return <#return value description#>
 */
- (NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition
{
    NSInteger hourIndex = MAX((NSInteger)0, (NSInteger)((yPosition - DayHeaderHeight) / HeightPerHour));
    return hourIndex;
}

/**
 <#Description#>

 @param rect <#rect description#>
 @return <#return value description#>
 */
- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinY(rect) > DayHeaderHeight) {
        return [NSArray array];
    }
    
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

/**
 <#Description#>

 @param rect <#rect description#>
 @return <#return value description#>
 */
- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinX(rect) > HourHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

/**
 <#Description#>

 @param event <#event description#>
 @return <#return value description#>
 */
- (CGRect)frameForEvent:(id<LUTimeTableCalendarEvent>)event
{
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;

    CGRect frame = CGRectZero;
    frame.origin.x = HourHeaderWidth + widthPerDay * event.day;
    frame.origin.y = DayHeaderHeight + HeightPerHour * event.startHour+event.startHourMinutes;// 0 to 60 for minutes
    frame.size.width = widthPerDay;
    frame.size.height = event.durationInHours +event.durationInMinutes;
    
    frame = CGRectInset(frame, HorizontalSpacing/2.0, 0);
    return frame;
}

@end
