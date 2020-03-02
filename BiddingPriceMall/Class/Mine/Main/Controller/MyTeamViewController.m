
//
//  MyTeamViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyTeamViewController.h"
#import "ShareViewController.h"
#import "MyTeamModel.h"
#import "MyTeamCell.h"
#import "CQMenuTabView.h"

@interface MyTeamViewController ()

@property (nonatomic, strong) NSArray *teamArr;
@property (nonatomic, strong) NSArray *currentArr;
@property (nonatomic, strong) MyTeamModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载
@property (nonatomic, assign) NSInteger filterType; //0:未激活  1:已激活 2：全部

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) CQMenuTabView *menuView;

@end

@implementation MyTeamViewController

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
    self.filterType = 2;
    self.nav.title = @"我的拼团";
    self.rightItemImg = kImage(@"team_share");
    [self.view addSubview:self.menuView];
    self.tableView.frame = kFrame(0, kNav_H+45+5, kScreen_W, kScreen_H-kNav_H-45-5-kSafeAreaBottomHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTeamCell" bundle:nil] forCellReuseIdentifier:@"myTeam_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getTeamList];
}

- (void)rightBarBtnClicked
{
    ShareViewController *vc = (ShareViewController *)[self xx_getSb:@"Mine" identifier:@"share_sb"];
    [self xx_pushVC:vc];
}

#pragma mark - networking
-(void)getTeamList
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myTeam andData:dic andSuccessBlock:^(id success) {
        self.model = [MyTeamModel modelWithJSON:success];
        self.teamArr = self.model.data;
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
    
    MyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTeam_cell" forIndexPath:indexPath];
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
    return 90;
}

#pragma mark - 懒加载
- (NSArray *)teamArr
{
    if (!_teamArr) {
        _teamArr = [NSArray new];
    }
    return _teamArr;
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
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(50))/2, (_emptyView.xx_height-kScale_W(40))/2-15, kScale_W(50), kScale_W(40)) img:kImage(@"team_none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"无成员信息"
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
            if (index == 0) {
                weakSelf.filterType = 2;
            }
            else if (index == 1)
            {
                weakSelf.filterType = 1;
            }
            else if (index == 2)
            {
                weakSelf.filterType = 0;
            }
            [weakSelf refreshDataAndStyle];
        };
        
        
        _menuView.titles = @[@"全部",@"已交易成员",@"未交易成员"];
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
    for (int i = 0; i <count; i ++) {
        TeamModel *model = self.teamArr[i];
        //已激活
        if (type == 1)
        {
            if (model.isLively == 1) {
                [temp addObject:model];
            }
        }
        //未激活
        else if(type == 0)
        {
            if (model.isLively == 0) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
