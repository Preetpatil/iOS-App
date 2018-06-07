//
//  LUStudentTimeTableViewController.m
//  LUStudent

//  Created by Preeti Patil on 01/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUStudentTimeTableViewController.h"
#import "LUTimeTableCalendarDataSource.h"
#import "LUStudentProfileViewController.h"
#import "LUHeaderView.h"

@interface LUStudentTimeTableViewController ()

@property (strong, nonatomic) IBOutlet LUTimeTableCalendarDataSource *LUTimeTableCalendarDataSource;

@end

@implementation LUStudentTimeTableViewController{
    NSArray *color,*week;
    NSMutableDictionary *subColor;
    LUTimeTableCalendarDataSource *dataSource;
    NSString *subForDetails;
    CGFloat initial;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
        
    [self createHeader];
    [self initializeCalendarView];
    

}

/**
 <#Description#>
 */
- (void) initializeCalendarView
{
    week = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    subColor = [[NSMutableDictionary alloc]init];
    
    color=[NSArray arrayWithObjects:
           [UIColor colorWithRed:77.0/255.0 green:171.0/255.0 blue:255.0/255.0 alpha:0.6],
           [UIColor colorWithRed:183.0/255.0 green:255.0/255.0 blue:189.0/255.0 alpha:0.6],
           [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:125.0/255.0 alpha:0.6],
           [UIColor colorWithRed:192.0/255.0 green:156.0/255.0 blue:255.0/255.0 alpha:0.6],
           [UIColor colorWithRed:227.0/255.0 green:50.0/255.0 blue:140.0/255.0 alpha:0.6],
           [UIColor colorWithRed:204.0/255.0 green:206.0/255.0 blue:0.0/255.0 alpha:0.6],
           [UIColor colorWithRed:0.0/255.0 green:165.0/255.0 blue:169.0/255.0 alpha:0.6],
           [UIColor colorWithRed:254.0/255.0 green:39.0/255.0 blue:18.0/255.0 alpha:0.6],
           [UIColor colorWithRed:204.0/255.0 green:206.0/255.0 blue:0.0/255.0 alpha:0.6],
           [UIColor colorWithRed:0.0/255.0 green:165.0/255.0 blue:169.0/255.0 alpha:0.6],
           
           nil];
    
    // Register NIB for supplementary views
    UINib *headerViewNib = [UINib nibWithNibName:@"LUHeaderView" bundle:nil];
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"LUHeaderView"];
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"LUHeaderView"];
    //  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:9 inSection:0];
    //[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    // Define cell and header view configuration
    dataSource = (LUTimeTableCalendarDataSource *)self.collectionView.dataSource;
    dataSource.configureCellBlock = ^(LUTimeTableCalendarEventCell *cell, NSIndexPath *indexPath, id<LUTimeTableCalendarEvent> event) {
        
        cell.titleLabel.text = event.title;
        subForDetails = event.title;
        cell.timeLabel.text =[NSString stringWithFormat:@"%@-%@",event.startTime,event.endTime];
        
        cell.titleLabel.textColor=[UIColor whiteColor];
        if ([cell.titleLabel.text isEqualToString:@"Lunch"])
        {
            cell.backgroundColor = [UIColor grayColor];
            cell.layer.borderWidth = 0.0;
        }else if ([cell.titleLabel.text isEqualToString:@"Break"])
        {
            cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
            cell.layer.borderWidth = 0.0;
        }
        else
        {
            cell.layer.cornerRadius = 5;
            cell.backgroundColor = [color objectAtIndex:[self checkColor:cell.titleLabel.text]];
        }
    };
    dataSource.configureHeaderViewBlock = ^(LUHeaderView *LUHeaderView, NSString *kind, NSIndexPath *indexPath) {
        if ([kind isEqualToString:@"DayHeaderView"])
        {
            //LUHeaderView.titleLabel.text =[week objectAtIndex:indexPath.item];
        } else if ([kind isEqualToString:@"HourHeaderView"])
        {
            LUHeaderView.titleLabel.text = [NSString stringWithFormat:@"%2ld:00", indexPath.item + 1];
            initial = LUHeaderView.frame.origin.y;
            [self currentTime: [NSString stringWithFormat:@"%2ld", indexPath.item + 1]];
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"receiveTestNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailAction:) name:@"detailAction" object:nil];
}
-(void)currentTime:(NSString*)now
{
    
    NSDate * hrmm = [NSDate date];
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH"];
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    [minuteFormatter setDateFormat:@"mm"];
    
    NSString *hourString = [hourFormatter stringFromDate:hrmm];
    NSString *minuteString = [minuteFormatter stringFromDate:hrmm];
    CAShapeLayer *shapeLayer;
    UIBezierPath *path;
    if ([hourString isEqualToString:now])
    {
        [shapeLayer removeFromSuperlayer];
        [path removeAllPoints];
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(10.0, initial+[minuteString floatValue])];
        [path addLineToPoint:CGPointMake(1355.0, initial+[minuteString floatValue])];
        
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor redColor] CGColor];
        shapeLayer.lineWidth = 1.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        [self.collectionView.layer addSublayer:shapeLayer];
    }
   
    
}

