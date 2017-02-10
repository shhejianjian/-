//
//  XHSatisfactionViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSatisfactionViewController.h"
#import "BSHttpTool.h"
#import "XHConst.h"
#import "XHSatification.h"
#import "MJExtension.h"
#import "XHLayout.h"
#import "XHSatisfactionCell.h"
#import "SVProgressHUD.h"
#import "XHSubSatification.h"
#import "XHSecondSatisCell.h"
#import "IQKeyboardManager.h"
#import "UIBarButtonItem+Extension.h"
#import "XHCategoryTableView.h"
#import "XHSatis.h"
#import "XHSubSatis.h"
@interface XHSatisfactionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XHSatisfactionCellDelegate,XHSecondSatisCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLable;
@property (weak, nonatomic) IBOutlet UILabel *indexLable;
@property (assign ,nonatomic) int currentPage;
@property (strong ,nonatomic) NSIndexPath *indexPath;
@property (nonatomic ,strong) NSMutableArray *satifacations;

@end

@implementation XHSatisfactionViewController

static NSString * const reuseIdentifier1 = @"BSSatisfactionCell1";
static NSString * const reuseIdentifier2 = @"BSSatisfactionCell2";
- (NSMutableArray *)satifacations
{
    if (!_satifacations) {
        _satifacations = [[NSMutableArray alloc]init];
    }
    return _satifacations;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    self.navigationItem.title = @"调查问卷";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(showTableView) image:@"icon_pathMenu_more_normal" highImage:nil];
       [self loadSatifications];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XHSatisfactionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XHSecondSatisCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier2];
    self.collectionView.collectionViewLayout = [[XHLayout alloc]init];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [XHNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:XHCategoryDidClick object:nil];
    //注册通知,监听键盘出现
    [XHNotificationCenter addObserver:self
                                            selector:@selector(KeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [XHNotificationCenter addObserver:self
                                            selector:@selector(KeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    }



- (void)loadSatifications
{
    
//    [BSHttpTool get:XHSatisfactionUrl params:nil success:^(id json) {
//        self.satifacations = [XHSatification mj_objectArrayWithKeyValuesArray:json[@"assess"][@"contents"]];
      [self.satifacations addObjectsFromArray:self.satisArr];
       XHSatification *satification = [[XHSatification alloc]init];
        satification.name = @"其它建议与意见";
        [self.satifacations addObject:satification];
            XHSatification *sati = self.satifacations[0];
            self.categoryLable.text = [NSString stringWithFormat:@"1. %@",sati.name];
            self.indexLable.text = [NSString stringWithFormat:@"1/%lu",sati.items.count];
            NSRange range = [self.indexLable.text rangeOfString:@"/"];
        [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];
            [self.collectionView reloadData];
//                  } failure:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
//        }];
      }
- (void)cancle
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确定退出？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)showTableView
{
    XHCategoryTableView *categoryTable = [[XHCategoryTableView alloc] initWithFrame:self.view.bounds];
    //传入数据
    categoryTable.dataArray = self.satifacations;
    [categoryTable pop];
}
- (void)categoryDidChange:(NSNotification *)noti
{
    NSString *category = noti.userInfo[XHSelectedCategory];
    for (NSInteger i = 0; i < self.satifacations.count; i++) {
        XHSatification *satis = self.satifacations[i];
         if ([satis.name isEqualToString:category]) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
             self.categoryLable.text = [NSString stringWithFormat:@"%ld. %@",i+1 ,satis.name];
             if (i == self.satifacations.count - 1) {
                 self.indexLable.text = @"";
             }else{
             self.indexLable.text = [NSString stringWithFormat:@"1/%lu",satis.items.count];
            NSRange range = [self.indexLable.text rangeOfString:@"/"];
            [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];
             }
              }
    }
}
- (void)KeyboardDidShow:(NSNotification*)noti
{
     XHSecondSatisCell *secondCell = (XHSecondSatisCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    //获取键盘高度
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    secondCell.textView.contentInset = UIEdgeInsetsMake(0, 0,frame.size.height - 100, 0);
}
- (void)KeyboardDidHidden
{
    XHSecondSatisCell *secondCell = (XHSecondSatisCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    secondCell.textView.contentInset = UIEdgeInsetsZero;
}

#pragma mark cell的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.satifacations.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == self.satifacations.count - 1) {
        return 1;
    }else{
        XHSatification *satification = self.satifacations[section];
        return satification.items.count;
    }
}
#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    UICollectionViewCell *cell = nil;
    if (indexPath.section == self.satifacations.count - 1) {
        XHSecondSatisCell *secondCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        secondCell.delegate = self;
        cell = secondCell;
    }else{
        XHSatisfactionCell *firstCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        firstCell.delegate = self;
        XHSatification *satification = self.satifacations[indexPath.section];
         firstCell.indexPath = indexPath;
        firstCell.subSatis = satification.items[indexPath.item];
         cell = firstCell;
    }
       return cell;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
}

