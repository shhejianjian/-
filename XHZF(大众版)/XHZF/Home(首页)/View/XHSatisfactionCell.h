//
//  XHSatisfactionCell.h
//  XHZF
//
//  Created by 谢琰 on 16/5/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XHSatisfactionCellScoreFive,
    XHSatisfactionCellScoreFour,
    XHSatisfactionCellScoreThree,
    XHSatisfactionCellScoreTwo,
    XHSatisfactionCellScoreOne,
    XHSatisfactionCellScoreZero
} XHSatisfactionCellScore;

@class XHSatisfactionCell,XHSubSatification;

@protocol XHSatisfactionCellDelegate <NSObject>

@optional

- (void)satisfactionCell:(XHSatisfactionCell *)cell didClickScore:(XHSatisfactionCellScore)score;
@end

@interface XHSatisfactionCell : UICollectionViewCell


@property (nonatomic ,strong) XHSubSatification *subSatis;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic ,weak) id<XHSatisfactionCellDelegate>delegate;
@end
