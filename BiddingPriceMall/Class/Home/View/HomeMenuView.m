//
//  HomeMenuView.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HomeMenuView.h"
#define scale (kScreen_W-20)/355
@interface HomeMenuView ()

@property (strong, nonatomic) XXIntegerBlock block ;
@property (strong, nonatomic) NSArray *titleArr ;
@property (strong, nonatomic) NSArray *imageArr ;

@end

@implementation HomeMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr block:(XXIntegerBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        self.layer.shadowColor = kLightGray.CGColor;
        self.layer.shadowOpacity = 0.8;
        if (block)
        {
            self.block = [block copy];
        }
        self.titleArr = titleArr;
        self.imageArr = imageArr;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    for (int i = 0; i < 5; i++) {
        UIButton *logoImageV = [[UIButton alloc]init];
        logoImageV.frame = CGRectMake(self.width/5*i, 0, self.width/5, self.height);
        [logoImageV xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            self.block(i);
        }];
        [self addSubview:logoImageV];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = kFrame(0, 0, scale*40, scale*40);
        image.center = CGPointMake(logoImageV.frame.size.width/2, logoImageV.frame.size.height/2-scale*10);
        image.image = [UIImage imageNamed:self.imageArr[i]];
        [logoImageV addSubview:image];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:12*scale];
        titleLabel.textColor = kMidGray;
        titleLabel.text = self.titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [logoImageV addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image.mas_centerX).offset(0);
            make.bottom.equalTo(logoImageV.mas_bottom).offset(-16*scale);
            make.width.offset(self.width/5);
            make.height.offset(13*scale);
        }];
    }
    
}

@end
