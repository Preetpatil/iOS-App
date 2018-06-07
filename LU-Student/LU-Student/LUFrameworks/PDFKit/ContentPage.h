//
//	ContentPage.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <UIKit/UIKit.h>
#import "DrawingView.h"

@interface ContentPage : UIView

- (instancetype)initWithURL:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase;

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer;

- (void)showDrawingView:(UIImage *)image;
- (void)hideDrawingView;
- (UIImage *)getDrawingImage;

@end

#pragma mark -

//
//	DocumentLink class interface
//

@interface DocumentLink : NSObject <NSObject>

@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, assign, readonly) CGPDFDictionaryRef dictionary;

+ (instancetype)newWithRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary;

@end
