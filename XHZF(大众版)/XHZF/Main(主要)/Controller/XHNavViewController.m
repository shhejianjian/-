//
//  XHNavViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHNavViewController.h"
#import "XHConst.h"
@interface XHNavViewController ()

@end

@implementation XHNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    textAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
    bar.titleTextAttributes = textAttr;
    [[UINavigationBar appearance] setBarTintColor:XHGlobalColor];
    [bar setShadowImage:[UIImage new]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
