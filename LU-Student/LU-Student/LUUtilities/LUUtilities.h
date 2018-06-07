//
//  LUUtilities.h
//  LUStudent
//
//  Created by Preeti on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUActivityIndicator.h"
#import "LUHeader.h"
#import "LUStudentAppDelegate.h"
#import "LUReachability.h"

typedef void(^LUAlertClickBlock) (void);

@interface LUUtilities : NSObject
{
    
}
+(BOOL)saveNotes:(NSString *)unitName pageNumber:(NSString *)pageNo pageImage:(UIImage *)pageBlob;
+(UIView *)showActivityIndicator:(CGRect)size;
+(UIView *)removeActivityIndicator;
+(UIView *)alertView:(CGRect)size heading:(NSString *)head content:(NSString *)message ok:(BOOL)enableOK cancel:(BOOL)enableCancel;



+(void)showAlertView:(CGRect)rect;


+(BOOL)isNetworkReachable; //trial



@property(nonatomic,copy)LUAlertClickBlock cancelButtonClickBlock;
@property(nonatomic,copy)LUAlertClickBlock okButtonClickBlock;

@end
