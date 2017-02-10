//
//  FMDBTool.h
//  XHZF
//
//  Created by 谢琰 on 16/4/26.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHDepartment, XHEquipment ,XHSatification;

@interface FMDBTool : NSObject
+ (NSArray *)departments;
+ (void)addDepartment:(XHDepartment *)department;
+ (NSArray *)equipments;
+ (void)addEquipment:(XHEquipment *)equipment;
+ (NSArray *)addresses;
+ (void)addAddress:(XHDepartment *)address;
+ (NSArray *)satisfications;
+ (void)addSatisfication:(XHSatification *)satisfication;
@end
