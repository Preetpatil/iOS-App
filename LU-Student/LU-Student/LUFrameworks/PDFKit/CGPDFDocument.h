//
//	CGPDFDocument.h
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

//
//	Custom CGPDFDocument[...] functions
//

CGPDFDocumentRef CGPDFDocumentCreateUsingUrl(CFURLRef theURL, NSString *password);

CGPDFDocumentRef CGPDFDocumentCreateUsingData(CGDataProviderRef dataProvider, NSString *password);

BOOL CGPDFDocumentUrlNeedsPassword(CFURLRef theURL, NSString *password);

BOOL CGPDFDocumentDataNeedsPassword(CGDataProviderRef dataProvider, NSString *password);
