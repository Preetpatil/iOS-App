//
//  LUMatchTheFollowingViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUMatchTheFollowingViewController.h"

@interface LUMatchTheFollowingViewController ()

@end

@implementation LUMatchTheFollowingViewController
{
    NSMutableDictionary *selectionMatch;
    NSMutableArray *matchOptions,*matchQuestions;
    int hours, minutes, seconds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _secondsLeft = _tempsecondsLeft;
    [self countdownTimer];

    selectionMatch = [[NSMutableDictionary alloc]init];
    matchQuestions = [[NSMutableArray alloc]init];
    matchOptions = [[NSMutableArray alloc]init];
    [self fetcher];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([_MatchQuestionDelegate respondsToSelector:@selector(returnMatchAnswer:)]) {
       // [ _MatchQuestionDelegate returnMatchAnswer:answers];
    }

    
    
}

-(void)fetcher
{
    NSLog(@"%lu",_questions.count);
    for (int i=0; i<_questions.count; i++)
    {
       [matchQuestions addObject: [[[_questions objectAtIndex:i] objectAtIndex:0] objectForKey:@"Question"]];
       [matchOptions addObject: [[[_questions objectAtIndex:i] objectAtIndex:0] objectForKey:@"MatchOption"]];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  matchQuestions.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    LUMatchQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCELL"];
    
    if(cell == nil)
    {
        cell = [[LUMatchQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"matchCELL"];
    }
    cell.matchQuestions.text = [matchQuestions objectAtIndex:indexPath.row];
    cell.matchOption.text = [matchOptions objectAtIndex:indexPath.row ];
    cell.matchingAnswer.delegate = self;
    cell.matchingAnswer.tag = [indexPath row]+1;
    cell.matchingAnswer = [selectionMatch objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [selectionMatch setObject:textField.text forKey:[NSString stringWithFormat:@"%ld", textField.tag]];
}
/**
 <#Description#>
 
 @param theTimer <#theTimer description#>
 */
-(void)updateCounter:(NSTimer *)theTimer
{
    if(_tempsecondsLeft > 0 )
    {
        _tempsecondsLeft -- ;
        hours  =  _tempsecondsLeft / 3600;
        minutes  =  (_tempsecondsLeft % 3600) / 60;
        seconds  =  (_tempsecondsLeft %3600) % 60;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
