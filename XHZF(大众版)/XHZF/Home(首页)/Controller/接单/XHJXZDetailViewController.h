//
//  XHJXZDetailViewController.h
//  XHZF
//
//  Created by 谢琰 on 16/5/12.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHReceiver;
@interface XHJXZDetailViewController : UIViewController
@property (nonatomic, strong) XHReceiver *JXZReceiver;
@property (nonatomic, strong) NSArray *JXZProcesses;
@property (nonatomic, strong) NSString *workOrderCode;
@property (nonatomic, strong) NSString *receiverId;
@end