/**
 <#Description#>

 @param notification <#notification description#>
 */
- (void) receiveTestNotification:(NSNotification *)notification
{
    [self.collectionView reloadData];
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:8 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

/**
 <#Description#>
 */
-(void)createHeader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 80)];
        header.backgroundColor= [UIColor whiteColor];
        header.layer.masksToBounds = false;
        header.layer.shadowColor = [UIColor blackColor].CGColor;
        header.layer.shadowOffset = CGSizeMake(2,2);
        header.layer.shadowOpacity = 0.50;
        //header.layer.shadowPath = UIBezierPath(rect: bounds).cgPath;
        header.layer.shadowRadius = 1.0;
        [self.view addSubview:header];
        
        CGFloat width =header.bounds.size.width/8;
        CGFloat x =125;
        NSArray *day = @[@"Monday",@"Tuesday",@"wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
       
        
        
        UILabel *weekOfYear =[[UILabel alloc]initWithFrame:CGRectMake(10,header.bounds.size.height/2+15,width,21)];
        weekOfYear.text = [NSString stringWithFormat:@"%@ Week",[self getOrdinalStringFromInteger:[[calendar components: NSCalendarUnitWeekOfYear fromDate:date] weekOfYear]]];
        [weekOfYear setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        [weekOfYear setTextAlignment:0];
        [header addSubview:weekOfYear];
        
        
        UILabel *ttLabel =[[UILabel alloc]initWithFrame:CGRectMake(header.bounds.size.width/2-50,header.bounds.size.height/2-30,120,21)];
        ttLabel.text = @"Time Table";
        [ttLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
        [ttLabel setTextAlignment:1];
        [header addSubview:ttLabel];
        
        UIButton *today = [[UIButton alloc]initWithFrame:CGRectMake(header.bounds.size.width-100,header.bounds.size.height/2-30,120,40)];
        [today setTitle:@"Today" forState:UIControlStateNormal];
        [today setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [today addTarget:self action:@selector(todayAction) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:today];
        
        
        for (int i=0;i<7;i++)
        {
            UILabel *loopWeek =[[UILabel alloc]initWithFrame:CGRectMake(x-50,header.bounds.size.height/2+15,width,21)];
            loopWeek.text = [day objectAtIndex:i];
            loopWeek.textColor = [UIColor blackColor];
            //loopWeek.backgroundColor = [UIColor lightGrayColor];
            [loopWeek setFont:[UIFont fontWithName:@"Helvetica" size:20]];
            [loopWeek setTextAlignment:2];
            [header addSubview:loopWeek];
            x=x+width;
        }
    });
}

/**
 <#Description#>

 @param integer <#integer description#>
 @return <#return value description#>
 */
- (NSString *)getOrdinalStringFromInteger:(long)integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterOrdinalStyle];
    return [formatter stringFromNumber:[NSNumber numberWithInteger:integer]];
}

/**
 <#Description#>
 */
-(void)todayAction
{
    
     //[dataSource today ];
    LUTodayTimeTableViewController *secondViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentTimeTableTodayVC"];
   
    
    [self.navigationController pushViewController:secondViewController animated:YES];
    

    
}

/**
 <#Description#>

 @param cellData <#cellData description#>
 */
-(void)detailAction:(NSNotification *)cellData
{
    LUTodayTimeTableViewController *pushToToday = [self.storyboard instantiateViewControllerWithIdentifier:@"LUStudentTimeTableTodayVC"];
    pushToToday.todayArray = [cellData object];
    [self.navigationController pushViewController:pushToToday animated:YES];
    
}

/**
 <#Description#>

 @param touches <#touches description#>
 @param event <#event description#>
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.collectionView];
}


/**
 <#Description#>

 @param subjectName <#subjectName description#>
 @return <#return value description#>
 */
-(NSInteger)checkColor:(NSString *)subjectName
{
    NSInteger  idx;
    if ([[subColor allKeys]containsObject:subjectName])
    {
        idx =[[subColor objectForKey:subjectName] integerValue];
    }
    else
    {
        [subColor setObject:[NSString stringWithFormat:@"%lu",(unsigned long)subColor.count] forKey:subjectName];
        idx =[[subColor objectForKey:subjectName] integerValue];
    }
    return idx;
}

@end
