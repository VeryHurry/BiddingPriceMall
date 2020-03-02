
//
//  MyCanBuyViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyCanBuyViewController.h"
#import "BuyListModel.h"
#import "MyCanBuyCell.h"
#import "PayPasswordView.h"

@interface MyCanBuyViewController ()

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) BuyListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) PayPasswordView *psdView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, copy) NSString *psdStr;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MyCanBuyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void) viewWillDisappear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = YES;
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"可卖仓单";
    self.type = 1;
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCanBuyCell" bundle:nil] forCellReuseIdentifier:@"canBuy_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getCanBuyList];
    [self.view addSubview:self.maskView];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//- (void)leftBarBtnClicked
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

#pragma mark - networking
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

-(void)addSellOrder:(NSString *)orderId type:(NSString *)type
{
    NSDictionary *dic = @{@"payPassword":[DES3Util doEncryptStr:self.psdStr] ,@"orderId":orderId,@"type":type,@"sellAccount":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addSell andData:dic andSuccessBlock:^(id success) {
        [MBProgressHUD showMessag:success[@"msg"] toView:kWindow andShowTime:1.5];
        self.type = 1;
        self.pageNO = 1;
        [self getCanBuyList];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCanBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canBuy_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.goodsArr[indexPath.row]];
    BuyModel *model = self.goodsArr[indexPath.row];
    [cell tapBlock:^{
        self.psdView = [[PayPasswordView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 140) data:@[] block:^(NSArray *arr) {
            self.psdStr = arr[0];
            [self changePsdFrame:NO];
            [self addSellOrder:model.orderNo type:kStrNum(model.type)];
            
        }closeBlock:^{
            [self changePsdFrame:NO];
        }];
        [self.view addSubview:self.psdView];
    }];
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
    return 270;
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
        [kWindow addSubview:_emptyView];
    }
    return _emptyView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kSafeAreaBottomHeight-kNav_H)];
        _maskView.backgroundColor = kBlack;
        _maskView.alpha = 0;
        [_maskView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self changePsdFrame:NO];
        }];
    }
    return _maskView;
}

- (void)changePsdFrame:(BOOL)show
{
    if (show) {
        [UIView animateWithDuration:0.2 animations:^{
            self.maskView.alpha = 0.4;
            self.psdView.frame = kFrame(0, kScreen_H-self.keyboardHeight-140, kScreen_W, 186);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view endEditing:YES];
            self.maskView.alpha = 0.0;
            self.psdView.frame = kFrame(0, kScreen_H, kScreen_W, 140);
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    [self changePsdFrame:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
