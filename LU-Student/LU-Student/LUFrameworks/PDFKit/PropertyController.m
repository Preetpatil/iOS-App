//
//  PropertyController.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.
//
//

#import "PropertyController.h"

@interface PropertyController ()
{
    UIImageView *imageView;
}

@end

@implementation PropertyController

@synthesize lineAlpha,lineColor,lineWidth,colorButton,popover;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageView  =  [[UIImageView alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear  =  NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem  =  self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationItem.title  =  @"Properties";
    popover.arrowDirection  =  PopoverArrowDirectionUp;
    popover.contentSize  =  CGSizeMake(350, 250);
    popover.contentView.frame  =  CGRectMake(popover.contentView.frame.origin.x, popover.contentView.frame.origin.y, popover.contentView.frame.size.width, 250);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}
- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
    static NSString *CellIdentifier  =  @"Cell";
    UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell  ==  nil) {
        cell  =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *str1;
    if(indexPath.row == 0){
        
        
        
        UIButton *btn0  =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn0 addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchDown];
        [btn0 setBackgroundColor:[UIColor yellowColor]];
        btn0.frame  =  CGRectMake(10, 10, 40, 40);
        btn0.layer.cornerRadius = 20;
        btn0.tag = 0;
        [self.view addSubview:btn0];
        
        UIButton *btn1  =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn1 addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchDown];
        [btn1 setBackgroundColor:[UIColor blueColor]];
        btn1.frame  =  CGRectMake(60, 10, 40, 40);
        btn1.layer.cornerRadius = 20;
        btn1.tag = 1;
        [self.view addSubview:btn1];
        
        UIButton *btn2  =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn2 addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchDown];
        [btn2 setBackgroundColor:[UIColor orangeColor]];
        btn2.frame  =  CGRectMake(110, 10, 40, 40);
        btn2.layer.cornerRadius = 20;
        btn2.tag = 2;
        [self.view addSubview:btn2];
        
        UIButton *btn3  =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn3 addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchDown];
        [btn3 setBackgroundColor:[UIColor cyanColor]];
        btn3.frame  =  CGRectMake(160, 10, 40, 40);
        btn3.layer.cornerRadius = 20;
        btn3.tag = 3;
        [self.view addSubview:btn3];
        
        UIButton *btn4 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn4 addTarget:self action:@selector(clicks:) forControlEvents:UIControlEventTouchDown];
        [btn4 setBackgroundColor:[UIColor magentaColor]];
        btn4.frame  =  CGRectMake(210, 10, 40, 40);
        btn4.layer.cornerRadius = 20;
        btn4.tag = 4;
        [self.view addSubview:btn4];
        
        
        
        //[cell.contentView addSubview:imageView];
    }else if(indexPath.row == 1){
        str1  =  @"Thickness";
        UISlider *sliderThick  =  [[UISlider alloc] initWithFrame:CGRectMake(110, 13, 170, 20)];
        sliderThick.minimumValue  =  1;
        sliderThick.maximumValue  =  20;
        sliderThick.value  =  [lineWidth floatValue];
        [sliderThick addTarget:self action:@selector(sliderThickAction:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sliderThick];
        cell.selectionStyle  =  UITableViewCellSelectionStyleNone;
    }else if(indexPath.row == 2){
        str1  =  @"Opacity";
        UISlider *sliderOpa  =  [[UISlider alloc] initWithFrame:CGRectMake(110, 13, 170, 20)];
        sliderOpa.minimumValue  =  0.1;
        sliderOpa.maximumValue  =  0.8;
        sliderOpa.value  =  [lineAlpha floatValue];
        [sliderOpa addTarget:self action:@selector(sliderAlphaAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sliderOpa];
        cell.selectionStyle  =  UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text  =  str1;
    
    return cell;
}

//------------------------------------------------------------------------------
#pragma mark - Table view delegate
//------------------------------------------------------------------------------

- (void) tableView: (UITableView*) tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
    if (indexPath.row == 0) {
    }
}
- (void)sliderThickAction:(UISlider *)sender
{
    lineWidth  =  [NSNumber numberWithFloat:sender.value];
}
- (void)sliderAlphaAction:(UISlider *)sender
{
    lineAlpha  =  [NSNumber numberWithFloat:sender.value];
}

-(void)clicks:(id)sender{
    switch ([sender tag]) {
        case 0:
            self.lineColor = [UIColor yellowColor];
            break;
        case 1:
            self.lineColor = [UIColor blueColor];
            break;
        case 2:
            self.lineColor = [UIColor orangeColor];
            break;
        case 3:
            self.lineColor = [UIColor cyanColor];
            break;
        case 4:
            self.lineColor = [UIColor magentaColor];
            break;
        
    }
    
}



-(void)setImageView:(UIColor *)color{
    CGRect myFrame  =  CGRectMake(240, 12, 20, 20);
    UIImage *colorCircle;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
    CGContextRef ctx  =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGRect rect  =  CGRectMake(0, 0, 20, 20);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    // set stroking color and draw circle
    //CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGRect circleRect  =  CGRectMake(0, 0, 20, 20);
    circleRect  =  CGRectInset(circleRect, 3, 3);
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    CGContextRestoreGState(ctx);
    colorCircle  =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView setImage:colorCircle];
    [imageView setFrame:myFrame];
    
    [self.colorButton setImage:colorCircle forState:UIControlStateNormal];
}
@end
