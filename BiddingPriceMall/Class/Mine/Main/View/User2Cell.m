//
//  User2Cell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "User2Cell.h"

@interface User2Cell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end

@implementation User2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSArray *)data
{
    self.titleLbl.text = data[0];
    self.contentLbl.text = data[1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