#pragma mark XHSatisfactionCellDelegate

- (void)satisfactionCell:(XHSatisfactionCell *)cell didClickScore:(XHSatisfactionCellScore)score
{
     XHSatification *satification = self.satifacations[self.indexPath.section];
    if (self.indexPath.row + 1 == satification.items.count) {
        satification = self.satifacations[self.indexPath.section + 1];
        self.categoryLable.text = [NSString stringWithFormat:@"%ld. %@",self.indexPath.section + 2,satification.name];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0  inSection:self.indexPath.section + 1] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

        if (self.indexPath.section + 2 == self.satifacations.count) {
                 self.indexLable.text = @"";
           
        }else{
            self.indexLable.text = [NSString stringWithFormat:@"1/%lu", satification.items.count];
            NSRange range = [self.indexLable.text rangeOfString:@"/"];
            [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];
        }
      }else if(self.indexPath.row + 1 < satification.items.count){
         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:self.indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
          self.indexLable.text = [NSString stringWithFormat:@"%ld/%lu", self.indexPath.row + 2,satification.items.count];
          NSRange range = [self.indexLable.text rangeOfString:@"/"];
          [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];
      }
}
#pragma mark -  XHSecondSatisCellDelegate
- (void)secondSatisCellCellSubmitButtonDidClick:(XHSecondSatisCell *)cell
{
     UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定提交?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
 }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (NSInteger i = 0; i < self.satifacations.count; i++) {
            XHSatification *satis = self.satifacations[i];
            for (NSInteger j = 0; j < satis.items.count; j++ ) {
                XHSubSatification *subSatis = satis.items[j];
                if (subSatis.score == nil) {
                    [SVProgressHUD showErrorWithStatus:@"尚有条目未评分"];
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                    self.indexLable.text = [NSString stringWithFormat:@"%ld/%lu",j+1,satis.items.count];
                    self.categoryLable.text = [NSString stringWithFormat:@"%ld. %@",i+1 ,satis.name];
                    NSRange range = [self.indexLable.text rangeOfString:@"/"];
            [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];
                    return;
            }
        }
    }
        XHSecondSatisCell *secondCell = (XHSecondSatisCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
        NSMutableArray *contentList = [[NSMutableArray alloc]init];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"advice"] = secondCell.textView.text;
        XHSubSatis *sub = [[XHSubSatis alloc]init];
        sub.objectId = self.satisObjectId;
        params[@"satisfactionAssess"] = sub.mj_keyValues;
        for (XHSatification *satis in self.satifacations) {
            for (XHSubSatification *subSatis in satis.items) {
                XHSubSatis *mSubSatis = [[XHSubSatis alloc]init];
                mSubSatis.objectId = subSatis.objectId;
                XHSatis *mSatis = [[XHSatis alloc]init];
                mSatis.score = subSatis.score;
                mSatis.content = mSubSatis;
                [contentList addObject:mSatis.mj_keyValues];
             }
        }
               params[@"contentList"] = contentList;
      [BSHttpTool post:XHSatisfactionFormUrl params:params success:^(id json) {
          [SVProgressHUD showSuccessWithStatus:@"提交成功"];
          [self.navigationController popViewControllerAnimated:YES];
             } failure:^(NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再说"];
            }];
    }
    }
#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    XHSatification *satification = self.satifacations[self.indexPath.section];
    
    if (self.indexPath.section + 1 == self.satifacations.count) {
        self.categoryLable.text = [NSString stringWithFormat:@"%ld. %@",self.indexPath.section + 1,satification.name];
        self.indexLable.text = @"";
        return;
    }
    self.categoryLable.text = [NSString stringWithFormat:@"%ld. %@",self.indexPath.section + 1,satification.name];
    self.indexLable.text = [NSString stringWithFormat:@"%ld/%lu", self.indexPath.row + 1,satification.items.count];
    NSRange range = [self.indexLable.text rangeOfString:@"/"];
    [self ChangeLabel:self.indexLable Font:[UIFont systemFontOfSize:22] AndRange:NSMakeRange(0, range.location) AndColor:XHGlobalColor];

}
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//   
//
//
//}

/**
 *  设置lable的方法
 *
 *  @param labell  要改颜色的lable
 *  @param font    要改文字的字体
 *  @param range   要改哪些文字
 *  @param vaColor 要改文字的颜色
 */
-(void)ChangeLabel:(UILabel *)label Font:(UIFont *)font AndRange:(NSRange)range AndColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    label.attributedText = str;
}
- (void)dealloc
{
    [XHNotificationCenter removeObserver:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
