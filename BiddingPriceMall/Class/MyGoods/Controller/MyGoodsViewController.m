//
//  MyGoodsViewController.m
//  BiddingPriceMall
//
//  Created by mac on 2019/9/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyGoodsViewController.h"
#import "MyCanBuyViewController.h"
#import "SellDayViewController.h"
#import "WalletModel.h"
#import "BuyListModel.h"
#import "BuyListCell.h"
#import "BuyListView.h"


@interface MyGoodsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *enableBalance;
@property (weak, nonatomic) IBOutlet UILabel *placesNum;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UIView *tableBgView;
@property (nonatomic, strong) UIView *emptyView;


@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) BuyListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@end

@implementation MyGoodsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UserModel *model = [UserModel modelWithJSON:[kUserDefaults objectForKey:def_userModel]];
    [self.user_img sd_setImageWithURL:kUrl(model.headImg) placeholderImage:kImage(@"person-center_icon")];
    self.userName.text = model.userName;
    self.account.text = model.accountNo;
    self.type = 1;
    self.pageNO = 1;
    [self getWalletList];
    [self getCanBuyList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = kFrame(10, kScale_W(180)+(kScreen_W-10)/360*80/2+10, kScreen_W-20, kScreen_H-(kScale_W(180)+(kScreen_W-10)/360*80/2+10)-kTab_H-kSafeAreaBottomHeight-35);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyListCell" bundle:nil] forCellReuseIdentifier:@"buyList_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    
    [self.view addSubview:self.tableBgView];
    [self.view bringSubviewToFront:self.tableView];
}

- (IBAction)todayOrder:(id)sender
{
    [self xx_pushVC:[SellDayViewController new]];
}

#pragma mark - networking
-(void)getWalletList
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myWallet andData:dic andSuccessBlock:^(id success) {
        self.walletModel = [WalletModel modelWithJSON:success];
        self.balance.text = [NSString stringWithFormat:@"%.2f",self.walletModel.data.balance];
        self.enableBalance.text = [NSString stringWithFormat:@"%.2f",self.walletModel.data.enableBalance];
        self.placesNum.text = [NSString stringWithFormat:@"%.2f",self.walletModel.data.placesNum];
        self.totalPrice.text = [NSString stringWithFormat:@"%.2f",self.walletModel.data.totalPrice];
    } andFailureBlock:^(id failure) {
        
    }];
}

-(void)getCanBuyList
{
    NSDictionary *dic = @{@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize),@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_buylist andData:dic andSuccessBlock:^(id success) {
        self.model = [BuyListModel modelWithJSON:success];
        if (self.type == 1) {
            self.goodsArr = [NSMutableArray arrayWithArray:self.model.rows];
            
        }
        else
        {
            [self.goodsArr addObjectsFromArray:self.model.rows];
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
    [self getCanBuyList];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self getCanBuyList];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyCanBuyViewController *vc = [MyCanBuyViewController new];
    [self xx_pushVC:vc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyList_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    BuyListView *view = [[BuyListView alloc]initWithFrame:kFrame(0, 0, kScreen_W-10, 45)];
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

- (UIView *)tableBgView
{
    if (!_tableBgView) {
        _tableBgView = [[UIView alloc]initWithFrame:kFrame(5, kScale_W(180)+(kScreen_W-10)/360*80/2+6, kScreen_W-10, kScreen_H-(kScale_W(180)+(kScreen_W-10)/360*80/2+10)-kTab_H-kSafeAreaBottomHeight-25)];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame(0, 0, _tableBgView.width, _tableBgView.height) img:kImage(@"goods_box")];
        [_tableBgView addSubview:img];
    }
    return _tableBgView;
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
