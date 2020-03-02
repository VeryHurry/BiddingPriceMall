
//
//  NoticeListViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"
#import "NoticeListModel.h"
#import "NoticeListCell.h"

@interface NoticeListViewController ()

@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NoticeListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"公告列表";
    self.pageSize = 10;
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeListCell" bundle:nil] forCellReuseIdentifier:@"notice_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getNotice];
}

-(void)getNotice
{
    NSDictionary *dic = @{@"rows":kStrNum(self.pageSize),@"page":kStrNum(self.pageNO),@"search_EQ_type":@"2"};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_notice andData:dic andSuccessBlock:^(id success) {
        self.model = [NoticeListModel modelWithJSON:success];
        if (self.type == 1) {
            self.arr = [NSMutableArray arrayWithArray:self.model.rows];
            
        }
        else
        {
            [self.arr addObjectsFromArray:self.model.rows];
        }
        if (kIsEmptyArr(self.arr)) {
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

- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self getNotice];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self getNotice];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeDetailViewController *vc = (NoticeDetailViewController *)[self xx_getSb:@"Home" identifier:@"notice_sb"];
    vc.model = self.arr[indexPath.row];
    [self xx_pushVC:vc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notice_cell" forIndexPath:indexPath];
    [cell setData:self.arr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
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
- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray new];
    }
    return _arr;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]xx_initLineFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-50-kSafeAreaBottomHeight) color:kBgGray];
        UIImageView *img = [[UIImageView alloc]xx_initWithFrame:kFrame((kScreen_W-kScale_W(50))/2, (_emptyView.xx_height-kScale_W(40))/2-15, kScale_W(50), kScale_W(40)) img:kImage(@"notice_none")];
        [_emptyView addSubview:img];
        
        UILabel *lab = [[UILabel alloc]xx_initWithFrame:kFrame(0, img.xx_max_y+15, kScreen_W, 16) title:@"无公告信息"
                                               fontSize:16 color:ColorWithHex(0x4D4D4D)];
        lab.font = kFont_Medium(16);
        lab.textAlignment = 1;
        [_emptyView addSubview:lab];
        _emptyView.hidden = YES;
        [kWindow addSubview:_emptyView];
    }
    return _emptyView;
}

@end
