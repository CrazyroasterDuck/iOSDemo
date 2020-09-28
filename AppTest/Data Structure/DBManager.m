//
//  DBManager.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/27.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager
+ (DBManager *)getSharedInstance{
    if(!sharedInstance){
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}
- (BOOL)createDB{
    NSString *docDir;
    NSArray *dirPaths;
    //Get documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = dirPaths[0];
    //Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                        [docDir stringByAppendingPathComponent:@"student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //判断数据文件是否存在
    if([filemgr fileExistsAtPath:databasePath] == NO){
        const char *dbpath = [databasePath UTF8String];
        //打开数据库
        if(sqlite3_open(dbpath, &database) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists studentsDetail(regno integer primary key,name text,department text,year text)";
            //执行数据库创建语句
            if(sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open table");
        }
    }
    return isSuccess;
}
- (BOOL)saveData:(NSString *)registerNumber name:(NSString *)name
      department:(NSString *)department year:(NSString *)year{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"insert into studentDetail (regno,name,department,year) values(\"%ld\",\"%@\",\"%@\",\"%@\")",
                               (long)[registerNumber integerValue],name,department,year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            return YES;
        }
        sqlite3_reset(statement);
    }
    return NO;
}
- (NSMutableArray *)findAll{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database)){
//        NSString *querySQL = [NSString stringWithFormat:@"select name,department,year from studentDetail where regno=\"%@\"",registerNumber];
        const char *query_stmt = "select regno, name,department,year from studentDetail";
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            NSArray *arry;
            while(sqlite3_step(statement) ==  SQLITE_ROW){
                //查询到的结果可能不止一条，直到sqlite3_step(stmt) != SQLITE_ROW,查询结束
                NSString *regno = [[NSString alloc] initWithFormat:@"%d", sqlite3_column_int(statement,0)];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                NSString *department = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                NSString *year = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];
                arry = [[NSArray alloc] initWithObjects:regno,name,department,year, nil];
                [resultArray addObject:arry];
                return resultArray;
            }
            sqlite3_reset(statement);
        }
    }
    NSLog(@"Not found");
    return nil;
}
@end
