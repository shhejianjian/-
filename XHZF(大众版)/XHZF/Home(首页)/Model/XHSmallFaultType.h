//
//  XHSmallFaultType.h
//  XHZF
//
//  Created by 谢琰 on 16/4/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHSubSmallFaultType;

@interface XHSmallFaultType : NSObject
@property (nonatomic, copy) NSString * lastUpdateTime;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) XHSubSmallFaultType *subSmallFaultType;
@end
