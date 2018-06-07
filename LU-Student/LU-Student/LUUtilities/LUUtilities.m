//
//  LUUtilities.m
//  LUStudent
//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUUtilities.h"

 CGFloat x,y,width,height;
static LUUtilities *luUtilitiesSharedInstance = nil;
LUActivityIndicator *aI ;




@interface LUUtilities()

@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIButton *okButton;

@end



@implementation LUUtilities
{
    
    LUReachability* netReach;
    LUReachability* hostReachable;
    
}


+(BOOL)isNetworkReachable{
    
    BOOL isReachable = NO;
    
    LUStudentAppDelegate *aAppdelegate = (LUStudentAppDelegate *)[UIApplication sharedApplication].delegate;
    
    LUReachability *netReach = [aAppdelegate reachabile];
    
    
     //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    NetworkStatus netStatus = [netReach currentReachabilityStatus];

    BOOL isConnectionRequired = [netReach connectionRequired];



    if ((netStatus == ReachableViaWiFi) || ((netStatus == ReachableViaWWAN) && !isConnectionRequired))

    {

        isReachable = YES;
       

    }


    
    return isReachable;
    

    
    
}








+(BOOL)saveNotes:(NSString *)unitName pageNumber:(NSString *)pageNo pageImage:(UIImage *)pageBlob
{
    BOOL isSave = NO;
    //NSData *imageData = UIImagePNGRepresentation(pageBlob);
   
    NSMutableData *body = [NSMutableData data];
//    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             @"school_id", @"13",
//                             @"unit_name", @"noun",
//                             @"student_id", @"3",
//                             @"class_id", @"3",
//                             @"notes_image",@"",
//                             @"subject_name", @"english",
//                             @"page_no",@"1",
//                             nil];

    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"http://setumbrella.in/learning_umbrella/notes/notes_class.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *myImage = [UIImagePNGRepresentation(pageBlob) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"13", @"13school_id",
                             @"noun", @"unit_name",
                             @"3", @"student_id",
                             @"3", @"class_id",
                             myImage,@"notes_image",
                             @"English", @"subject_name",
                             @"1",@"page_no",
                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSLog(@"%@",data);
        
        NSLog(@"%@",response);
        
    }];
    
    [postDataTask resume];
   //    const unsigned char *bytes = [imageData bytes];
//    NSUInteger length = [imageData length];
//    NSMutableArray *byteArray = [NSMutableArray array];
//    for (NSUInteger i = 0; i<length; i++)
//    {
//        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
//    }
//    
//    //http://setumbrella.in/learning_umbrella/notes/notes_class.php?school_id=13&unit_name=gg&student_id=3&class_id=3&notes_image=sdfdfgdfg
//    //notes_image
//    
//    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://setumbrella.in/learning_umbrella/notes/notes_class.php"];
//    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"school_id" value:@"13"],
//                              [NSURLQueryItem queryItemWithName:@"unit_name" value:@"noun"],
//                              [NSURLQueryItem queryItemWithName:@"student_id" value:@"3"],
//                              [NSURLQueryItem queryItemWithName:@"class_id" value:@"3"],
//                              [NSURLQueryItem queryItemWithName:@"notes_image" value:[NSString stringWithFormat:@"%@",byteArray]],
//                              [NSURLQueryItem queryItemWithName:@"subject_name" value:@"English"],
//                              [NSURLQueryItem queryItemWithName:@"page_no" value:@"1"]
//                               ];
//                              
//    NSURL *url = components.URL;
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]  dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//        //    {
//        if(error)
//        {
//            NSLog(@"Error = %@", error);
//        }
//        else
//        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                NSLog(@"Response = %@", response);
//                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"result = %@", result);
//            });
//            
//        }
//        
//    }];
//    [dataTask resume];
//    
//
//    
//    
//    
    
    return isSave;
}

+(UIView *)showActivityIndicator:(CGRect)size
{
    x = 0;
    y = 0;
    width = size.size.width;
    height = size.size.height;
        aI = [[LUActivityIndicator alloc]initWithFrame:CGRectMake(x, y, width,height)];
    aI.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.6];
    return aI;
}

+(UIView *)removeActivityIndicator
{
    return aI;
}
+(void)showAlertView:(CGRect)rect
{
  }
//+(UIView *)alertView:(CGRect)size heading:(NSString *)head content:(NSString *)message ok:(BOOL)enableOK cancel:(BOOL)enableCancel
//{
//    alertView = [[UIView alloc]initWithFrame:size];
//    
//    alertView.backgroundColor = [UIColor clearColor];
//  
//    UIImageView *base = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, alertView.frame.size.width , alertView.frame.size.height)];
//    base.image = [UIImage imageNamed:@"alertBG.png"];
//    [alertView addSubview:base];
//    
//    UILabel *heading = [[UILabel alloc]initWithFrame:CGRectMake(base.frame.size.width/2-100,base.frame.size.height-(base.frame.size.height-120),200, 30)];
//    heading.textAlignment = 1;
//    heading.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
//    heading.textColor = [UIColor whiteColor];
//    heading.text = head;
//    [base addSubview:heading];
//    
//    UITextView *textArea = [[UITextView alloc]initWithFrame:CGRectMake(20, base.frame.size.height-(base.frame.size.height-150),alertView.frame.size.width-20,alertView.frame.size.height-200)];
//    textArea.text = message;
//    textArea.backgroundColor = [UIColor clearColor];
//    [textArea setScrollEnabled:YES];
//    textArea.showsHorizontalScrollIndicator = NO;
//    textArea.editable = NO;
//    //textArea.frame = CGRectMake(20, 148, 560, 152);
//    [textArea setUserInteractionEnabled:YES];
//    textArea.textColor = [UIColor whiteColor];
//    [alertView addSubview:textArea];
//    if (enableOK == YES && enableCancel == NO)
//    {
//        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(size.size.width/2-100,size.size.height-40 , 200, 30)];
//        [leftBtn setTitle:@"Ok" forState:UIControlStateNormal];
//        
//        [leftBtn addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:leftBtn];
//    }else if(enableOK == NO && enableCancel == YES)
//    {
//        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(size.size.width/2-100,size.size.height-40 , 200, 30)];
//        [rightBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//        [rightBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:rightBtn];
//
//        
//    }else if (enableOK && enableCancel == YES)
//    {
//        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, size.size.height-40 , 200, 30)];
//        [leftBtn setTitle:@"Ok" forState:UIControlStateNormal];
//        
//        [leftBtn addTarget:[LUUtilities class] action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:leftBtn];
//        
//        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(size.size.width-250, size.size.height-40, 200, 30)];
//        [rightBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//        
//        [rightBtn addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [alertView addSubview:rightBtn];
//
//    }
//    else if (enableOK && enableCancel == NO)
//    {
//        
//    }
//    
//    return alertView;
//}
@end
