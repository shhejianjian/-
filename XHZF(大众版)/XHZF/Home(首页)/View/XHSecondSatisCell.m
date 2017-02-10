//
//  XHSecondSatisCell.m
//  XHZF
//
//  Created by 谢琰 on 16/5/10.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSecondSatisCell.h"
#import "XHConst.h"
@interface XHSecondSatisCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *previewLable;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
@implementation XHSecondSatisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.submitButton.layer.cornerRadius = 20.0f;
    self.submitButton.layer.borderWidth = 1.0f;
    self.submitButton.layer.borderColor = XHGlobalColor.CGColor;
    self.submitButton.layer.masksToBounds = YES;
    self.textView.delegate = self;
    // Initialization code
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"调查问卷%@",textView.text);
    if (textView.text.length != 0) {
        self.previewLable.hidden = YES;
    }else{
        self.previewLable.hidden = NO;
    }
}
- (IBAction)btnSubmitDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(secondSatisCellCellSubmitButtonDidClick:)]) {
        [self.delegate secondSatisCellCellSubmitButtonDidClick:self];
    }
}

@end
