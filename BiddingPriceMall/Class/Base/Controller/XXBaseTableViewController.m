//
//  XXBaseTableViewController.m
//  XXDemoLibrary
//
//  Created by GMS_XiaoXin on 17/7/14.
//  Copyright © 2017年 GMS_001. All rights reserved.
//

#import "XXBaseTableViewController.h"



@interface XXBaseTableViewController ()

@end

@implementation XXBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNO = 1;
    _pageSize = 10;
    [self.view addSubview:self.tableView];
}
//上拉刷新
- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh{
    if (_isOpenHeaderRefresh != isOpenHeaderRefresh) {
        
        _isOpenHeaderRefresh = isOpenHeaderRefresh;
        
//        __block typeof(self)weakSelf = self;
        if (isOpenHeaderRefresh) {
            //设置头部刷新
            
//            NSMutableArray *refreshArr = [NSMutableArray new];
//
//            for (int i = 1; i<61; i++)
//            {
//                NSString *strM = [NSString stringWithFormat:@"icon_refresh%d",i];
//                UIImage *img = kImage(strM);
//                [refreshArr addObject:img];
//            }
//
//            MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//                 [self headerRequestWithData];
//            }];
//            gifHeader.lastUpdatedTimeLabel.hidden = YES;
//            gifHeader.stateLabel.hidden = YES;
//            [gifHeader setImages:refreshArr duration:2.0 forState:MJRefreshStateRefreshing];
//            self.tableView.mj_header = gifHeader;
            
            MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                [self headerRequestWithData];
            }];
            header.lastUpdatedTimeLabel.textColor = kLightGray;
            header.stateLabel.textColor = kLightGray;
            
            self.tableView.mj_header = header;
        }
    }
}
//下拉刷新
- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh{
    if (_isOpenFooterRefresh != isOpenFooterRefresh) {
        _isOpenHeaderRefresh = isOpenFooterRefresh;
//        __block typeof(self)weakSelf = self;
        if (isOpenFooterRefresh) {
            
//            MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                [self footerRequestWithData];
//            }];
//
//            [footer setTitle:@"到底了~" forState:MJRefreshStateNoMoreData];
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                [self footerRequestWithData];
            }];
            [footer setTitle:@"到底了~" forState:MJRefreshStateNoMoreData];
            footer.stateLabel.textColor = kLightGray;
            self.tableView.mj_footer=footer;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrData.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     下面这几行代码是用来设置cell的上下行线的位置
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//
//    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
//    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
}


- (instancetype)initWithTableViewStyle:(UITableViewStyle)tableViewStyle{
    self = [super init];
    if (self) {
        _tableViewStyle = tableViewStyle;
    }
    
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
//头部刷新请求 (子类需要重写)
- (void)headerRequestWithData{
    
}

- (void)footerRequestWithData{
    
}

#pragma mark - get
- (NSMutableArray *)arrData
{
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc]init];
    }
    return  _arrData;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:_tableViewStyle];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        //去掉多余的行
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end
