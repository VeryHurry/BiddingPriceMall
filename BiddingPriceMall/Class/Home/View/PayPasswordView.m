//
//  PayPasswordView.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PayPasswordView.h"
#import "SYPasswordView.h"

@interface PayPasswordView ()

@property (strong, nonatomic) XXNSArrayBlock block ;
@property (strong, nonatomic) XXVoidBlock closeBlock ;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *payPopupView;
@property (nonatomic, strong) UILabel *titleLabel, *titleLabel1, *titleLabel2;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SYPasswordView *pasView;

@end

@implementation PayPasswordView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (block)
        {
            self.block = [block copy];
        }
        if (closeBlock)
        {
            self.closeBlock = [closeBlock copy];
        }
        self.data = data;
        [self createUI];
        
    }
    return self;
}

- (void)createUI{
    
    if (kIsEmptyArr(self.data)) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.lineView];
        [self addSubview:self.pasView];
    }
    else
    {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel1];
    [self addSubview:self.titleLabel2];
    [self addSubview:self.pasView];
    }
    
    
}

#pragma mark -Setter/Getter

- (SYPasswordView *)pasView
{
    if (!_pasView)
    {
        CGFloat height = kIsEmptyArr(self.data) ? 73 : 118;
        _pasView = [[SYPasswordView alloc]initWithFrame:CGRectMake((kScreen_W-334)/2, height, 334, 50) data:@[] block:^(NSArray *arr) {
            self.block(arr);
        }];
        
    }
    return _pasView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_W, 50)];
        _titleLabel.textColor = ColorWithHex(0x010101);
        _titleLabel.font = kFont_Medium(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kIsEmptyArr(self.data) ? @"支付密码" : @"确认支付";
    }
    return _titleLabel;
}

- (UILabel *)titleLabel1
{
    if (!_titleLabel1)
    {
        _titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 68, kScreen_W, 20)];
        _titleLabel1.textColor = HomeColor;
        _titleLabel1.font = kFont_Bold(20);
        _titleLabel1.textAlignment = NSTextAlignmentCenter;
        _titleLabel1.text = [NSString stringWithFormat:@"支付%@元",self.data[0]];
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2
{
    if (!_titleLabel2)
    {
        _titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 96, kScreen_W, 12)];
        _titleLabel2.textColor = ColorWithHex(0xcccccc);
        _titleLabel2.font = kFont_Medium(12);
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.text = @"请输入支付密码";
    }
    return _titleLabel2;
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
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreen_W, 1)];
        _lineView.backgroundColor = ColorWithHex(0xE6E6E6);
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
