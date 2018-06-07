//
//  LUOptionalQuestionDataManager.h
//  LUStudent

//  Created by Preeti Patil on 02/11/17.
//  Copyright © 2017 Set Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface LUOptionalQuestionDataManager : NSObject

{

NSString *DataPath;
}
+(LUOptionalQuestionDataManager*)getSharedInstance;
-(BOOL)createOptinalQuestionDB:(NSString*)DBName;
-(BOOL)saveOptinalQusetion:(NSString*)QNo Qusetion:(NSString *)QuestionType Options:(NSString *)OptionSelect DB:(NSString *)DBName ;
-(BOOL)updateOptinalQusetion:(NSString*)QNo Qusetion:(NSString *)QuestionType  Options:(NSString *)OptionSelect DB:(NSString *)DBName;
-(NSArray*)ShowAll:(NSString*)DBName;
@end
