//
//  XHDepartment.h
//  XHZF
//
//  Created by 谢琰 on 16/4/8.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class XHSubDepartment;
@interface XHDepartment : NSObject
@property (nonatomic ,copy) NSString *orderNo;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *leaf;
@property (nonatomic ,copy) NSString *objectId;
@property (nonatomic ,strong) NSArray *items;
//@property (nonatomic ,strong) XHSubDepartment *subDepartment;

@end
