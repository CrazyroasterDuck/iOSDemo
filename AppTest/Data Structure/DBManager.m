//
//  DBManager.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/9/27.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "DBManager.h"
#import "Person.h"

static DBManager *sharedInstance = nil;
static dispatch_once_t onceToken = 0;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager
+ (DBManager *)getSharedInstance{
    if(!sharedInstance){
        dispatch_once(&onceToken, ^{
         sharedInstance = [[self alloc] init];
         });
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
            "create table if not exists studentsDetail(regno integer primary key,name text,department text,year text);";
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

- (void)savePersonInfo:(NSNotification *)notification{
    Person *person =  notification.object;
    self.isSavedSucess = [self saveData:person.registerNumber name:person.name department:person.department year:person.year];
}

//对保存逻辑进行进行更新和插入的判断
- (BOOL)saveData:(NSString *)registerNumber name:(NSString *)name
      department:(NSString *)department year:(NSString *)year{
    BOOL isExist = [self findPersonByRegno:registerNumber];
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *saveSQL;
        if(isExist){
            saveSQL = [NSString stringWithFormat:@"update studentsDetail set name='%@',department='%@',year='%@' where regno= %ld",name,department,year,[registerNumber integerValue]];
        }else{
            saveSQL = [NSString stringWithFormat:@"INSERT INTO studentsDetail (regno,name,department,year)VALUES(%ld,'%@','%@','%@');",
                        [registerNumber integerValue],name,department,year];
        }
        const char *insert_stmt = [saveSQL UTF8String];
        char *errMsg;
        int result = sqlite3_exec(database, insert_stmt, NULL, NULL, &errMsg);
        sqlite3_close(database);
        if( result == SQLITE_OK){
            return YES;
        } else{
            NSLog(@"%s",errMsg);
        }
    }
    return NO;
    
}


- (NSMutableArray *)findAll{
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *query_stmt = "select regno, name,department,year from studentsDetail order by regno asc;";
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        int result = sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL);
        if(result == SQLITE_OK){
            NSArray *arry;
            while(sqlite3_step(statement) ==  SQLITE_ROW){
                //查询到的结果可能不止一条，直到sqlite3_step(stmt) != SQLITE_ROW,查询结束
                NSString *regno = [[NSString alloc] initWithFormat:@"%d", sqlite3_column_int(statement,0)];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                NSString *department = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                NSString *year = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,3)];
                arry = [[NSArray alloc] initWithObjects:regno,name,department,year, nil];
                [resultArray addObject:arry];
            }
            return resultArray;
        }
        sqlite3_reset(statement);
    }
    NSLog(@"Not found");
    return nil;
}

- (BOOL)findPersonByRegno:(NSString *)registerNumber{
    BOOL isSuccess = NO;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
    NSString *querySQL = [NSString stringWithFormat:@"select name,department,year from studentsDetail where regno = %ld",[registerNumber integerValue]];
        if(sqlite3_prepare_v2(database, [querySQL UTF8String], -1, &statement,NULL) == SQLITE_OK){
            if(sqlite3_step(statement) ==  SQLITE_ROW){
                isSuccess = YES;
            }
        }
        sqlite3_reset(statement);
    }
    sqlite3_close(database);
    NSLog(@"Not found");
    return isSuccess;
}

//只有四个属性相同才准予删除
- (void)deleteInfo:(NSArray *)arr {
    const char *dbpath = [databasePath UTF8String];
    NSString *regno = arr[0];
    NSString *name = arr[1];
    NSString *dept = arr[2];
    NSString *year = arr[3];
    if(sqlite3_open(dbpath, &database) == SQLITE_OK){
        char *errmsg;
        const char *sql_del = [[NSString stringWithFormat:@"delete from studentsDetail where regno = %ld and name = '%@' and department = '%@' and year = '%@';",(long)[regno integerValue],name,dept,year] UTF8String];
        sqlite3_exec(database, sql_del, NULL, NULL, &errmsg);
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
