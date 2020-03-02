//
//  GoodsDisplay.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsDisplayVC.h"
#import "MyCanBuyViewController.h"
#import "AddAddressViewController.h"
#import "GoodsInfoModel.h"
#import "UserModel.h"
#import "YASimpleGraphView.h"
#import "BuyView.h"
#import "PayPasswordView.h"
#import "BuyAndSellCell.h"
#import "GoodsDisplayCell.h"
#import "AddressListModel.h"

@interface GoodsDisplayVC ()<YASimpleGraphDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSArray *allValues;
    NSArray *allDates;
}
@property (weak, nonatomic) IBOutlet UILabel *highPrice;
@property (weak, nonatomic) IBOutlet UILabel *lowPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *increase;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) GoodsInfoModel *goodsModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *buyArr;

@property (nonatomic, strong) UITableView *mainView;
@property (nonatomic, strong) NSArray *mainArr;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) BuyView *buyView;

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSDictionary *distributionFlag;
@property (nonatomic, strong) PayPasswordView *psdView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, copy) NSString *psdStr;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *telNo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) AddressListModel *addressModel;

@end

@implementation GoodsDisplayVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self getGoodsTradeInfo];
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

- (void) viewWillDisappear: (BOOL)animated {
    //开启自动键盘功能
    [IQKeyboardManager sharedManager].enable = YES;
    [self endEdit:YES type:1];
    [self.maskView removeFromSuperview];
    self.maskView = nil;
    [self.footView removeFromSuperview];
    self.footView = nil;
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    [self.middleView removeFromSuperview];
    self.middleView = nil;
    [self.buyView removeFromSuperview];
    self.buyView = nil;
    [self.psdView removeFromSuperview];
    self.psdView = nil;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = _model.productName;
    [kUserDefaults objectForKey:def_userModel];
    self.userName = @"";
    self.telNo = @"";
    self.address = @"";
    self.number = @"";
    self.totalPrice = @"";
    self.type = @"";
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    self.userModel = [UserModel modelWithJSON:dic];
    
    
    
 
}

#pragma mark - networking

-(void)getGoodsTradeInfo
{
    NSDictionary *dic = @{@"id":_model.ID};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_goodsTradeInfo andData:dic andSuccessBlock:^(id success) {
        self.goodsModel = [GoodsInfoModel modelWithJSON:success];
        [self updateHeadView];
        [self createMiddleView];
        [self createFootView];
        [self.view addSubview:self.maskView];
        [self getDistributionFlag];
    } andFailureBlock:^(id failure) {
        
    }];
}

-(void)getDistributionFlag
{
    NSDictionary *dic = @{@"accountNo":_userModel.accountNo,@"ticketNumber":self.model.ticketNumber};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_getDistributionFlag andData:dic andSuccessBlock:^(id success) {
        self.distributionFlag = success[@"data"];
        [self.view addSubview:self.buyView];
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)addGoods
{
    NSDictionary *dic = @{@"buyAccount":_userModel.accountNo,@"payPassword":[DES3Util doEncryptStr:self.psdStr],@"ticketNumber":_model.ticketNumber,@"number":_number,@"totalPrice":_totalPrice,@"type":_type,@"userName":_userName,@"telNo":_telNo,@"address":_address};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addGoods andData:dic andSuccessBlock:^(id success) {
        [self.view endEditing:YES];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        MyCanBuyViewController *vc = [MyCanBuyViewController new];
        [self xx_pushVC:vc];
    } andFailureBlock:^(id failure) {
        
    }];
}

-(void)getAddressList
{
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"page":@"1",@"rows":@"10"};
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


#pragma mark - UI
- (void)updateHeadView
{
    _highPrice.text = kStrMerge(@"最高 ", kStrNum(_goodsModel.up.hightPrice));
    _lowPrice.text = kStrMerge(@"最低 ", kStrNum(_goodsModel.up.lowPrice));
    _price.text = kStrMerge(@"最新 ", kStrNum(_goodsModel.up.newPrice));
    _total.text = kStrMerge(@"总量 ", kStrNum(_goodsModel.up.total));
    _balance.text = kStrMerge(@"余量 ", kStrNum(_goodsModel.up.balance));
    _increase.text = kStrMerge(@"涨幅 ", _goodsModel.up.increase);
}

- (void)createMiddleView
{
    _middleView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H+70+10, kScreen_W, 250) color:kWhite];
    [self.view addSubview:_middleView];
    
    [self setupUI];
}

