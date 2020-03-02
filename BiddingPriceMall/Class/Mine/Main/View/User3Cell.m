//
//  User3Cell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "User3Cell.h"

@interface User3Cell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;


@end

@implementation User3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSString *)data
{
    self.titleLbl.text = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
