
//
//  IntegralListViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IntegralListViewController.h"
#import "IntegralListModel.h"
#import "IntegralListCell.h"
#import "CQMenuTabView.h"

@interface IntegralListViewController ()

@property (nonatomic, strong) NSArray *capitalArr;
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, strong) IntegralListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载
@property (nonatomic, assign) NSInteger filterType;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) CQMenuTabView *menuView;

@end

@implementation IntegralListViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.emptyView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.type = 1;
    self.pageSize = 10;
    self.filterType = 10;
    self.nav.title = @"积分明细";
    [self.view addSubview:self.menuView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.frame = kFrame(0, kNav_H+45+5, kScreen_W, kScreen_H-kNav_H-45-5-kSafeAreaBottomHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntegralListCell" bundle:nil] forCellReuseIdentifier:@"integral_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getPlacesList];
}


#pragma mark - networking
-(void)getPlacesList
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [MBProgressHUD showMessage:txt_loding toView:kWindow];
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myIntegralRecord andData:dic andSuccessBlock:^(id success) {
        self.model = [IntegralListModel modelWithJSON:success];
        self.capitalArr = self.model.rows;
        [self refreshDataAndStyle];
        [MBProgressHUD hideHUDForView:kWindow];
    } andFailureBlock:^(id failure) {
        [MBProgressHUD hideHUDForView:kWindow];
    }];
}

- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self refreshDataAndStyle];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self refreshDataAndStyle];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IntegralListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integral_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.currentArr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArr.count;
}


#pragma mark - 懒加载
- (NSArray *)capitalArr
{
    if (!_capitalArr) {
        _capitalArr = [NSArray new];
    }
    return _capitalArr;
}

- (NSArray *)currentArr
{
    if (!_currentArr) {
        _currentArr = [NSArray new];
    }
    return _currentArr;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H+45, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight-45) color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(40))/2, (_emptyView.xx_height-kScale_W(48))/2-15, kScale_W(40), kScale_W(48)) img:kImage(@"none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"无明细记录"
                                               fontSize:16 color:ColorWithHex(0x4D4D4D)];
        lab.font = kFont_Medium(16);
        lab.textAlignment = 1;
        [_emptyView addSubview:lab];
        _emptyView.hidden = YES;
        [kWindow addSubview:_emptyView];
    }
    return _emptyView;
}

- (CQMenuTabView *)menuView
{
    if (!_menuView) {
        _menuView = [[CQMenuTabView alloc] initWithFrame:CGRectMake(0, kNav_H, kScreen_W, 45)];
        _menuView.titleFont = kFont(14);
        _menuView.normaTitleColor = ColorWithHex(0x4D4D4D);
        _menuView.didSelectTitleFont = kFont_Medium(14);
        _menuView.didSelctTitleColor = Home_Text_Color;
        _menuView.showCursor = YES;
        _menuView.cursorStyle = CQTabCursorUnderneath;
        _menuView.layoutStyle = CQTabFillParent;
        _menuView.cursorHeight = 2;
        _menuView.cursorView.backgroundColor = Home_Text_Color;
        _menuView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _menuView.didTapItemAtIndexBlock = ^(UIView *view, NSInteger index) {
            NSLog(@"...%ld",(long)index);
            weakSelf.pageNO = 1;
            weakSelf.type = 1;
            weakSelf.filterType = index;
            [weakSelf refreshDataAndStyle];
        };
        _menuView.titles = @[@"全部",@"赠送",@"兑换"];
    }
    return _menuView;
}

#pragma mark - other
-(NSArray *)getCurrentArray:(NSInteger)count type:(NSInteger)type
{
    NSMutableArray *temp = [NSMutableArray new];
    if (count > self.model.total) {
        count = self.model.total;
    }
    type = type-1;
    for (int i = 0; i <count; i ++) {
        IntegralModel *model = self.capitalArr[i];
        //赠送
        if (type == 0)
        {
            if (model.channel == 1) {
                [temp addObject:model];
            }
        }
        //兑换
        else if(type == 1)
        {
            if (model.channel == 2) {
                [temp addObject:model];
            }
        }
        //全部
        else
        {
            [temp addObject:model];
        }
    }
    return [NSArray arrayWithArray:temp];
    
}

- (void)refreshDataAndStyle
{
    self.currentArr = [self getCurrentArray:self.pageNO*self.pageSize type:self.filterType];
    if (kIsEmptyArr(self.currentArr)) {
        self.emptyView.hidden = NO;
    }
    else
    {
        self.emptyView.hidden = YES;
    }
    
    
    if (self.type == 1) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    else
    {
        if (self.pageNO *self.pageSize >= self.model.total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }
    [self.tableView reloadData];
}



@end
