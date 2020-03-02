//
//  PlaceBuyView.m
//  BiddingPriceMall
//
//  Created by zheng on 2019/11/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PlaceBuyView.h"
#import "WalletModel.h"

@interface PlaceBuyView ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *entrustPrice;
@property (weak, nonatomic) IBOutlet UILabel *availableAmount;
@property (weak, nonatomic) IBOutlet UILabel *placeNum;
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@property (weak, nonatomic) IBOutlet UIButton *close;

@property (strong, nonatomic) XXNSArrayBlock block ;
@property (strong, nonatomic) XXVoidBlock closeBlock ;
@property (strong, nonatomic) Placeslist *model;
@property (strong, nonatomic) UserModel *userModel;
@property (nonatomic, strong) NSDictionary *distributionFlag;
@property (nonatomic ,copy) NSString *type;

@end

@implementation PlaceBuyView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PlaceBuyView class]) owner:self options:nil] firstObject];
        if (block)
        {
            self.block = [block copy];
        }
        if (closeBlock)
        {
            self.closeBlock = [closeBlock copy];
        }
        self.type = @"2";
        self.model = data[0];
        self.userModel = data[1];
        self.distributionFlag = data[2];
        [self updateUI];
    }
    
    return self;
}

- (void)reloadBuyView:(NSArray *)data
{
    self.model = data[0];
    self.userModel = data[1];
    self.distributionFlag = data[2];
    [self updateUI];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.close.xx_touchAreaInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.frame = kFrame(0, kScreen_H, kScreen_W, 430);
}

- (void)updateUI
{
    self.availableAmount.text = [NSString stringWithFormat:@"%.2f元",_userModel.balance];
    self.placeNum.text = kStrNum([self.distributionFlag[@"number"] integerValue]);
    self.buyNum.text = kStrNum([self.distributionFlag[@"number"] integerValue]);
    self.name.text = self.model.productName;
    self.entrustPrice.text = [NSString stringWithFormat:@"%.2f",self.model.newPrice];
    CGFloat a = _model.newPrice*[self.buyNum.text integerValue];
    NSString *b = [NSString stringWithFormat:@"%.2f",a];
    self.payAmount.text = kStrMerge(b, @"元");
}


- (IBAction)close:(id)sender
{
    self.closeBlock();
}

- (IBAction)pay:(id)sender
{
    NSInteger a = [self.distributionFlag[@"number"] integerValue];

        if (a == 0) {
            [MBProgressHUD showError:@"仓单数量不能为空" toView:kWindow];
        }
        else
        {
            self.block(@[self.buyNum.text,self.payAmount.text,self.type]);
        }
    
}


@end
