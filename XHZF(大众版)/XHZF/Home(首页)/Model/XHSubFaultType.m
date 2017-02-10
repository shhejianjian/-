
//
//  XHSubFaultType.m
//  XHZF
//
//  Created by 谢琰 on 16/4/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSubFaultType.h"
#import "MJExtension.h"
@implementation XHSubFaultType
+ (void)load
{
#pragma mark 如果使用NSObject来调用这些方法，代表所有继承自NSObject的类都会生效
#pragma mark NSObject中的ID属性对应着字典中的id
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"desc" : @"description"
                 };
    }];
}

@end
