//
//  CapitalSubsidiaryViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CapitalSubsidiaryViewController.h"
#import "CapitalListModel.h"
#import "CapitalListCell.h"
#import "CQMenuTabView.h"

@interface CapitalSubsidiaryViewController ()

@property (nonatomic, strong) NSArray *capitalArr;
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, strong) CapitalListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载
@property (nonatomic, assign) NSInteger filterType; //0:买入  1:卖出 2:出金 3:入金· 4:可用转可提 5:可提转可用

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) CQMenuTabView *menuView;

@end

@implementation CapitalSubsidiaryViewController


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
    self.nav.title = @"资金明细";
    [self.view addSubview:self.menuView];
    self.tableView.frame = kFrame(0, kNav_H+45+5, kScreen_W, kScreen_H-kNav_H-45-5-kSafeAreaBottomHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"CapitalListCell" bundle:nil] forCellReuseIdentifier:@"capital_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getCapitalList];
}


#pragma mark - networking
-(void)getCapitalList
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myBalanceRcord andData:dic andSuccessBlock:^(id success) {
        self.model = [CapitalListModel modelWithJSON:success];
        self.capitalArr = self.model.rows;
        [self refreshDataAndStyle];
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
    
    CapitalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"capital_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.currentArr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
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
        _menuView.layoutStyle = CQTabWrapContent;
        _menuView.cursorHeight = 2;
        _menuView.speaceWidth = 25;
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
        _menuView.titles = @[@"全部",@"买入",@"卖出",@"出金",@"入金",@"可用转可提",@"可提转可用"];
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
        CapitalModel *model = self.capitalArr[i];
        //买入
        if (type == 0)
        {
            if (model.channel == 1 || model.channel == 2) {
                [temp addObject:model];
            }
        }
        //卖出
        else if(type == 1)
        {
            if (model.channel == 3 || model.channel == 4) {
                [temp addObject:model];
            }
        }
        //出金
        else if(type == 2)
        {
            if (model.channel == 7) {
                [temp addObject:model];
            }
        }
        //入金
        else if(type == 3)
        {
            if (model.channel == 10) {
                [temp addObject:model];
            }
        }
        //可用转可提
        else if(type == 4)
        {
            if (model.channel == 8) {
                [temp addObject:model];
            }
        }
        //可提转可用
        else if(type == 5)
        {
            if (model.channel == 9) {
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