- (void)setupUI {
    
    NSArray *arr = _goodsModel.middle.result;
    NSMutableArray *valueArr = [NSMutableArray new];
    NSMutableArray *dateArr = [NSMutableArray new];
    for (int i = 0; i < arr.count; i ++) {
        Result1 *model = arr[i];
        if ([model.type isEqualToString:@"left"]) {
            [valueArr addObject:kStrNum(model.totalPrice)];
            [dateArr addObject:model.dateStr];
        }
    }
    
    allValues = valueArr;
    allDates = dateArr;
    
    if (!kIsEmptyArr(allValues)) {
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = {
            0.33, 0.67, 0.93, 0.25,
            1.0, 1.0, 1.0, 1.0
        };
        
        YASimpleGraphView *graphView = [[YASimpleGraphView alloc]init];
        graphView.frame = CGRectMake(0, 10, kScreen_W-150, 220);
        graphView.backgroundColor = [UIColor clearColor];
        graphView.allValues = allValues;
        graphView.allDates = allDates;
        graphView.defaultShowIndex = allDates.count-1;
        graphView.delegate = self;
        graphView.lineColor = [UIColor grayColor];
        graphView.lineWidth = 1.0/[UIScreen mainScreen].scale;
        graphView.lineAlpha = 1.0;
        graphView.enableTouchLine = YES;
        
        //graphView.topAlpha = 1.0;
        //graphView.topColor = [UIColor orangeColor];
        //graphView.topGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        //graphView.bottomAlpha = 1.0;
        //graphView.bottomColor = [UIColor orangeColor];
        graphView.bottomGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        [self.middleView addSubview:graphView];
        [graphView startDraw];
    }
    
    [self getTableViewData];
    self.tableView = [[UITableView alloc]initWithFrame:kFrame(kScreen_W-150+20, 15, kScreen_W-15-(kScreen_W-150)-20, 250-30) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyAndSellCell" bundle:nil] forCellReuseIdentifier:@"buyAndSell_cell"];
    [self.middleView addSubview:self.tableView];
    
    
    self.mainView = [[UITableView alloc]initWithFrame:kFrame(0, self.middleView.xx_max_y, kScreen_W, kScreen_H-kScale_W(60)-self.middleView.xx_max_y-kSafeAreaBottomHeight) style:UITableViewStylePlain];
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.backgroundColor = [UIColor clearColor];
    self.mainView.tag = 2;
    [self.mainView registerNib:[UINib nibWithNibName:@"GoodsDisplayCell" bundle:nil] forCellReuseIdentifier:@"goodsDisplay_cell"];
    UIView*view = [UIView new];
    view.backgroundColor= [UIColor clearColor];
    [self.mainView setTableFooterView:view];
    [self.view addSubview:self.mainView];
    
}

- (void)createFootView
{
    self.footView = [[UIView alloc]xx_initLineFrame:kFrame(0, kScreen_H-kSafeAreaBottomHeight-kScale_W(60), kScreen_W, kScale_W(60)) color:kWhite];
    [self.view addSubview:self.footView];
    
    UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
    buy.frame = kFrame(kScale_W(16), kScale_W(10), kScale_W(165), kScale_W(40));
    buy.backgroundColor = HomeColor;
    buy.xx_cornerRadius = kScale_W(5);
    buy.xx_title = @" 挂买单";
    buy.xx_img = kImage(@"transaction_icon1");
    [buy xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (!kIsEmptyDic(self.distributionFlag)) {
            [self endEdit:NO type:1];
        }
    }];
    [self.footView addSubview:buy];
    
    UIButton *sell = [UIButton buttonWithType:UIButtonTypeCustom];
    sell.frame = kFrame(kScreen_W-kScale_W(16)-kScale_W(165), kScale_W(10), kScale_W(165), kScale_W(40));
    sell.backgroundColor = HomeColor;
    sell.xx_cornerRadius = kScale_W(5);
    sell.xx_title = @" 挂卖单";
    sell.xx_img = kImage(@"transaction_icon2");
    [sell xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        MyCanBuyViewController *vc = [MyCanBuyViewController new];
        [self xx_pushVC:vc];
    }];
    [self.footView addSubview:sell];
}

