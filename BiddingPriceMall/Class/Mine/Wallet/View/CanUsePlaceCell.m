//
//  CanUsePlaceCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CanUsePlaceCell.h"

@interface CanUsePlaceCell ()
@property (strong, nonatomic) XXVoidBlock block ;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *placesSum;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CanUsePlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _bgView.layer.shadowColor = kLightGray.CGColor;
    _bgView.layer.shadowOpacity = 0.8;
}

- (void)setData:(Placeslist *)model
{
    self.ticketNumber.text = kStrMerge(@"商品编号", model.ticketNumber);
    self.productName.text = model.productName;
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",model.newPrice];
    self.placesSum.text = [NSString stringWithFormat:@"仓单数量：%.2f",model.placesSum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)use:(id)sender
{
    self.block();
}

- (void)tapBlock:(XXVoidBlock)block
{
    if (block)
    {
        self.block = [block copy];
    }
}

@end
