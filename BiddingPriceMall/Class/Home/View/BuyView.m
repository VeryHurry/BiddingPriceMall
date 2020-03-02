//
//  BuyView.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BuyView.h"

@interface BuyView ()

@property (strong, nonatomic) XXNSArrayBlock block ;
@property (strong, nonatomic) XXVoidBlock closeBlock ;
@property (strong, nonatomic) Rows *model;
@property (strong, nonatomic) UserModel *userModel;
@property (nonatomic, strong) NSDictionary *distributionFlag;
@property (nonatomic ,copy) NSString *type;

@end

@implementation BuyView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BuyView class]) owner:self options:nil] firstObject];
        if (block)
        {
            self.block = [block copy];
        }
        if (closeBlock)
        {
            self.closeBlock = [closeBlock copy];
        }
        self.type = @"1";
        self.model = data[0];
        self.userModel = data[1];
        self.distributionFlag = data[2];
        [self updateUI];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.remember.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.add.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.cut.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.close.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.frame = kFrame(0, kScreen_H, kScreen_W, 430);
}

- (void)updateUI
{
    [self updatePrice];
    self.availableAmount.text = [NSString stringWithFormat:@"%.2f元",_userModel.balance];
    self.add.userInteractionEnabled = self.remember.selected ? YES : NO;
    self.cut.userInteractionEnabled = self.remember.selected ? YES : NO;
    self.add.xx_img = self.remember.selected ? kImage(@"add2") : kImage(@"add");
    self.cut.xx_img = self.remember.selected ? kImage(@"cut2") : kImage(@"cut");
    self.remember.xx_img = self.remember.selected ? kImage(@"login_remember_1") : kImage(@"login_remember_2");
    NSInteger num = [self.distributionFlag[@"number"] integerValue];
    self.number.text = kStrNum(num);
    [self updatePrice];
}

- (IBAction)use:(id)sender
{
    NSInteger a = [self.distributionFlag[@"number"] integerValue];
    if (a > 0 ) {
        self.remember.selected = !self.remember.selected;
        [self updateUI];
    }
    
}

- (void)updatePrice
{
    if (!self.remember.selected) {
        self.type = @"1";
        self.canBuyNum.text = kString(@"10手");
        self.entrustNum.text = kString(@"10手");
        self.entrustPrice.text = kStrMerge(kStrNum(_model.newPrice), @"元");
        CGFloat a = _model.newPrice*10;
        NSString *b = [NSString stringWithFormat:@"%.2f",a];
        self.payAmount.text = kStrMerge(b, @"元");
    }
    else
    {
        
        self.type = @"2";
        self.canBuyNum.text = kStrMerge(kString([self.distributionFlag objectForKey:@"number"]), @"手");
        self.entrustNum.text = kStrMerge(kString([self.distributionFlag objectForKey:@"number"]), @"手");
        self.entrustPrice.text = kStrMerge(kStrNum(_model.distributionPrice), @"元");
        CGFloat a = _model.distributionPrice*[self.number.text integerValue];
        NSString *b = [NSString stringWithFormat:@"%.2f",a];
        self.payAmount.text = kStrMerge(b, @"元");
    }
}

- (IBAction)cut:(id)sender
{
    
    NSInteger a = [self.number.text integerValue];
    if (a > 1) {
        self.number.text = kStrNum(a-1);
    }
    [self updatePrice];
    
}

- (IBAction)add:(id)sender
{
    //提货订单
    if ([[self.distributionFlag objectForKey:@"flag"] integerValue] == 1) {
        self.add.userInteractionEnabled =  NO;
        self.cut.userInteractionEnabled = NO;
        self.add.xx_img = kImage(@"add");
        self.cut.xx_img = kImage(@"cut");
    }
    //配送订单
    else
    {
        NSInteger a = [self.number.text integerValue];
        NSInteger b = [[self.distributionFlag objectForKey:@"number"] integerValue];
        if (a < b) {
            self.number.text = kStrNum(a+1);
        }
    }
    [self updatePrice];
}

- (IBAction)close:(id)sender
{
    self.closeBlock();
}

- (IBAction)pay:(id)sender
{
    NSInteger a = [self.distributionFlag[@"number"] integerValue];
    if ([self.type isEqualToString:@"2"]) {
        if (a == 0) {
            [MBProgressHUD showError:@"商品数量不能为空" toView:kWindow];
        }
        else
        {
            self.block(@[self.number.text,self.entrustPrice.text,self.payAmount.text,self.type]);
        }
    }
    else
    {
        self.block(@[@"10",self.entrustPrice.text,self.payAmount.text,self.type]);
    }
}

@end

