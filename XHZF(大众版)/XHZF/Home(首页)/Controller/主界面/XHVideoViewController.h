//
//  XHVideoViewController.h
//  XHZF
//
//  Created by 何键键 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHVideoViewController : UIViewController
@property (nonatomic, copy) void(^returnFileNameBlock)(NSString *fileName);
@end
