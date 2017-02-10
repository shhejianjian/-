
//
//  FMDBTool.m
//  XHZF
//
//  Created by 谢琰 on 16/4/26.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "FMDBTool.h"
#import "XHDepartment.h"
#import "XHEquipment.h"
#import "FMDB.h"
#import "MJExtension.h"
@implementation FMDBTool

static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"database.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_department(id integer PRIMARY KEY, department blob NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_equipment(id integer PRIMARY KEY, equipment blob NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_address(id integer PRIMARY KEY, address blob NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_satisfication(id integer PRIMARY KEY, satisfication blob NOT NULL);"];

}
+ (void)addDepartment:(XHDepartment *)department

{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:department];
    [_db executeUpdateWithFormat:@"INSERT INTO t_department(department) VALUES(%@);", data];
}

+ (NSArray *)departments
{
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_department;"];
    // 不断往下取数据
    NSMutableArray *departments = [NSMutableArray array];
    while (set.next) {
    // 获得当前所指向的数据
        XHDepartment *department = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"department"]];
        [departments addObject:department];
    }
    return departments;
}
+ (void)addEquipment:(XHEquipment *)equipment

{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:equipment];
    [_db executeUpdateWithFormat:@"INSERT INTO t_equipment(equipment) VALUES(%@);", data];
}

+ (NSArray *)equipments
{
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_equipment;"];
    // 不断往下取数据
    NSMutableArray *equipments = [NSMutableArray array];
    while (set.next) {
    // 获得当前所指向的数据
        XHEquipment *equipment = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"equipment"]];
        [equipments addObject:equipment];
    }
    return equipments;
}
+ (void)addAddress:(XHDepartment *)address

{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:address];
    [_db executeUpdateWithFormat:@"INSERT INTO t_address(address) VALUES(%@);", data];
}

+ (NSArray *)addresses
{
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_address;"];
    // 不断往下取数据
    NSMutableArray *addresses = [NSMutableArray array];
    while (set.next) {
    // 获得当前所指向的数据
        XHDepartment *address = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"address"]];
        [addresses addObject:address];
    }
    return addresses;
}


+ (NSArray *)satisfications
{
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_satisfication;"];
    // 不断往下取数据
    NSMutableArray *satisfications = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        XHSatification *satisfication = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"satisfication"]];
        [satisfications addObject:satisfication];
    }
    return satisfications;


}
+ (void)addSatisfication:(XHSatification *)satisfication
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:satisfication];
    [_db executeUpdateWithFormat:@"INSERT INTO t_satisfication(satisfication) VALUES(%@);", data];
}

@end
