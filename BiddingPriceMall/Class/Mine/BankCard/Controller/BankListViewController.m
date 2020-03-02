//
//  BankListViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BankListViewController.h"
#import "AddBankViewController.h"
#import "BankListModel.h"
#import "BankListCell.h"

@interface BankListViewController ()

@property (nonatomic, strong) NSMutableArray *bankArr;
@property (nonatomic, strong) BankListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation BankListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.emptyView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.pageSize = 10;
    self.nav.title = @"银行卡";
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-50);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"BankListCell" bundle:nil] forCellReuseIdentifier:@"bankList_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kFrame(0, kScreen_H-50-kSafeAreaBottomHeight, kScreen_W, 50);
    btn.xx_title = @" 添加银行卡";
    btn.xx_img = kImage(@"address_add");
    btn.xx_titleColor = kWhite;
    btn.backgroundColor = HomeColor;
    [btn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self xx_pushVC:[self xx_getSb:@"Bank" identifier:@"addBank_vc"]];
        
    }];
    [self.view addSubview:btn];
    
}

#pragma mark - networking
-(void)getBankList
{
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize)};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_bankCardList andData:dic andSuccessBlock:^(id success) {
        self.model = [BankListModel modelWithJSON:success];
        if (self.type == 1) {
            self.bankArr = [NSMutableArray arrayWithArray:self.model.rows];
            
        }
        else
        {
            [self.bankArr addObjectsFromArray:self.model.rows];
        }
        if (kIsEmptyArr(self.bankArr)) {
            self.emptyView.hidden = NO;
        }
        else
        {
            self.emptyView.hidden = YES;
        }
        
        [self.tableView reloadData];
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
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)deleteBank:(BankModel *)model
{
    NSDictionary *dic = @{@"id":kStrNum(model.ID),@"accountId":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_deleteBank andData:dic andSuccessBlock:^(id success) {
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        [self.tableView.mj_header beginRefreshing];
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)setDefaultAddress:(BankModel *)model
{
    NSDictionary *dic = @{@"id":kStrNum(model.ID),@"accountId":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_setAddress andData:dic andSuccessBlock:^(id success) {
        //        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        self.type = 1;
        self.pageNO = 1;
        [self getBankList];
    } andFailureBlock:^(id failure) {
        
    }];
}


- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self getBankList];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self getBankList];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankList_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.bankArr[indexPath.row]];
    [cell deteleBlock:^(id obj) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:txt_tip message:txt_deleteBank preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteBank:obj];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScale_W(120)+10;
}

#pragma mark - 懒加载
- (NSMutableArray *)bankArr
{
    if (!_bankArr) {
        _bankArr = [NSMutableArray new];
    }
    return _bankArr;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-50-kSafeAreaBottomHeight) color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(50))/2, (_emptyView.xx_height-kScale_W(40))/2-15, kScale_W(50), kScale_W(40)) img:kImage(@"bankcard_none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"暂无银行卡"
                                               fontSize:16 color:ColorWithHex(0x4D4D4D)];
        lab.font = kFont_Medium(16);
        lab.textAlignment = 1;
        [_emptyView addSubview:lab];
        _emptyView.hidden = YES;
        [kWindow addSubview:_emptyView];
    }
    return _emptyView;
}

#pragma mark - other

@end
