//
//  XHOrderTableViewCell.m
//  XHZF
//
//  Created by 何键键 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOrderTableViewCell.h"
#import "XHDJDOrder.h"
#import "XHConst.h"
@interface XHOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *orderCategoryLable;
@property (weak, nonatomic) IBOutlet UILabel *buildingLable;
@property (weak, nonatomic) IBOutlet UILabel *defaultTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;

@end
@implementation XHOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 阴影颜色
    self.detailView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏差
    self.detailView.layer.shadowOffset = CGSizeMake(1, 1);
    // 阴影不透明度
    self.detailView.layer.shadowOpacity = 0.1;
    //圆角
    self.detailView.layer.cornerRadius = 5.0f;
    // 边框宽度
    self.detailView.layer.borderWidth = 1.0f;
    //边框颜色
    self.detailView.layer.borderColor = XHGrayColor.CGColor;
    
    self.orderCategoryLable.layer.cornerRadius = 28.0f;
    self.orderCategoryLable.layer.masksToBounds = YES;
}

- (void)setDjdorder:(XHDJDOrder *)Djdorder
{
    _Djdorder = Djdorder;
    if ([Djdorder.source containsString:@"快速下单"]) {
        self.buildingLable.text = Djdorder.desc;
        self.defaultTypeLable.hidden = YES;
    }else{
        self.defaultTypeLable.hidden = NO;
        self.buildingLable.text = Djdorder.building;
        self.defaultTypeLable.text = [NSString stringWithFormat:@"%@ %@",Djdorder.equipment,Djdorder.faultType];
    }
   
    self.dateLable.text = [NSString stringWithFormat:@"%@",[self covertToDateStringFromString:Djdorder.requestTime]];
    self.orderTypeLable.text = Djdorder.status;
    if (Djdorder.typeTag.length == 0) {
        self.orderCategoryLable.text = @"修";
    }else if([Djdorder.typeTag isEqualToString:@"WorkOrderType.Clean"]){
        self.orderCategoryLable.text = @"洁";
    }else if([Djdorder.typeTag isEqualToString:@"WorkOrderType.MedicalAdvice"]){
        self.orderCategoryLable.text = @"医";
    }else if([Djdorder.typeTag isEqualToString:@"WorkOrderType.Complaint"]){
        self.orderCategoryLable.text = @"诉";
    }else if([Djdorder.typeTag isEqualToString:@"WorkOrderType.Security"]){
        self.orderCategoryLable.text = @"安";
    }
    self.orderCodeLable.text = [NSString stringWithFormat:@"工单号:%@",Djdorder.workOrderCode];
}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}

@end
