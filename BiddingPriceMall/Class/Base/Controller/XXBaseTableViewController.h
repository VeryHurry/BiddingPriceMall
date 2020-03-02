//
//  XXBaseTableViewController.h
//  XXDemoLibrary
//
//  Created by GMS_XiaoXin on 17/7/14.
//  Copyright © 2017年 GMS_001. All rights reserved.
//

#import "XXBaseViewController.h"
#import "MJRefresh.h"

@interface XXBaseTableViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)   UITableViewStyle tableViewStyle;
//页数索引
@property (nonatomic,assign) NSInteger pageNO;
//每页显示多少条
@property (nonatomic,assign) NSInteger pageSize;
//数据源
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic, strong)   UITableView *tableView;
//开启头部刷新
@property (nonatomic,assign) BOOL  isOpenHeaderRefresh;
//开启脚部刷新
@property (nonatomic,assign) BOOL  isOpenFooterRefresh;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)tableViewStyle;

//头部刷新请求 (子类需要重写)
- (void)headerRequestWithData;

- (void)footerRequestWithData;

@end
