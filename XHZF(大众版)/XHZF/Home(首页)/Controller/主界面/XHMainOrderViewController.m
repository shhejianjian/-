//
//  XHMainOrderViewController.m
//  XHZF
//
//  Created by 何键键 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHMainOrderViewController.h"
#import "SegmentTapView.h"
#import "XHDJDViewController.h"
#import "XHJXZViewController.h"
#import "XHYWCViewController.h"
#import "XHConst.h"
#import "NSString+FontAwesome.h"
#import "FlipTableView.h"
#define ScreeFrame [UIScreen mainScreen].bounds

@interface XHMainOrderViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSMutableArray *controllers;
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
//@property (strong, nonatomic) NSMutableArray *controllsArray;
@end

@implementation XHMainOrderViewController
- (NSMutableArray *)controllers
{
    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSegment];
    [self initFlipTableView];
   [self.flipView selectIndex:self.willIndex];
    [self.segment selectIndex:self.willIndex+1];
//    [self scrollChangeToIndex:self.willIndex];
    self.backBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [self.backBtn setTitleColor:XHGlobalColor forState:UIControlStateNormal];
    [self.backBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconChevronLeft] forState:UIControlStateNormal];
}

-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, ScreeFrame.size.width, 46)];
    self.segment.dataArray = [NSArray arrayWithObjects:@"待接单",@"进行中",@"已完成", nil];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    XHDJDViewController *v1 = [[XHDJDViewController alloc]init];
    XHJXZViewController *v2 = [[XHJXZViewController alloc]init];
    XHYWCViewController *v3 = [[XHYWCViewController alloc]init];
//    UINavigationController *nav2 =[[UINavigationController alloc]initWithRootViewController:v2];
//    UINavigationController *nav3 =[[UINavigationController alloc]initWithRootViewController:v3];

    [self.controllers addObject:v1];
    [self.controllers addObject:v2];
    [self.controllers addObject:v3];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 110, ScreeFrame.size.width , ScreeFrame.size.height - 110 ) withArray:_controllers];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}
#pragma mark - SegmentTapViewDelegate
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segment selectIndex:index];
}
#pragma mark - FlipTableViewDelegate
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
