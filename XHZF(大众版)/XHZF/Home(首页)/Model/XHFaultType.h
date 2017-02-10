//
//  XHFaultType.h
//  XHZF
//
//  Created by 谢琰 on 16/4/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHSubFaultType;

@interface XHFaultType : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) XHSubFaultType *subFaultType;
@end
