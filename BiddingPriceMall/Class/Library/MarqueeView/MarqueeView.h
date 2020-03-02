//
//  MarqueeView.h
//  BiddingPriceMall
//
//  Created by mac on 2019/11/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MarqueeViewBlock) (NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface MarqueeView : UIView

@property(nonatomic,copy)MarqueeViewBlock block;
@property(nonatomic,copy)XXVoidBlock moreBlock;

@property(nonatomic,strong)NSArray *marqueeContentArray;

@property(nonatomic,assign)CGFloat animationDuration;//滚动时间
@property(nonatomic,assign)CGFloat pauseDuration;//停顿时间

- (void)start;

@end

NS_ASSUME_NONNULL_END
