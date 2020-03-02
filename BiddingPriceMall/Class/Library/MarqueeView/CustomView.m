//
//  CustomView.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

#pragma mark - 懒加载
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [self addSubview:_contentLabel];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = kFont_Medium(13);
        _contentLabel.textColor = kGray;
    }
    return _contentLabel;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.contentLabel.frame = CGRectMake(0, (self.xx_height-20)/2 , self.xx_width, 20);
}

@end
