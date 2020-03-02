
//
//  ChooseView.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ChooseView.h"
#import "ChooseBankCell.h"

@interface ChooseView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BankListModel *model;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *andButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) XXNSArrayBlock block ;
@property (strong, nonatomic) XXVoidBlock andBlock ;
@property (strong, nonatomic) XXVoidBlock closeBlock ;

@end

@implementation ChooseView


- (instancetype)initWithFrame:(CGRect)frame data:(BankListModel *)model block:(XXNSArrayBlock)block andBlock:(XXVoidBlock)andBlock closeBlock:(XXVoidBlock)closeBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.model = model;
        if (block)
        {
            self.block = [block copy];
        }
        if (andBlock)
        {
            self.andBlock = [andBlock copy];
        }
        if (closeBlock)
        {
            self.closeBlock = [closeBlock copy];
        }
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ChooseBankCell" bundle:nil] forCellReuseIdentifier:@"chooseBank_cell"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.lineView];
    [self addSubview:self.tableView];
    [self addSubview:self.andButton];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat height = self.model.total > 4 ? 230 : self.model.total *50;
        _tableView = [[UITableView alloc]initWithFrame:kFrame(0, 50, self.xx_width, height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_W, 49)];
        _titleLabel.textColor = ColorWithHex(0x010101);
        _titleLabel.font = kFont_Medium(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择银行账户";
    }
    return _titleLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_W-15-16, 17, 16, 16)];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        [_closeButton xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            self.closeBlock();
        }];
    }
    return _closeButton;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, self.xx_width, 1)];
        _lineView.backgroundColor = ColorWithHex(0xE6E6E6);
    }
    return _lineView;
}

- (UIButton *)andButton
{
    if (!_andButton)
    {
        _andButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _andButton.frame = kFrame(0, self.tableView.xx_max_y, self.xx_width, 60);
        _andButton.xx_titleColor = Home_Text_Color;
        _andButton.xx_font = 15;
        _andButton.xx_title = @" 添加银行卡";
        _andButton.xx_img = kImage(@"add22");
//        [_andButton xx_h_imgAndTitle];
//        _andButton.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        [_andButton xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            self.andBlock();
        }];
    }
    return _andButton;
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [self.tableView reloadData];
//    self.block(<#NSArray *arr#>)
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChooseBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseBank_cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_selectIndex == indexPath.row) {
        [cell setData:self.model.rows[indexPath.row] btnType:1];
    }
    else
    {
        [cell setData:self.model.rows[indexPath.row] btnType:0];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.total;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