- (BuyView *)buyView
{
    if (!_buyView) {
        _buyView = [[BuyView alloc]initWithFrame:kFrame(0, 0, kScreen_W, 430) data:@[self.model,self.userModel,self.distributionFlag] block:^(NSArray *arr) {
            if (!kIsEmptyArr(arr)) {
                self.number = arr[0];
                NSString *str = arr[2];
                self.totalPrice = [str substringToIndex:str.length-1];
                self.type = arr[3];
            }
            [self endEdit:YES type:1];
            
            if ([self.type isEqualToString:@"2"]) {
                [self getAddressList];
            }
            else
            {
                self.psdView = [[PayPasswordView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, 186) data:@[self.totalPrice] block:^(NSArray *arr) {
                    self.psdStr = arr[0];
                    [self endEdit:YES type:2];
                    [self addGoods];
                }closeBlock:^{
                    [self endEdit:YES type:2];
                }];
                [self.view addSubview:self.psdView];
            }
            
            
            
        }closeBlock:^{
            [self endEdit:YES type:1];
        }];
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
            }];
        }];
    }
    return _maskView;
}

#pragma mark - 折线图
//自定义X轴 显示标签索引
- (NSArray *)incrementPositionsForXAxisOnLineGraph:(YASimpleGraphView *)graph {
    if (allValues.count == 1) {
        return @[@0];
    }
    else if (allValues.count == 2) {
        return @[@0,@1];
    }
    else if (allValues.count == 3)
    {
        return @[@0,@1,@2];
    }
    else if (allValues.count == 4)
    {
        return @[@0,@1,@2,@3];
    }
    else
    {
        return @[@0,@1,@2,@3,@4];
    }
}

//Y轴坐标点数
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(YASimpleGraphView *)graph {
    return allDates.count;
}

//自定义popUpView
- (UIView *)popUpViewForLineGraph:(YASimpleGraphView *)graph {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.backgroundColor = [UIColor colorWithRed:146/255.0 green:191/255.0 blue:239/255.0 alpha:1];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//修改相应点位弹出视图
- (void)lineGraph:(YASimpleGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index {
    UILabel *label = (UILabel*)popupView;
    NSString *date = [NSString stringWithFormat:@"%@",allDates[index]];
    NSString *str = [NSString stringWithFormat:@" %@ \n %@元 ",date,allValues[index]];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    
    [label setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    label.textColor = [UIColor whiteColor];
    label.text = str;
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        BuyAndSellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyAndSell_cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0 || indexPath.row == 6) {
            [cell setData:self.buyArr[indexPath.row] type:1];
        }
        else
        {
            [cell setData:self.buyArr[indexPath.row] type:0];
        }
        
        return cell;
    }
    else
    {
        GoodsDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsDisplay_cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell setData:self.mainArr[indexPath.row] type:1];
        }
        else
        {
            [cell setData:self.mainArr[indexPath.row] type:0];
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.buyArr.count;
    }
    else
    {
        return self.mainArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        if (indexPath.row == 0||indexPath.row == 6) {
            return 24;
        }
        return 17;
    }
    else
    {
        return 31;
    }
}


#pragma mark - data
- (void)getTableViewData
{
    NSArray *arr = self.goodsModel.middle.result;
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObject:@[@"卖",@"价格",@"数量"]];
    NSArray *sell = @[@[@"卖4",@"0.00",@"0"],@[@"卖3",@"0.00",@"0"],@[@"卖2",@"0.00",@"0"],@[@"卖1",@"0.00",@"0"]];
    NSArray *buy = @[@[@"买4",@"0.00",@"0"],@[@"买3",@"0.00",@"0"],@[@"买2",@"0.00",@"0"],@[@"买1",@"0.00",@"0"]];
    [temp addObjectsFromArray:sell];
    [temp addObject:@[@"买",@"价格",@"数量"]];
    [temp addObjectsFromArray:buy];
    for (int i = 0; i <arr.count ; i ++) {
        Result1 *model = arr[i];
        if (kStrEqual(model.type, @"sell")) {
            [temp insertObject:@[@"卖5",[NSString stringWithFormat:@"%.2f",model.unitPrice],kStrNum(model.number)] atIndex:1];
        }
        if (kStrEqual(model.type, @"buy")) {
            [temp insertObject:@[@"买5",[NSString stringWithFormat:@"%.2f",model.unitPrice],kStrNum(model.number)] atIndex:6];
        }
    }
    self.buyArr = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp1 = [NSMutableArray new];
    Result2 *model = [[Result2 alloc]init];
    model.dateStr = @"日期";
    model.openPrice = @"开市价";
    model.closePrice = @"收市价";
    model.scuuessPrice = @"成交价";
    [temp1 addObject:model];
    [temp1 addObjectsFromArray:self.goodsModel.down.result];
    self.mainArr = [NSArray arrayWithArray:temp1];
}

#pragma mark - other
//type 1.选择页面  2.支付页面
- (void)endEdit:(BOOL)isEdit type:(NSInteger)type
{
    if (isEdit == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view endEditing:YES];
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


