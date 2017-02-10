//
//  XHEquipment.m
//  XHZF
//
//  Created by 谢琰 on 16/4/11.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHEquipment.h"
#import "MJExtension.h"
@implementation XHEquipment
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"items" : @"XHSubEquipment"
             };
}
MJCodingImplementation

@end
