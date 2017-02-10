//
//  XHEquipmentViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHEquipmentViewController.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "SVProgressHUD.h"
#import "XHEquipment.h"
#import "XHSubEquipment.h"
#import "MJExtension.h"
#import "XHBigEquipment.h"
#import "XHSearchResultViewController.h"
#import "UIView+AutoLayout.h"
#import "FMDBTool.h"
@interface XHEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UILabel *_myindex;//中间索引view
    UILabel *_indexView;//右边索引view
}
@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *indexViewArr;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *equipments;
@property (nonatomic, strong) NSMutableArray *subEquipments;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, copy) NSString *selectEquipmentStr;
@property (nonatomic, copy) NSString * selectEquipmentName;
@property (nonatomic, strong) XHEquipment * selectEquipment;
@property (nonatomic, strong) XHBigEquipment *bigEquipment;
@property (nonatomic, strong) NSMutableArray *bigEquipments;
@property (nonatomic,strong) XHSearchResultViewController *searchResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic,copy) NSString *objectIdStr;


@end

@implementation XHEquipmentViewController
extern NSString *jsessionid;
- (NSMutableArray *)indexViewArr {
    if(_indexViewArr == nil) {
        _indexViewArr = [[NSMutableArray alloc] init];
    }
    return _indexViewArr;
}
- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc]init];
    }
    return _searchArr;
}
- (XHSearchResultViewController *)searchResult
{
        if (!_searchResult) {
            XHSearchResultViewController *searchResult = [[XHSearchResultViewController alloc] init];
           [self addChildViewController:searchResult];
            self.searchResult = searchResult;
            
            [self.view addSubview:self.searchResult.view];
            [self.searchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.searchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:0];
        }
       return _searchResult;
    }

- (NSMutableArray *)equipments
{
    if (!_equipments) {
        _equipments = [NSMutableArray array];
    }
    return _equipments;
}
- (NSMutableArray *)subEquipmentNames
{
    if (!_subEquipments) {
        _subEquipments = [NSMutableArray array];
    }
    return _subEquipments;
}
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}
- (NSMutableArray *)bigEquipments
{
    if (!_bigEquipments) {
        _bigEquipments = [[NSMutableArray alloc]init];
    }
    return _bigEquipments;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadEquipment];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.subTableView.showsVerticalScrollIndicator = NO;
//    self.tableView.backgroundColor = XHColor(226, 227, 230);
}
- (void)setupNav
{
    self.navigationItem.title = @"选择设备";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)loadEquipment
{
    self.equipments = (NSMutableArray *)[FMDBTool equipments];
    for (XHEquipment *equipment in self.equipments) {
        for (XHSubEquipment *subEquipment in equipment.items) {
            //                [NSString stringWithFormat:@"%@/%@",equipment.name,subEquipment.name];
            XHSubEquipment *sub = [[XHSubEquipment alloc]init];
            sub.name = [NSString stringWithFormat:@"%@ / %@",equipment.name,subEquipment.name];
            sub.objectId = subEquipment.objectId;
            [self.searchArr addObject:sub];
        }
        NSRange range = [equipment.name rangeOfString:@"/"];
        if (![self.titleArray containsObject:[equipment.name substringToIndex:range.location]]) {
            [self.titleArray addObject:[equipment.name substringToIndex:range.location]];
        }
    }
    
    for (int i = 0; i<self.titleArray.count; i++) {
        NSMutableArray *newArr = [[NSMutableArray alloc]init];
        XHBigEquipment *bigEquipment = [[XHBigEquipment alloc]init];
        bigEquipment.name = self.titleArray[i];
        for (XHEquipment *equipment in self.equipments) {
            if ([equipment.name containsString:self.titleArray[i]]) {
                [newArr addObject:equipment];
            }
        }
        bigEquipment.equipments = newArr;
        [self.bigEquipments addObject:bigEquipment];
    }
    [self.tableView reloadData];
    [self setupIndexView];
    if(self.bigEquipments.count>0)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
    }
   
}
- (void)setupIndexView {
    //    初始化右边索引条
    _indexView = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.4 - 15,([UIScreen mainScreen].bounds.size.height  - 155 + 108) * 0.5, 13, 155)];
    _indexView.numberOfLines = 0;
    _indexView.font = [UIFont systemFontOfSize:12];
    _indexView.backgroundColor = XHColor(231, 232, 234);
    _indexView.textAlignment = NSTextAlignmentCenter;
    _indexView.userInteractionEnabled = YES;
    _indexView.layer.cornerRadius = 5;
    _indexView.layer.masksToBounds = YES;
    _indexView.alpha = 0.6;
    [self.view addSubview:_indexView];
    //    初始化显示的索引view
    _myindex = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, [UIScreen mainScreen].bounds.size.width * 0.4, [UIScreen mainScreen].bounds.size.height - 108)];
    _myindex.font = [UIFont boldSystemFontOfSize:30];
    _myindex.backgroundColor = [UIColor blackColor];
    _myindex.textColor = [UIColor whiteColor];
    _myindex.textAlignment = NSTextAlignmentCenter;
    _myindex.alpha = 0;
    [self.view addSubview:_myindex];
    //    初始化索引条内容
    for (XHBigEquipment *bigEquipment in self.bigEquipments) {
        [self.indexViewArr addObject:[bigEquipment.name substringToIndex:1]];
    }
    for (int i=0; i<self.indexViewArr.count; i++)
    {
        NSString *str = self.indexViewArr[i];
        _indexView.text=i==0?str:[NSString stringWithFormat:@"%@\n%@",_indexView.text,str];
    }
}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if (self.selectEquipmentStr) {
        [XHNotificationCenter
         postNotificationName:XHEquipmentDidChangeNotification object:nil userInfo:@{XHSelectEquipment:self.selectEquipmentStr,XHSelectEquipmentObjectId:self.objectIdStr}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         [SVProgressHUD showErrorWithStatus:@"请先选择设备"];
    }
}
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
         return self.bigEquipments.count;
    }else{
         return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        XHBigEquipment *bigEquipment = self.bigEquipments[section];

        return bigEquipment.equipments.count;
    }
    else{
        return self.selectEquipment.items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.tableView) {
        static NSString *mainID=@"main-cell";
        cell = [tableView dequeueReusableCellWithIdentifier:mainID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainID];
        }
        cell.backgroundColor = XHColor(231, 232, 234);
        XHBigEquipment *bigEquipment = self.bigEquipments[indexPath.section];
        XHEquipment *equipment = bigEquipment.equipments[indexPath.row];
        NSRange range = [equipment.name rangeOfString:@"/"];
        cell.textLabel.text = [equipment.name substringFromIndex:range.location+1];
