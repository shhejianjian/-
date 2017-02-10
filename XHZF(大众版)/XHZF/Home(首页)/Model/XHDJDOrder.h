//
//  XHDJDOrder.h
//  XHZF
//
//  Created by 谢琰 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDJDOrder : NSObject
@property (nonatomic, copy) NSString * workOrderCode;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *requestTime;
@property (nonatomic, copy) NSString *typeTag;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *equipment;
@property (nonatomic, copy) NSString *faultType;
@property (nonatomic, copy) NSString *building;
@property (nonatomic, copy) NSString *receiverId;
@property (nonatomic, copy) NSString *workOrderId;

@end
