//
//  MyCanBuyCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyCanBuyCell.h"

@interface MyCanBuyCell ()

@property (strong, nonatomic) XXVoidBlock block ;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;
@property (weak, nonatomic) IBOutlet UIImageView *titleFile;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MyCanBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _bgView.layer.shadowColor = kLightGray.CGColor;
    _bgView.layer.shadowOpacity = 0.8; // 必传 默认是0.0
    
    _titleFile.xx_cornerRadius = 5;

}


- (void)tapBlock:(XXVoidBlock)block
{
    if (block)
    {
        self.block = [block copy];
    }
}


- (void)setData:(BuyModel *)model
{
    [self.titleFile sd_setImageWithURL:kUrl(model.titleFile) placeholderImage:kImage(@"person-center_icon")];
    self.ticketNumber.text = model.ticketNumber;
    self.productName.text = model.productName;
    self.unitPrice.text = [NSString stringWithFormat:@"¥ %.2f",model.unitPrice];
    self.totalPrice.text = [NSString stringWithFormat:@"合计：%.2f",model.totalPrice];
    self.number.text = kStrMerge(@"x", kStrNum(model.number));
    self.orderNo.text = kStrMerge(@"订单号：", model.orderNo);
    self.finishTime.text = kStrMerge(@"下单时间：", model.finishTime);;
    
}

- (IBAction)order:(id)sender
{
    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
