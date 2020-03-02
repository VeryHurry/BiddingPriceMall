//
//  CanUsePlaceViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CanUsePlaceViewController.h"
#import "AddAddressViewController.h"
#import "WalletModel.h"
#import "AddressListModel.h"
#import "CanUsePlaceCell.h"
#import "PlaceBuyView.h"
#import "PayPasswordView.h"

@interface CanUsePlaceViewController ()

@property (nonatomic, strong) WalletModel *model;
@property (nonatomic, strong) Placeslist *subModel;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) PlaceBuyView *buyView;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSDictionary *distributionFlag;
@property (nonatomic, strong) PayPasswordView *psdView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) AddressListModel *addressModel;

@property (nonatomic, copy) NSString *psdStr;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *telNo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *totalPrice;

@end

@implementation CanUsePlaceViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.emptyView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
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
    [IQKeyboardManager sharedManager].enable = NO;
    self.type = 1;
    [self getWalletList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    self.userModel = [UserModel modelWithJSON:dic];
    self.nav.title = @"协议仓单";
    self.userName = @"";
    self.telNo = @"";
    self.address = @"";
    self.number = @"";
    self.totalPrice = @"";
    
    self.leftItemImg = self.flag == 0 ? kImage(@""): kImage(@"back");
    CGFloat a = self.flag == 0 ? kTab_H : 0;
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight-a);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"CanUsePlaceCell" bundle:nil] forCellReuseIdentifier:@"canUsePlace_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    
    
}

#pragma mark - networking
-(void)getWalletList
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myWallet andData:dic andSuccessBlock:^(id success) {
        self.model = [WalletModel modelWithJSON:success];
        self.arr = self.model.data.placesList;
        [self refreshDataAndStyle];
        [self.view addSubview:self.maskView];
    } andFailureBlock:^(id failure) {
        
    }];
}

-(void)getDistributionFlagByTicketNumber:(NSString *)ticketNumber
{
    NSDictionary *dic = @{@"accountNo":_userModel.accountNo,@"ticketNumber":ticketNumber};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_getDistributionFlag andData:dic andSuccessBlock:^(id success) {
        self.distributionFlag = success[@"data"];
        [kWindow addSubview:self.buyView];
        if (!kIsEmptyDic(self.distributionFlag)) {
            [self endEdit:NO type:1];
        }
    } andFailureBlock:^(id failure) {

    }];
}

- (void)addGoods
{
    NSDictionary *dic = @{@"buyAccount":_userModel.accountNo,@"payPassword":[DES3Util doEncryptStr:self.psdStr],@"ticketNumber":_subModel.ticketNumber,@"number":_number,@"totalPrice":_totalPrice,@"type":@"2",@"userName":_userName,@"telNo":_telNo,@"address":_address};
    NSLog(@"----%@",dic);
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addGoods andData:dic andSuccessBlock:^(id success) {
        [self.view endEditing:YES];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        self.type = 1;
        [self getWalletList];

    } andFailureBlock:^(id failure) {

    }];
}

