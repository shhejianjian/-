//
//  XHMoreViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHMoreViewController.h"

@interface XHMoreViewController ()

@end

@implementation XHMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    NSLog(@"finish");
}


@end
