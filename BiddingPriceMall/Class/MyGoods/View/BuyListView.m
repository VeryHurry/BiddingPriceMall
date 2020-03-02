//
//  BuyListView.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BuyListView.h"

@implementation BuyListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BuyListView class]) owner:self options:nil] firstObject];
    }
    return self;
}


@end
