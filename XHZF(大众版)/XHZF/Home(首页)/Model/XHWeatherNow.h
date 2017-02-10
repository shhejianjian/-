//
//  XHWeatherNow.h
//  XHZF
//
//  Created by 谢琰 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHWeatherCond;
@interface XHWeatherNow : NSObject
@property (nonatomic, copy) NSString *pres;
@property (nonatomic, copy) NSString *tmp;
@property (nonatomic, copy) NSString *hum;
@property (nonatomic, copy) NSString *vis;
@property (nonatomic, strong) XHWeatherCond *cond;
@property (nonatomic, copy) NSString *fl;
@property (nonatomic, copy) NSString *pcpn;
@end
