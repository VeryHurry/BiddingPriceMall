//
//  HomeViewController.m
//  BiddingPriceMall
//
//  Created by mac on 2019/9/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginVC.h"
#import "GoodsDetailVC.h"
#import "GoodsDisplayVC.h"
#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"

#import "NoticeListModel.h"
#import "GoodsListModel.h"

#import "SDCycleScrollView.h"
#import "HomeMenuView.h"
#import "GoodsListCell.h"
#import "MarqueeView.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *noticeArr;
@property (nonatomic, strong) NSMutableArray *bannerArr, *goodsArr;
@property (nonatomic, strong) GoodsListModel *model;
@property (nonatomic, assign) NSInteger type; //1:下拉刷新 2:上拉加载

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HomeMenuView *menuView;
@property (nonatomic, strong) MarqueeView *marqueeView;
@property (nonatomic, strong) NoticeListModel *noticeModel;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isJumpLoginVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.pageSize = 10;
    self.nav.title = @"川藏亚吉";
    self.leftItemImg = kImage(@"");
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kTab_H);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsListCell" bundle:nil] forCellReuseIdentifier:@"goodsList_cell"];
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    [self getMessage];
}


#pragma mark - networking

- (void)getMessage
{
    //    /创建信号量为0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSDictionary *dic = @{@"rows":@"10",@"page":@"1",@"search_EQ_type":@"1"};
        [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_notice andData:dic andSuccessBlock:^(id success) {
            dispatch_semaphore_signal(semaphore);
            NSLog(@"1请求成功");
            NoticeListModel *model = [NoticeListModel modelWithJSON:success];
            NSMutableArray *temp = [NSMutableArray new];
            for (int i = 0; i < model.rows.count; i ++) {
                NoticeModel *models = model.rows[i];
                [temp addObject:models.file];
            }
            self.bannerArr = temp;
            
        } andFailureBlock:^(id failure) {
            dispatch_semaphore_signal(semaphore);
        }];
        
        
    });
    
    dispatch_group_async(group, queue, ^{
        
        NSDictionary *dic = @{@"rows":kStrNum(self.pageSize),@"page":kStrNum(self.pageNO),@"search_EQ_type":@"2"};
        [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_notice andData:dic andSuccessBlock:^(id success) {
            dispatch_semaphore_signal(semaphore);
            NSLog(@"2请求成功");
            self.noticeModel = [NoticeListModel modelWithJSON:success];
            self.noticeArr = self.noticeModel.rows;
            
        } andFailureBlock:^(id failure) {
            dispatch_semaphore_signal(semaphore);
        }];
        
    });
    
    dispatch_group_notify(group, queue, ^{
        //        信号量 -1 为0时wait会阻塞线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"信号量为0");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createHeadView];
        });
    
        NSDictionary *dic = @{@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize)};
        [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_goodsList andData:dic andSuccessBlock:^(id success) {
            self.model = [GoodsListModel modelWithJSON:success];
            if (self.type == 1) {
                self.goodsArr = [NSMutableArray arrayWithArray:self.model.rows];
                
            }
            else
            {
                [self.goodsArr addObjectsFromArray:self.model.rows];
            }
            self.tableView.tableHeaderView = self.headView;
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
    });
}



////search_EQ_type 1.首页banner 2.公告列表
////首页banner
//-(void)getNotice
//{
//    NSDictionary *dic = @{@"rows":@"10",@"page":@"1",@"search_EQ_type":@"1"};
//    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_notice andData:dic andSuccessBlock:^(id success) {
//        NoticeListModel *model = [NoticeListModel modelWithJSON:success];
//        self.noticeArr = model.rows;
//        NSMutableArray *temp = [NSMutableArray new];
//        for (int i = 0; i < model.rows.count; i ++) {
//            NoticeModel *models = self.noticeArr[i];
//            [temp addObject:models.file];
//        }
//        self.bannerArr = temp;
//        [self createHeadView];
//        [self getGoodsList];
//    } andFailureBlock:^(id failure) {
//
//    }];
//}
//
//-(void)getNoticeList
//{
//    NSDictionary *dic = @{@"rows":kStrNum(self.pageSize),@"page":kStrNum(self.pageNO),@"search_EQ_type":@"2"};
//    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_notice andData:dic andSuccessBlock:^(id success) {
//        self.noticeModel = [NoticeListModel modelWithJSON:success];
//        [self.headView addSubview:self.marqueeView];
//    } andFailureBlock:^(id failure) {
//
//    }];
//}
//
//-(void)getGoodsList
//{
//    NSDictionary *dic = @{@"page":kStrNum(self.pageNO),@"rows":kStrNum(self.pageSize)};
//    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_goodsList andData:dic andSuccessBlock:^(id success) {
//        self.model = [GoodsListModel modelWithJSON:success];
//        if (self.type == 1) {
//           self.goodsArr = [NSMutableArray arrayWithArray:self.model.rows];
//
//        }
//        else
//        {
//            [self.goodsArr addObjectsFromArray:self.model.rows];
//        }
//        self.tableView.tableHeaderView = self.headView;
//        [self.tableView reloadData];
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
//    } andFailureBlock:^(id failure) {
//
//    }];
//}

