//
//  LUStudentProfileViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUStudentProfileViewController.h"
#import "LUStudentProfileSubjectTableCell.h"
#import "LUStudentProfileCollectionViewCell.h"

@interface LUStudentProfileViewController ()

@end

@implementation LUStudentProfileViewController
{
        IBOutlet UIImageView *studentimage;
        IBOutlet UILabel *namelbl;
        IBOutlet UICollectionView *collectionview;
        NSArray *keyIcon;
    
        NSArray *keys,*lblKeys;
        NSArray *values;
    
        IBOutlet UITableView *subjectTableView;
        NSArray *subjectList;
        NSDictionary *profileDetails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"yourKeyName"];
    profileDetails = [[NSKeyedUnarchiver unarchiveObjectWithData:data] objectForKey:@"item"];
    [self studentProfileDetails:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
   
}


/*
 profileDetails = {
 "Configuration Details" =     {
 "class_id" = 2;
 "parent_id" = 5;
 password = student;
 "school_id" = 13;
 "student_id" = 3;
 "user_name" = student;
 "user_role_id" = 3;
 };
 Message = Success;
 "Profile Details" =     {
 Address = "PG , Ecity Phase I, Bangalore, karnataka, India, 560100";
 "class_name" = "Two A";
 dob = "09/16/1994";
 "full_name" = "Gayathri Shanmugam";
 gender = Female;
 "mobile_no" = 9856478662;
 "phone_no" = "04286 54658";
 profile = "http://setumbrella.in/img/user.png";
 "roll_no" = 11CA204;
 "student_email" = "gayathri@setinfotech.com";
 };
 }
 
 "Subject List" =     {
 "class_id" = 2;
 "subject_code" = 1001;
 "subject_id" = 1;
 "subject_name" = Physics;
 "teacher_id" = 4;
 "teacher_name" = "Raja Gopal";
 };

 */

// fetch image
/**
 <#Description#>

 @param imageURL <#imageURL description#>
 */
- (void) fetchImage: (NSString *)imageURL
{
    NSURL *url = [NSURL URLWithString:imageURL];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    studentimage.image = image;
                }
            }
        });
        
        
    }];
    [task resume];

}
//-(void) studentProfileDetails: (NSDictionary *)profileDetails //For user profile details.
/**
 <#Description#>

 @param studentProfileDetails <#studentProfileDetails description#>
 */
-(void) studentProfileDetails: (NSDictionary *)studentProfileDetails
{
    NSLog(@"profileDetails = %@",studentProfileDetails);
    
    namelbl.text =[NSString stringWithFormat:@"%@ %@ %@",[[studentProfileDetails valueForKey:@"item"] valueForKeyPath:@"StudentFirstName"],[[studentProfileDetails valueForKey:@"item"] valueForKeyPath:@"StudentMiddleName"],[[studentProfileDetails valueForKey:@"item"] valueForKeyPath:@"StudentLastName"]];
   
    
    //studentimage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[studentProfileDetails valueForKey:@"item"] valueForKey:@"StudentProfileImage"]]];
    
    [self fetchImage: [[studentProfileDetails valueForKey:@"item"] valueForKey:@"StudentProfileImage"]];
    
    subjectList = [[studentProfileDetails valueForKey:@"item"] objectForKey:@"SubjectData"];
    
    keyIcon = @[@"RollNo.png",@"DateOfBirth.png",@"Email.png",@"Address.png",@"class.png",@"Gender.png",@"phone.png"];
    
    keys = @[@"StudentRollNumber",@"DateOfBirth",@"StudentEmail",@"CityName",@"ClassName",@"Gender",@"StudentMobileNumber"];
    lblKeys = @[@"Roll Number",@"Date Of Birth",@"Email",@"Address",@"Class",@"Gender",@"MobileNumber"];
    
    [collectionview reloadData];
    [subjectTableView reloadData];
    
}

#pragma mark CollectionView Delegate Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return keys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LUStudentProfileCollectionViewCell *cell  =  [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.lblkeys.text  = [lblKeys objectAtIndex:indexPath.row];
    if ([cell.lblkeys.text isEqualToString:@"Address"])
    {
        cell.lblvalues.text =[NSString stringWithFormat:@"%@ %@ %@ %@",[profileDetails objectForKey:@"CityName"],[profileDetails objectForKey:@"StateName"],[profileDetails objectForKey:@"CountryName"],[profileDetails objectForKey:@"StudentZipCode"]];
        cell.studentimage.image =[UIImage imageNamed: [keyIcon objectAtIndex:indexPath.row]];
    }else
    {
        
        if ([[keys objectAtIndex:indexPath.row] isEqualToString:@"ClassName"])
        {
            cell.lblvalues.text = [NSString stringWithFormat:@"%@ %@",[profileDetails objectForKey:[keys objectAtIndex:indexPath.row]],[profileDetails objectForKey:@"SectionName"]];
            cell.studentimage.image =[UIImage imageNamed: [keyIcon objectAtIndex:indexPath.row]];
        } else
        {
        cell.lblvalues.text = [profileDetails objectForKey:[keys objectAtIndex:indexPath.row]];
        cell.studentimage.image =[UIImage imageNamed: [keyIcon objectAtIndex:indexPath.row]];
        }
        
    }
    
    return cell;
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//TODO depending on the array of data received
    return subjectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LUStudentProfileSubjectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subjectCell"];
    
    if (cell == nil)
    {
        cell = [[LUStudentProfileSubjectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subjectCell"];
    }
    if(indexPath.row == 0)
    {
        //cell.serialNumber.textColor = [UIColor redColor];
        //cell.serialNumber.text = @"#";
        
        cell.subjectName.textColor = [UIColor redColor];
        cell.subjectName.text= @"NAME";
        
        cell.subjectCode.textColor = [UIColor redColor];
        cell.subjectCode.text= @"CODE";
        
        cell.subjectTeacher.textColor = [UIColor redColor];
        cell.subjectTeacher.text= @"TEACHER";
        
    }
    else
    {
        //cell.serialNumber.text = [subjectList valueForKey:@"subject_id"];
        cell.subjectName.text = [[subjectList objectAtIndex:indexPath.row ] valueForKey:@"SubjectName"] ;
        cell.subjectCode.text = [[subjectList objectAtIndex:indexPath.row ] valueForKey:@"SubjectCode"];
        cell.subjectTeacher.text = [[subjectList objectAtIndex:indexPath.row ] valueForKey:@"TeacherFirstName"];

    }
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
