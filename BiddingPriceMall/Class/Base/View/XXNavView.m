//
//  XXNavView.m
//  YJBestBusiness
//
//  Created by Aranion on 2017/9/4.
//  Copyright © 2017年 YJBest. All rights reserved.
//

#import "XXNavView.h"

@interface XXNavView()

@property (strong, nonatomic) XXIntegerBlock block ;
@property (strong, nonatomic) UIView *bgView ;



@end

@implementation XXNavView

- (instancetype)initWithType:(NSInteger)type block:(XXIntegerBlock)block
{
    if (self = [super init])
    {
        if(block)
        {
            NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
            self.block = [block copy];
            self.frame = kFrame(0, 0, kScreen_W, kNav_H);
            _navType = type;
            
            [self addSubview:self.bgView];
            [self addSubview:self.btnleft];
            [self addSubview:self.btnRigth];
            [self addSubview:self.lblTitel];
        }
    }
    return self;
}

#pragma mark - action
- (void)btnAction:(UIButton *)sender
{
    self.block(sender.tag);
}
- (void)setNavAlpha:(CGFloat)alpha
{
    self.bgView.alpha = alpha;
    self.lblTitel.alpha = alpha;
}
#pragma mark - get

- (UIButton *)btnleft
{
    if(_btnleft == nil)
    {
        NSString *str = _navType == 1 ? @"icon-back" : @"back";
        _btnleft = [XXTollClass getButtonInitWithFrame:kFrame(10, 10+kStatus_H, 24, 24) cornerRadius:0 imageName:str bgImg:nil andTitle:nil target:self action:@selector(btnAction:)];
        _btnleft.xx_touchAreaInsets = kEdgeInsets(15, 15, 20, 100);
        _btnleft.tag = 0;
    }
    
    return _btnleft;
}
- (UIButton *)btnRigth
{
    if(_btnRigth == nil)
    {
        _btnRigth = [XXTollClass getButtonInitWithFrame:kFrame(kScreen_W-55, 10+kStatus_H, 24, 24) cornerRadius:0 imageName:nil bgImg:nil andTitle:nil target:self action:@selector(btnAction:)];
        _btnRigth.xx_touchAreaInsets = kEdgeInsets(15, 100, 20, 15);
        _btnRigth.tag = 1;
        
    }
    
    return _btnRigth;
}

- (UILabel *)lblTitel
{
    if(_lblTitel == nil)
    {
        _lblTitel = [[UILabel alloc] xx_initWithFrame:kFrame(40, 12+kStatus_H, kScreen_W-80, 20) title:kIsEmptyStrReplac(self.title, @"")  fontSize:18 color:kColor_White];
        _lblTitel.font = kFont_Medium(20);
        _lblTitel.textColor = _navType == 1 ? [UIColor blackColor] : kColor_White;
        _lblTitel.xx_alignment = 2;
        _lblTitel.alpha = 1.0;
    }
    
    return _lblTitel;
}
- (UIView *)bgView
{
    if(_bgView == nil)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = _navType == 1 ? [UIColor whiteColor] : HomeColor;
        
        _bgView.alpha = 1;
    }
    
    return _bgView;
}

#pragma mark - set

- (void)setTitle:(NSString *)title
{
    _title = title;
    _lblTitel.text = title;
}


@end