- (void)headerRequestWithData
{
    self.type = 1;
    self.pageNO = 1;
    [self getMessage];
}

- (void)footerRequestWithData
{
    self.type = 2;
    self.pageNO ++;
    [self getMessage];
}

#pragma mark - UI
- (void)createHeadView
{
    self.headView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, kScale_W(200)+24+44+30)];
    self.headView.backgroundColor = kBgGray;
    [self.headView addSubview:self.bannerView];
//    [self.headView addSubview:self.menuView];
    [self.headView addSubview:self.marqueeView];
    
    
    UIView *titleView = [[UIView alloc]initWithFrame:kFrame(0, self.marqueeView.xx_max_y+12, kScreen_W, 30)];
    UILabel *titleLbl = [[UILabel alloc]xx_initWithFrame:kFrame(16, 5, 70, 20) title:@"交易中心" fontSize:16 color:kGray];
    titleLbl.font = kFont_Medium(17);
    [titleView addSubview:titleLbl];
    
    
    
//    UIButton *btn = [[UIButton alloc]xx_initWithFrame:kFrame(kScreen_W-22-5, 11, 5, 8) img:@"more" bgImg:@"" cornerRadius:0 Block:^(NSInteger tag) {
//
//    }];
//    btn.xx_touchAreaInsets = UIEdgeInsetsMake(5, 40, 5, 20) ;
//    [titleView addSubview:btn];
//
//    UILabel *moreLbl = [[UILabel alloc]xx_initWithFrame:kFrame(btn.xx_x-6-40, 8, 40, 14) title:@"更多" fontSize:13 color:Home_Text_Color];
//    moreLbl.font = kFont_Medium(13);
//    moreLbl.textAlignment = 2;
//    [titleView addSubview:moreLbl];
    
    [self.headView addSubview:titleView];
}


#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailVC *vc = (GoodsDetailVC *)[self xx_getSb:@"Home" identifier:@"goodsDetail_sb"];
    vc.model = self.goodsArr[indexPath.row];
    [self xx_pushVC:vc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsList_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:self.goodsArr[indexPath.row]];
    [cell tapBlock:^(id obj) {
        Rows *model = obj;
        GoodsDisplayVC *vc = (GoodsDisplayVC *)[self xx_getSb:@"Home" identifier:@"goodsDisplay_sb"];
        vc.model = model;
        [self xx_pushVC:vc];
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
    return 145;
}

#pragma mark - 懒加载

- (SDCycleScrollView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_W, kScale_W(200)) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.currentPageDotImage = kImage(@"banner_point_1");
        _bannerView.pageDotImage = kImage(@"banner_point_2");
        _bannerView.imageURLStringsGroup = self.bannerArr;
    }
    return _bannerView;
}

- (HomeMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[HomeMenuView alloc]initWithFrame:kFrame(10, kScale_W(200)+12, kScreen_W-20, (kScreen_W-20)/355*90) titleArr:@[@"积分商城",@"社交中心",@"游戏中心",@"旅游中心",@"公告中心"] imageArr:@[@"red",@"blue",@"green",@"orange",@"yellow"] block:^(NSInteger num) {
            if (num == 4) {
                [self xx_pushVC:[NoticeListViewController new]];
            }
            else
            {
                [MBProgressHUD showMessag:@"努力开发中，敬请期待" toView:kWindow andShowTime:1];
            }
        }];
    }
    return _menuView;
}

- (MarqueeView *)marqueeView
{
    if (!_marqueeView) {
        _marqueeView = [[MarqueeView alloc]initWithFrame:kFrame(10, kScale_W(200)+12, kScreen_W-20, 44)];
        _marqueeView.backgroundColor = [UIColor whiteColor];
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _noticeModel.rows.count; i ++) {
            NoticeModel *model = _noticeModel.rows[i];
            [temp addObject:model.content];
        }
        _marqueeView.marqueeContentArray = temp;
        [_marqueeView start];
        __weak typeof(self) weakSelf = self;
        _marqueeView.block = ^(NSInteger index) {
            NoticeDetailViewController *vc = (NoticeDetailViewController *)[weakSelf xx_getSb:@"Home" identifier:@"notice_sb"];
            vc.model = weakSelf.noticeArr[index];
            [weakSelf xx_pushVC:vc];
        };
        _marqueeView.moreBlock = ^{
            [weakSelf xx_pushVC:[NoticeListViewController new]];
        };
    }
    return _marqueeView;
}

- (NSMutableArray *)bannerArr
{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray new];
    }
    return _bannerArr;
}

- (NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
}

- (void)isJumpLoginVC
{
    if (kIsEmptyObj([kUserDefaults objectForKey:def_userModel])) {
        [self presentViewController:[self xx_getSb:@"Login" identifier:@"login_sb"] animated:YES completion:^{
            
        }];
    }
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