-(void)getAddressList
{
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"page":@"1",@"rows":@"2"};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addressList andData:dic andSuccessBlock:^(id success) {
        self.addressModel = [AddressListModel modelWithJSON:success];
        if (kIsEmptyArr(self.addressModel.rows)) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先添加收货地址" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self endEdit:YES type:2];
                AddAddressViewController *vc = (AddAddressViewController *)[self xx_getSb:@"Address" identifier:@"addAddress_vc"];
                [self xx_pushVC:vc];

            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            AddressModel *model = self.addressModel.rows[0];
            self.address = kStrMerge(model.area, model.address);
            self.telNo = model.mobile;
            self.userName = model.usreName;
            self.psdView = [[PayPasswordView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 186) data:@[self.totalPrice] block:^(NSArray *arr) {
                self.psdStr = arr[0];
                [self endEdit:YES type:2];
                [self addGoods];
            }closeBlock:^{
                [self endEdit:YES type:2];
            }];
            [self.view addSubview:self.psdView];
        }
    } andFailureBlock:^(id failure) {

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
    
    CanUsePlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canUsePlace_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.currentArr[indexPath.row]];
    [cell tapBlock:^{
        self.subModel = self.currentArr[indexPath.row];
        if (self.subModel.placesSum<1) {
            [MBProgressHUD showError:@"仓单数量不能小于1" toView:kWindow];
        }
        else
        {
            [self getDistributionFlagByTicketNumber:self.subModel.ticketNumber];
        }
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


#pragma mark - 懒加载

- (NSArray *)arr
{
    if (!_arr) {
        _arr = [NSArray new];
    }
    return _arr;
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
        _emptyView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight-kTab_H) color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(40))/2, (_emptyView.xx_height-kScale_W(48))/2-15, kScale_W(40), kScale_W(48)) img:kImage(@"none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"无明细记录"
                                               fontSize:16 color:ColorWithHex(0x4D4D4D)];
        lab.font = kFont_Medium(16);
        lab.textAlignment = 1;
        [_emptyView addSubview:lab];
        _emptyView.hidden = YES;
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

- (PlaceBuyView *)buyView
{
    if (!_buyView) {
        if (!kIsEmptyObj(self.subModel)&&!kIsEmptyDic(self.distributionFlag)) {
            _buyView = [[PlaceBuyView alloc]initWithFrame:kFrame(0, 0, kScreen_W, 430) data:@[self.subModel,self.userModel,self.distributionFlag] block:^(NSArray *arr) {
                if (!kIsEmptyArr(arr)) {
                    self.number = arr[0];
                    NSString *str = arr[1];
                    self.totalPrice = [str substringToIndex:str.length-1];
                }
                [self endEdit:YES type:1];
                [self getAddressList];
                
            }closeBlock:^{
                [self endEdit:YES type:1];
            }];
        }
    }
    else
    {
        [_buyView reloadBuyView:@[self.subModel,self.userModel,self.distributionFlag]];
    }
    return _buyView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kSafeAreaBottomHeight-kNav_H)];
        _maskView.backgroundColor = kBlack;
        _maskView.alpha = 0;
        [_maskView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.view endEditing:YES];
                self.maskView.alpha = 0;
                self.buyView.frame = kFrame(0, kScreen_H, kScreen_W, 430);
                self.psdView.frame = kFrame(0, kScreen_H, kScreen_W, 186);
                [self.psdView resignFirstResponder];
            }];
        }];
    }
    return _maskView;
}

#pragma mark - other
-(NSArray *)getCurrentArray:(NSInteger)count
{
    NSMutableArray *temp = [NSMutableArray new];
    if (count > self.arr.count) {
        count = self.arr.count;
    }
    for (int i = 0; i <count; i ++) {
        Placeslist *model = self.arr[i];
        [temp addObject:model];
    }
    return [NSArray arrayWithArray:temp];
}

- (void)refreshDataAndStyle
{
    self.currentArr = [self getCurrentArray:self.pageNO*self.pageSize];
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
        if (self.pageNO *self.pageSize >= self.arr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - other
//type 1.选择页面  2.支付页面
- (void)endEdit:(BOOL)isEdit type:(NSInteger)type
{
    if (isEdit == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view endEditing:YES];
            [kWindow endEditing:YES];
            self.maskView.alpha = 0;
            self.buyView.frame = kFrame(0, kScreen_H, kScreen_W, 430);
            self.psdView.frame = kFrame(0, kScreen_H, kScreen_W, 186);
        }];
    }
    else
    {
        if (type == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 0.4;
                if (self.flag == 0) {
                    
                }
                self.buyView.frame = kFrame(0, kScreen_H-kSafeAreaBottomHeight-430, kScreen_W, 430);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.maskView.alpha = 0.4;
                self.psdView.frame = kFrame(0, kScreen_H-self.keyboardHeight-186, kScreen_W, 186);
            }];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    [self endEdit:NO type:2];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
