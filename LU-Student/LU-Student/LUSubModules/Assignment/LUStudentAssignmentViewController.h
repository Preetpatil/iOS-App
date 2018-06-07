//
//  LUStudentAssignmentViewController.h
//  LUStudent

//  Created by Preeti Patil on 05/06/18.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUURLLink.h"
#import "LUHeader.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface LUStudentAssignmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,LUDelegate,MFMailComposeViewControllerDelegate,UIDocumentPickerDelegate,DataDelegate>

@end
