//
//  DBManager.h
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/27.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+ (DBManager*)getSharedInstance;
- (BOOL)createDB;
- (NSMutableArray *)findAll;
- (BOOL)saveData:(NSString *)registerNumber name:(NSString *)name
      department:(NSString *)department year:(NSString *)year;

@end

NS_ASSUME_NONNULL_END
