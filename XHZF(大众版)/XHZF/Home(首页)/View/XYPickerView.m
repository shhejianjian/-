//
//  XYPickerView.m
//  picker
//
//  Created by 谢琰 on 16/3/14.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "XYPickerView.h"
#import "UIView+Extension.h"
@interface XYPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, assign) CGFloat ViewWidth;
@property (nonatomic, assign) CGFloat ViewHeight;
@property (nonatomic, assign) CGFloat originHeight;
@property (nonatomic, assign) CGFloat originWidth;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, assign) NSInteger index;

@end
@implementation XYPickerView

-(instancetype)initWithFrame:(CGRect)frame DataArr:(NSArray *)dataArr
{
    self = [super init];
    if (self) {
        self.ViewWidth  = frame.size.width - 20;
        self.ViewHeight = frame.size.height;
        self.originHeight = frame.origin.y;
        self.dataArr = dataArr;
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.ViewWidth)/2,([UIScreen mainScreen].bounds.size.height - self.ViewHeight)/2, self.ViewWidth, self.ViewHeight);
    }
    return self;
}

-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:[self getPickerViewFrame]];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}



-(CGRect)getPickerViewFrame
{
    CGRect rect = self.frame;
    rect.origin.x = (self.frame.size.width - self.ViewWidth) / 2.0;
    rect.origin.y = 40.0f;
    rect.size.width = self.ViewWidth;
    rect.size.height = self.ViewHeight;
    return rect;
}

-(UIView *)titleView
{
    if (_titleView!=nil) {
        return _titleView;
    }
    CGRect rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = self.ViewWidth;
    rect.size.height = 40.0f;
    _titleView = [[UIView alloc] initWithFrame:rect];
    _titleView.backgroundColor = [UIColor darkGrayColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.x = 0;
    titleLabel.y = 5;
    titleLabel.width = self.ViewWidth;
    titleLabel.height = 30;
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:titleLabel];
    [_titleView bringSubviewToFront:titleLabel];

    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 9, 55, 24);
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(btnDownCancel) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:cancelBtn];
    [_titleView bringSubviewToFront:cancelBtn];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.ViewWidth-60, 9, 55, 24);
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.layer.cornerRadius = 5;
    [sureBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:sureBtn];
    [_titleView bringSubviewToFront:sureBtn];
    return _titleView;
}

-(void)show
{
    self.layer.masksToBounds = YES;
    //设置角度
    self.layer.cornerRadius = 9 ;
    
    
    self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.coverBtn setFrame:[UIScreen mainScreen].bounds];
    [self.coverBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn.backgroundColor = [UIColor blackColor];
    self.coverBtn.alpha = 0.3;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.coverBtn];
    [window addSubview:self];
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
    
}


-(void)showPickerView
{
    [self addSubview:self.titleView];
    [self addSubview:self.pickerView];
    [self show];
}
-(void)dismiss
{
    
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (self.pickerView) {
        if (self.returnPickerStrBlock) {
            self.returnPickerStrBlock(self.dataArr[self.index]);
        }
    }
    if (!animate) {
        [self.coverBtn removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)btnDown
{
    
    [self dismiss];
}

-(void)btnDownCancel
{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}



#pragma mark Picker Data Source Methods


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArr.count;
}

#pragma mark Picker Delegate Methods

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.index = row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60.0;
}


@end
