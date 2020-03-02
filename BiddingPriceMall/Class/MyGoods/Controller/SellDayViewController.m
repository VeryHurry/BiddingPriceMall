//
//  SellDayViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SellDayViewController.h"
#import "todayOrderListModel.h"
#import "SellDayCell.h"
#import "SellDayHeadView.h"

@interface SellDayViewController ()

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) todayOrderListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation SellDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"当日挂单";
    self.type = 1;
    self.pageNO = 1;
    self.pageSize = 100;
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SellDayCell" bundle:nil] forCellReuseIdentifier:@"sellDay_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self geTodayOrderList];
}

#pragma mark - networking
-(void)geTodayOrderList
{
    NSDictionary *dic = @{@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize),@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_todayOrderList andData:dic andSuccessBlock:^(id success) {
        self.model = [todayOrderListModel modelWithJSON:success];
        
        self.goodsArr = [NSMutableArray arrayWithArray:self.model.rows];
        [self.goodsArr addObjectsFromArray:self.model.data];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        if (self.type == 1) {
//            self.goodsArr = [NSMutableArray arrayWithArray:self.model.rows];
//
//        }
//        else
//        {
//            [self.goodsArr addObjectsFromArray:self.model.rows];
//        }
        [self.tableView reloadData];
//        if (self.type == 1) {
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//        }
//        else
//        {
//            if (self.pageNO *self.pageSize >= self.model.total) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            else
//            {
//                [self.tableView.mj_footer endRefreshing];
//            }
//        }
        
        if (kIsEmptyArr(self.goodsArr)) {
            self.emptyView.hidden = NO;
        }
        else
        {
            self.emptyView.hidden = YES;
        }
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self geTodayOrderList];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self geTodayOrderList];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SellDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sellDay_cell" forIndexPath:indexPath];
    [cell setData:self.goodsArr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SellDayHeadView *view = [[SellDayHeadView alloc]initWithFrame:kFrame(0, 0, kScreen_W, 45)];
    return view;
}

#pragma mark - 懒加载
- (NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]xx_initLineFrame:self.tableView.frame color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(50))/2, (_emptyView.xx_height-kScale_W(40))/2-15, kScale_W(50), kScale_W(40)) img:kImage(@"none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"无记录"
                                               fontSize:16 color:ColorWithHex(0x4D4D4D)];
        lab.font = kFont_Medium(16);
        lab.textAlignment = 1;
        [_emptyView addSubview:lab];
        _emptyView.hidden = YES;
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

@end