//        cell.textLabel.text = equipment.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
    }else{
        static NSString *subID = @"sub-cell";
        cell = [tableView dequeueReusableCellWithIdentifier:subID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subID];
        }
        XHSubEquipment *subEquipment = self.selectEquipment.items[indexPath.row];
        cell.textLabel.text = subEquipment.name;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = XHGlobalColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        self.selectEquipmentStr = nil;
        XHBigEquipment *bigEquipment = self.bigEquipments[indexPath.section];
        self.selectEquipment = bigEquipment.equipments[indexPath.row];
        [self.subTableView reloadData];
    }
    else{
        XHSubEquipment *subEquipment = self.selectEquipment.items[indexPath.row];
         self.selectEquipmentStr = [NSString stringWithFormat:@"%@ / %@",self.selectEquipment.name,subEquipment.name];
        self.objectIdStr = subEquipment.objectId;
    }
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        XHBigEquipment *bigEquipment = self.bigEquipments[section];
        return bigEquipment.name;
    }else{
        return nil;
    }
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    if (tableView == self.tableView) {
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        for (XHBigEquipment *bigEquipment in self.bigEquipments) {
//            [arr addObject:[bigEquipment.name substringToIndex:1]];
//        }
//        return arr;
//    }else{
//        return nil;
//    }
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
     UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = XHGlobalColor;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;//取消的字体颜色，
    [searchBar setShowsCancelButton:YES animated:YES];
    //改变取消的文本
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:XHGlobalColor forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    self.searchResult.view.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.searchResult.view.hidden=NO;
    }else{
        self.searchResult.view.hidden=YES;
    }
    self.searchResult.searchArr = self.searchArr;
    self.searchResult.searchEquipment = searchText;
}


#pragma mark - indexView
//点击开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myTouch:touches];
}


//点击进行中
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myTouch:touches];
}

//点击结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 让中间的索引view消失
    [UIView animateWithDuration:1 animations:^{
        _myindex.alpha=0;
    }];
}
//点击会调的方法
-(void)myTouch:(NSSet *)touches
{
    //    让中间的索引view出现
    [UIView animateWithDuration:0.3 animations:^{
        _myindex.alpha=0.5;
    }];
    //    获取点击的区域
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_indexView];
    
    int index=(int)((point.y/145)*9);
    if (index>9||index<0)return;
    //    给显示的view赋标题
    _myindex.text=self.indexViewArr[index];
    //    跳到tableview指定的区
    NSIndexPath *indpath=[NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView  scrollToRowAtIndexPath:indpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
@end
