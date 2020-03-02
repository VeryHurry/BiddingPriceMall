//
//  SellDayHeadView.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SellDayHeadView.h"

@implementation SellDayHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SellDayHeadView class]) owner:self options:nil] firstObject];
    }
    return self;
}

@end
