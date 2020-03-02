
//
//  ChooseBankCell.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ChooseBankCell.h"

@interface ChooseBankCell ()

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation ChooseBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setData:(BankModel *)model btnType:(NSInteger)type
{
    _content.text = [NSString stringWithFormat:@"%@  %@",model.bankName,model.bankAccount];
//    _chooseBtn.xx_img = type == 1 ? kImage(@"login_remember_1") : kImage(@"login_remember_2");
    [_chooseBtn setBackgroundImage:type == 1 ? kImage(@"login_remember_1") : kImage(@"login_remember_2") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
