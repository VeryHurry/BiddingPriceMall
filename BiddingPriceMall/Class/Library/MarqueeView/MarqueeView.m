//
//  MarqueeView.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MarqueeView.h"
#import "CustomView.h"

@interface MarqueeView()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *iconImg;
@property(nonatomic,strong)UIImageView *moreImg;
@property(nonatomic,strong)UILabel *moreLabel;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)CustomView *customView1;
@property(nonatomic,strong)CustomView *customView2;

@end
@implementation MarqueeView
{
    // 记录位置
    NSInteger currentIndex;
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:kFrame(0, 0, self.xx_width, self.xx_height)];
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (CustomView *)customView1 {
    if (!_customView1) {
        _customView1 = [[CustomView alloc]initWithFrame:self.bounds];
        [self.bgView addSubview:_customView1];
        _customView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [_customView1 addGestureRecognizer:tap];
    }
    return _customView1;
}
- (CustomView *)customView2 {
    if (!_customView2) {
        _customView2 = [[CustomView alloc]initWithFrame:self.bounds];
        [self.bgView addSubview:_customView2];
        _customView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [_customView2 addGestureRecognizer:tap];
    }
    return _customView2;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.image = kImage(@"svg");
        [self addSubview:_iconImg];
    }
    return _iconImg;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc]init];
        [self addSubview:_moreLabel];
        _moreLabel.text = @"更多";
        _moreLabel.textAlignment = 2;
        _moreLabel.font = kFont_Medium(13);
        _moreLabel.textColor = Home_Text_Color;
        
    }
    return _moreLabel;
}

- (UIImageView *)moreImg {
    if (!_moreImg) {
        _moreImg = [[UIImageView alloc]init];
        _moreImg.image = kImage(@"more");
        [self addSubview:_moreImg];
        
    }
    return _moreImg;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc]init];
        _moreButton.backgroundColor = [UIColor clearColor];
        [_moreButton xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (self.moreBlock) {
                self.moreBlock();
            }
        }];
        [self addSubview:_moreButton];
    }
    return _moreButton;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        self.layer.shadowColor = kLightGray.CGColor;
        self.layer.shadowOpacity = 0.8;
        [self setupView];
        
        // 设置默认数据
        self.animationDuration = 1.f;
        self.pauseDuration = 1.5f;
    }
    return self;
}
- (void)setupView {
    
    [self addSubview:self.bgView];
    
    self.iconImg.frame = kFrame(10, (self.xx_height-11)/2, 12.5, 11);
    self.moreImg.frame = kFrame(self.xx_width-10-4.5, (self.xx_height-8)/2, 4.5, 8);
    self.moreLabel.frame = CGRectMake(CGRectGetMinX(self.moreImg.frame) - 10 - 25, (self.xx_height- 20)/2, 28, 20);
    
    self.moreButton.frame = CGRectMake(self.moreLabel.xx_x, 0, self.xx_width - self.moreLabel.xx_x, self.xx_height);
    
    // 设置Label的frame
    self.customView1.frame = CGRectMake(self.iconImg.xx_max_x + 10, 0 , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
    self.customView2.frame = CGRectMake(self.iconImg.xx_max_x + 10, self.bgView.xx_height , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
}

#pragma mark - 设置动画
-(void)startMarqueeViewAnimation{
    
    // 1.设置滚动前的数据
    self.customView1.contentLabel.text = self.marqueeContentArray[currentIndex];
    self.customView1.frame = CGRectMake(self.iconImg.xx_max_x + 10, 0 , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
    
    // 提前计算currentIndex
    currentIndex++;
    if(currentIndex >= [self.marqueeContentArray count]) {
        currentIndex = 0;
    }
    
    self.customView2.contentLabel.text = self.marqueeContentArray[currentIndex];
    self.customView2.frame = CGRectMake(self.iconImg.xx_max_x + 10, self.bgView.xx_height , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
    
    
    // 2.开始动画
    [UIView animateWithDuration:self.animationDuration animations:^{
        
        self.customView1.frame = CGRectMake(self.iconImg.xx_max_x + 10, -self.bgView.xx_height , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
        self.customView2.frame = CGRectMake(self.iconImg.xx_max_x + 10, 0 , self.moreLabel.xx_x - self.iconImg.xx_max_x - 10-15, self.bgView.xx_height);
        
    } completion:^(BOOL finished) {
        
        // 延迟一秒再次启动动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.pauseDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startMarqueeViewAnimation];
        });
        
    }];
}

#pragma mark - 开始动画
- (void)start {
    
    // 设置动画默认第一条信息
    currentIndex = 0;
    
    // 开始动画
    [self startMarqueeViewAnimation];
}
#pragma mark - 点击事件
- (void)onClick {
    if (self.block) {
        self.block(currentIndex);
    }
}

@end
