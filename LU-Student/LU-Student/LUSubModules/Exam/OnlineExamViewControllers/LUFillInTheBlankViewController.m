//
//  LUFillInTheBlankViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUFillInTheBlankViewController.h"

@interface LUFillInTheBlankViewController ()

@end

@implementation LUFillInTheBlankViewController
{
    NSMutableArray *questArray,*questNoArray;
    int hours, minutes, seconds;
    int currSeconds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    questArray = [[NSMutableArray alloc]init];
    questNoArray = [[NSMutableArray alloc]init];
    
    _secondsLeft = _tempsecondsLeft;
    [self countdownTimer];

    for (int i=0; i<_questions.count; i++)
    {
        NSArray *temp = [_questions objectAtIndex:i];
        NSDictionary *temp1 = [temp objectAtIndex:0];
        [questNoArray addObject:[temp1 objectForKey:@"QuestionNumber"]];
        [questArray addObject:[temp1 objectForKey:@"Question"]];
    }
      NSLog(@"%@",questArray);
    // Do any additional setup after loading the view.
    [self.fillTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fillCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fillCell"];
    }
    UILabel *qNO = (UILabel *)[cell viewWithTag:100];
    qNO.text = [questNoArray objectAtIndex:indexPath.row];
    UILabel *qQstn = (UILabel *)[cell viewWithTag:101];
    qQstn.text = [questArray objectAtIndex:indexPath.row];
    
    
    return cell;

}
/**
 <#Description#>
 
 @param theTimer <#theTimer description#>
 */
-(void)updateCounter:(NSTimer *)theTimer
{
    if(_secondsLeft > 0 )
    {
        _secondsLeft -- ;
        hours  =  _secondsLeft / 3600;
        minutes  =  (_secondsLeft % 3600) / 60;
        seconds  =  (_secondsLeft %3600) % 60;
        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds]);
        _timeLeft .text  =  [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else
    {
        _secondsLeft  = _tempsecondsLeft;
    }
}

/**
 <#Description#>
 */
-(void)countdownTimer
{
    _secondsLeft  =  hours  =  minutes  =  seconds  =  0;
    _timercount  =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:)userInfo:nil repeats:YES];
}

@end
