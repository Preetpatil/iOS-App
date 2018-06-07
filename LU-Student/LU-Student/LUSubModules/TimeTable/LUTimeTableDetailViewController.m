//
//  LUTimeTableDetailViewController.m
//  LUStudent

//  Created by Preeti Patil on 10/02/17.
//  Copyright © 2017 SETINFOTECH. All rights reserved.
//

#import "LUTimeTableDetailViewController.h"

@interface LUTimeTableDetailViewController ()

@end

@implementation LUTimeTableDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"detailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text =[_detailArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    _data=[NSString stringWithFormat:@"%@",[_detailArray objectAtIndex:indexPath.row]];
    NSLog(@"%@",_data);
    
    if ([_delegatemethod respondsToSelector:@selector(passData:)])
    {
        [_delegatemethod passData:_data ]; //pass  response to the selector method
    }
    
}

@end
