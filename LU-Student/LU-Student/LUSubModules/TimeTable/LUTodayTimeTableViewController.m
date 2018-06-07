//
//  LUTodayTimeTableViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 15/02/17.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUTodayTimeTableViewController.h"
#import "LUTimeTableCalendarDataSource.h"
#import "LUStudentTimeTableViewController.h"

@interface LUTodayTimeTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mYear;
@property (weak, nonatomic) IBOutlet UILabel *weekNo;
@property (weak, nonatomic) IBOutlet UILabel *week;

@end

@implementation LUTodayTimeTableViewController{
    NSArray *color;
    NSMutableDictionary *subColor;
    NSString *convertedDateString;
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self todaytimetabledata];
    [self initializeTodayTimeTable];
//    NSLocale* currentLocale = [NSLocale currentLocale];
//    [[NSDate date] descriptionWithLocale:currentLocale];
    
    
//    NSArray *daySymbols = dateFormatter.standaloneWeekdaySymbols;
//    NSInteger dayIndex = 1;
//    NSString *dayName = daySymbols[dayIndex % 7];
//    NSLog(@"%@",dayName);
    
    //today day
    
}

- (void) todayTimetablelist: (NSDictionary *)todaytimetablelist;
{
    
    
    _todaydata =[todaytimetablelist objectForKey:@"Timetable"];
    
    NSLog(@"%@",_todaydata);
    for (int i=0; i<_todaydata.count; i++)
    {
        _todaydataDict=[_todaydata objectAtIndex:i];
        _todayArray=[_todaydataDict objectForKey:@"TodayData"];
    }
    
    [_todayTable reloadData];
    
}

-(void)todaytimetabledata
{
    NSMutableDictionary*body =[[NSMutableDictionary alloc]init];
    // NSMutableDictionary*Body= [[NSMutableDictionary alloc]init];
    
    NSDate *todayDate = [NSDate date]; // get today date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setDateFormat:@"e"];
    
    convertedDateString = [dateFormatter stringFromDate:todayDate];
    NSLog(@"%@",convertedDateString);

    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSString*wk=[NSString stringWithFormat:@"%lu",[dateComponents weekday]-1];
    
    [body setObject:wk forKey:@"DayId"];
    
    LUOperation *sharedSingleton = [LUOperation getSharedInstance];
    sharedSingleton.LUDelegateCall=self;
    [sharedSingleton todaytimeTableList:body];
    
}



- (void) initializeTodayTimeTable
{
    

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *mf = [[NSDateFormatter alloc] init];
    NSDateFormatter *yf = [[NSDateFormatter alloc] init];
    
    [mf setDateFormat:@"MMMM"];
    [yf setDateFormat:@"yyyy"];
    
     
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterOrdinalStyle];
    
    _weekNo.text = [NSString stringWithFormat:@"%@ Week",[formatter stringFromNumber:[NSNumber numberWithInteger:[[calendar components: NSCalendarUnitWeekOfYear fromDate:date] weekOfYear]]]];
    _week.text = [[_todayArray objectAtIndex:0] objectForKey:@"DayName"];
    
    _mYear.text =[NSString stringWithFormat:@"%@ %@",[mf stringFromDate:[NSDate date]],[yf stringFromDate:[NSDate date]]];
    color=[NSArray arrayWithObjects:
           [UIColor colorWithRed:77.0/255.0 green:171.0/255.0 blue:255.0/255.0 alpha:0.8],
           [UIColor colorWithRed:183.0/255.0 green:255.0/255.0 blue:189.0/255.0 alpha:0.8],
           [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:125.0/255.0 alpha:0.8],
           [UIColor colorWithRed:192.0/255.0 green:156.0/255.0 blue:255.0/255.0 alpha:0.8],
           [UIColor colorWithRed:227.0/255.0 green:50.0/255.0 blue:140.0/255.0 alpha:0.8],
           [UIColor colorWithRed:204.0/255.0 green:206.0/255.0 blue:0.0/255.0 alpha:0.8],
           [UIColor colorWithRed:0.0/255.0 green:165.0/255.0 blue:169.0/255.0 alpha:0.8],
           [UIColor colorWithRed:254.0/255.0 green:39.0/255.0 blue:18.0/255.0 alpha:0.8],
           [UIColor colorWithRed:204.0/255.0 green:206.0/255.0 blue:0.0/255.0 alpha:0.8],
           [UIColor colorWithRed:0.0/255.0 green:165.0/255.0 blue:169.0/255.0 alpha:0.8],
           
           nil];
    subColor = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",_todayArray);
}

#pragma mark TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _todayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayCELL"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodayCELL"];
    }
        UILabel *subName = (UILabel*)[cell viewWithTag:101];
    
    subName.text = [NSString stringWithFormat:@"%@",[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"SubjectName"]];
    if ([subName.text isEqualToString:@"Lunch" ])
    {
        
        cell.backgroundColor = [UIColor lightGrayColor];
    }else if ([subName.text isEqualToString:@"Break" ])
    {
        cell.backgroundColor = [UIColor grayColor];

    }
    else{
    
        cell.backgroundColor = [color objectAtIndex:[self checkColor:subName.text]];

    }
    
    UILabel *seTime = (UILabel*)[cell viewWithTag:102];
    seTime.text =[NSString stringWithFormat:@"%@ - %@",[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"ScheduleFromTime"],[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"ScheduleToTime"]];
  
     _week.text = [[_todayArray objectAtIndex:0] objectForKey:@"DayName"];
    return cell;
}

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


// as of now pop up inot implemented as they are not sending any deetails to be popoed up

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"details"]allValues]!=nil) {
//        
//    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
//    LUTimeTableDetailViewController *detail =[[LUTimeTableDetailViewController alloc]initWithNibName:@"LUTimeTableDetailViewController" bundle:nil];
//    detail.detailArray = [[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"details"]allValues];
//    detail.view.backgroundColor = [color objectAtIndex:[self checkColor:[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"SubjectName"]]];
//    detail.detailTable.backgroundColor = [color objectAtIndex:[self checkColor:[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"SubjectName"]]];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detail];//navigating to the pop over xib from parent view
//    nav.modalPresentationStyle = UIModalPresentationPopover;
//    nav.navigationBarHidden=YES;
//    //    //---pop over presentation---//
//    UIPopoverPresentationController *popover = nav.popoverPresentationController;
//    detail.preferredContentSize = CGSizeMake(300,200);
//    
//    
//    popover.sourceView = self.view;
//    popover.sourceRect = CGRectMake(1000,cellRect.origin.y+180, 0, 0);
//    popover.backgroundColor=[color objectAtIndex:[self checkColor:[[_todayArray objectAtIndex:indexPath.row] objectForKey:@"SubjectName"]]];
//    popover.permittedArrowDirections = UIPopoverArrowDirectionLeft;
//    
//    [self presentViewController:nav animated:YES completion:nil];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
