//
//  DBManager.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/27.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Person.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
{
    NSString *databasePath;
}

@property(nonatomic) BOOL isSavedSucess;

+ (DBManager*)getSharedInstance;
- (BOOL)createDB;
- (NSMutableArray *)findAll;
- (BOOL)saveData:(NSString *)registerNumber name:(NSString *)name
      department:(NSString *)department year:(NSString *)year;
- (void)deleteInfo:(NSArray *)arr;
- (BOOL)findPersonByRegno:(NSString *)registerNumber;
- (void)savePersonInfo:(Person *)person;
@end

NS_ASSUME_NONNULL_END
