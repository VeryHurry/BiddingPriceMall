
//
//  AddressListVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddressListVC.h"
#import "AddAddressViewController.h"
#import "AddressListModel.h"
#import "AddressListCell.h"

@interface AddressListVC ()
@property (nonatomic, strong) NSMutableArray *addressArr;
@property (nonatomic, strong) AddressListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@property (nonatomic, strong) UIView *emptyView;
@end

@implementation AddressListVC

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
    self.nav.title = @"收货地址";
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-50);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressListCell" bundle:nil] forCellReuseIdentifier:@"addressList_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kFrame(0, kScreen_H-50-kSafeAreaBottomHeight, kScreen_W, 50);
    btn.xx_title = @" 新增地址";
    btn.xx_img = kImage(@"address_add");
    btn.xx_titleColor = kWhite;
    btn.backgroundColor = HomeColor;
    [btn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self xx_pushVC:[self xx_getSb:@"Address" identifier:@"addAddress_vc"]];
        
    }];
    [self.view addSubview:btn];
    
}

#pragma mark - networking
-(void)getAddressList
{
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize)};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addressList andData:dic andSuccessBlock:^(id success) {
        self.model = [AddressListModel modelWithJSON:success];
        if (self.type == 1) {
            self.addressArr = [NSMutableArray arrayWithArray:self.model.rows];
            
        }
        else
        {
            [self.addressArr addObjectsFromArray:self.model.rows];
        }
        if (kIsEmptyArr(self.addressArr)) {
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

- (void)deleteAddress:(AddressModel *)model
{
    NSDictionary *dic = @{@"id":kStrNum(model.ID)};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_deleteAddress andData:dic andSuccessBlock:^(id success) {
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        self.type = 1;
        self.pageNO = 1;
        [self getAddressList];
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)setDefaultAddress:(AddressModel *)model
{
    NSDictionary *dic = @{@"id":kStrNum(model.ID),@"accountId":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_setAddress andData:dic andSuccessBlock:^(id success) {
//        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        self.type = 1;
        self.pageNO = 1;
        [self getAddressList];
    } andFailureBlock:^(id failure) {
        
    }];
}


- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self getAddressList];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self getAddressList];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressList_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.addressArr[indexPath.row]];
    [self addCellAction:cell model:self.addressArr[indexPath.row]];
    return cell;
}

- (void)addCellAction:(AddressListCell *)cell model:(AddressModel *)model
{
    [cell setAddressBlock:^(NSArray *arr) {
        [self setDefaultAddress:arr[0]];
    }];
    [cell editBlock:^(id obj) {
        AddAddressViewController *vc = (AddAddressViewController *)[self xx_getSb:@"Address" identifier:@"addAddress_vc"];
        vc.model = model;
        [self xx_pushVC:vc];
    }];
    [cell deteleBlock:^(id obj) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:txt_tip message:txt_deleteAddress preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteAddress:obj];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}

#pragma mark - 懒加载
- (NSMutableArray *)addressArr
{
    if (!_addressArr) {
        _addressArr = [NSMutableArray new];
    }
    return _addressArr;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-50-kSafeAreaBottomHeight) color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(50))/2, (_emptyView.xx_height-kScale_W(40))/2-15, kScale_W(50), kScale_W(40)) img:kImage(@"address_none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"暂无收货地址"
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
