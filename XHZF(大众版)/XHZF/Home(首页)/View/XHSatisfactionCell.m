//
//  XHSatisfactionCell.m
//  XHZF
//
//  Created by 谢琰 on 16/5/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSatisfactionCell.h"
#import "XHSubSatification.h"
#import "XHConst.h"
#import "BFPaperButton.h"

@interface XHSatisfactionCell()
@property (nonatomic, weak) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *subjectLable;
@property (weak, nonatomic) IBOutlet UIButton *scoreFiveButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreFourButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreOneButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreZeroButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *fiveButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *fourButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *threeButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *twoButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *oneButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *zeroButton;


@end
@implementation XHSatisfactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scoreZeroButton.layer.cornerRadius = 20.0f;
    self.scoreZeroButton.layer.masksToBounds = YES;
    self.scoreZeroButton.layer.borderWidth = 1.0f;
    self.scoreZeroButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.scoreOneButton.layer.cornerRadius = 20.0f;
    self.scoreOneButton.layer.masksToBounds = YES;
    self.scoreOneButton.layer.borderWidth = 1.0f;
    self.scoreOneButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.scoreTwoButton.layer.cornerRadius = 20.0f;
    self.scoreTwoButton.layer.masksToBounds = YES;
    self.scoreTwoButton.layer.borderWidth = 1.0f;
    self.scoreTwoButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.scoreThreeButton.layer.cornerRadius = 20.0f;
    self.scoreThreeButton.layer.masksToBounds = YES;
    self.scoreThreeButton.layer.borderWidth = 1.0f;
    self.scoreThreeButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.scoreFourButton.layer.cornerRadius = 20.0f;
    self.scoreFourButton.layer.masksToBounds = YES;
    self.scoreFourButton.layer.borderWidth = 1.0f;
    self.scoreFourButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.scoreFiveButton.layer.cornerRadius = 20.0f;
    self.scoreFiveButton.layer.masksToBounds = YES;
    self.scoreFiveButton.layer.borderWidth = 1.0f;
    self.scoreFiveButton.layer.borderColor = XHGlobalColor.CGColor;
    
    self.fiveButton.tapCircleDiameter = 100;
    self.fiveButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.fiveButton.usesSmartColor = NO;
    self.fiveButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.fiveButton.shadowColor = [UIColor clearColor];
    
    self.fourButton.tapCircleDiameter = 100;
    self.fourButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.fourButton.usesSmartColor = NO;
    self.fourButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.fourButton.shadowColor = [UIColor clearColor];

    self.threeButton.tapCircleDiameter = 100;
    self.threeButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.threeButton.usesSmartColor = NO;
    self.threeButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.threeButton.shadowColor = [UIColor clearColor];
    
    self.twoButton.tapCircleDiameter = 100;
    self.twoButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.twoButton.usesSmartColor = NO;
    self.twoButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.twoButton.shadowColor = [UIColor clearColor];

    self.oneButton.tapCircleDiameter = 100;
    self.oneButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.oneButton.usesSmartColor = NO;
    self.oneButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.oneButton.shadowColor = [UIColor clearColor];

    self.zeroButton.tapCircleDiameter = 100;
    self.zeroButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    self.zeroButton.usesSmartColor = NO;
    self.zeroButton.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.zeroButton.shadowColor = [UIColor clearColor];

    // Initialization code
}
- (void)setSubSatis:(XHSubSatification *)subSatis
{
    _subSatis = subSatis;
    self.subjectLable.text = [NSString stringWithFormat:@"%ld . %ld %@",((long)self.indexPath.section +1),((long)self.indexPath.item + 1),subSatis.name];
    self.subjectLable.textColor = [UIColor darkGrayColor];
    if ([subSatis.score isEqualToString:@"5"]) {
        self.scoreFiveButton.selected = YES;
        self.scoreFourButton.selected = NO;
        self.scoreThreeButton.selected = NO;
        self.scoreTwoButton.selected = NO;
        self.scoreOneButton.selected = NO;
        self.scoreZeroButton.selected = NO;

    }else if ([subSatis.score isEqualToString:@"4"]){
        self.scoreFourButton.selected = YES;
        self.scoreFiveButton.selected = NO;
        self.scoreThreeButton.selected = NO;
        self.scoreTwoButton.selected = NO;
        self.scoreOneButton.selected = NO;
        self.scoreZeroButton.selected = NO;
    }else if ([subSatis.score isEqualToString:@"3"]){
        self.scoreThreeButton.selected = YES;
        self.scoreFourButton.selected = NO;
        self.scoreFiveButton.selected = NO;
        self.scoreTwoButton.selected = NO;
        self.scoreOneButton.selected = NO;
        self.scoreZeroButton.selected = NO;
    }else if ([subSatis.score isEqualToString:@"2"]){
        self.scoreTwoButton.selected = YES;
        self.scoreThreeButton.selected = NO;
        self.scoreFourButton.selected = NO;
        self.scoreFiveButton.selected = NO;
        self.scoreOneButton.selected = NO;
        self.scoreZeroButton.selected = NO;
    }else if ([subSatis.score isEqualToString:@"1"]){
        self.scoreOneButton.selected = YES;
        self.scoreTwoButton.selected = NO;
        self.scoreThreeButton.selected = NO;
        self.scoreFourButton.selected = NO;
        self.scoreFiveButton.selected = NO;
        self.scoreZeroButton.selected = NO;
    }else if ([subSatis.score isEqualToString:@"0"]){
        self.scoreZeroButton.selected = YES;
        self.scoreOneButton.selected = NO;
        self.scoreTwoButton.selected = NO;
        self.scoreThreeButton.selected = NO;
        self.scoreFourButton.selected = NO;
        self.scoreFiveButton.selected = NO;
    }else {
        self.scoreZeroButton.selected = NO;
        self.scoreOneButton.selected = NO;
        self.scoreTwoButton.selected = NO;
        self.scoreThreeButton.selected = NO;
        self.scoreFourButton.selected = NO;
        self.scoreFiveButton.selected = NO;
    }
}
- (IBAction)five:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreFiveButton.selected = YES;
    self.selectedBtn = self.scoreFiveButton;
    self.subSatis.score = @"5";
 if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreFive];
    }
}
- (IBAction)four:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreFourButton.selected = YES;
    self.selectedBtn = self.scoreFourButton;
    self.subSatis.score = @"4";
    if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreFour];
    }
}
- (IBAction)three:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreThreeButton.selected = YES;
    self.selectedBtn = self.scoreThreeButton;
    self.subSatis.score = @"3";
    if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreThree];
    }
}
- (IBAction)two:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreTwoButton.selected = YES;
    self.selectedBtn = self.scoreTwoButton;
    self.subSatis.score = @"2";
    if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreTwo];
    }
}
- (IBAction)one:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreOneButton.selected = YES;
    self.selectedBtn = self.scoreOneButton;
    self.subSatis.score = @"1";
    if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreOne];
    }
}
- (IBAction)zero:(UIButton *)sender {
    self.selectedBtn.selected = NO;
    self.scoreZeroButton.selected = YES;
    self.selectedBtn = self.scoreZeroButton;
    self.subSatis.score = @"0";
    if ([self.delegate respondsToSelector:@selector(satisfactionCell:didClickScore:)]) {
        [self.delegate satisfactionCell:self didClickScore:XHSatisfactionCellScoreZero];
    }
}

@end
