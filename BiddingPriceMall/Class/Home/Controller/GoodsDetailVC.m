//
//  GoodsDetailVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "GoodsDisplayVC.h"

@interface GoodsDetailVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *openPrice;
@property (weak, nonatomic) IBOutlet UILabel *salesVolume;
@property (weak, nonatomic) IBOutlet UILabel *inventory;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *goTop;

@property (nonatomic, assign) CGFloat imgScale;

@end

@implementation GoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = @"商品详情";
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
//        
//    }];
}

- (void)createUI
{
    [self.head sd_setImageWithURL:kUrl(_model.titleFile) placeholderImage:kImage(@"")];
    self.productName.text = _model.productName;
    self.remark.text = _model.remark;
    self.price.text = kStrNum(_model.newPrice);
    self.openPrice.text = kStrMerge(@"开市价：¥", kStrNum(_model.openPrice));
    self.ticketNumber.text = _model.ticketNumber;
    self.salesVolume.text = kStrMerge(@"销量：", kStrNum(_model.salesVolume));
    self.inventory.text = kStrMerge(@"库存：", kStrNum(_model.inventory));
    
    self.image = [[UIImageView alloc]initWithFrame:kFrame(0, kScreen_W+260, kScreen_W, 500)];
    [self.scrollView addSubview:self.image];
    self.scrollView.scrollEnabled = NO;
    [self.image sd_setImageWithURL:kUrl(_model.file) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        CGSize size = image.size;
        
        CGFloat w = size.width;
        
        CGFloat H = size.height;
        
        //这里会运行两次，第一次运行里面的值都为空，第二次运行才会赋值，所以这里做个判断
        if(H > 0){
            self.imgScale = H/w;
            self.scrollView.contentSize = CGSizeMake(0, kScreen_W+kScreen_W*self.imgScale+260+(kScreen_W-40)/335*45+20);
            self.image.frame = CGRectMake(0, kScreen_W+260, kScreen_W, kScreen_W * self.imgScale);
            self.image.contentMode = UIViewContentModeScaleToFill;
            self.scrollView.scrollEnabled = YES;
        }
    }];
    
    [self.view addSubview:self.goTop];
    [self.view addSubview:self.footView];
}


- (IBAction)trading:(id)sender
{
    GoodsDisplayVC *vc = (GoodsDisplayVC *)[self xx_getSb:@"Home" identifier:@"goodsDisplay_sb"];
    vc.model = self.model;
    [self xx_pushVC:vc];
}

#pragma mark - Lazy loading
- (UIButton *)goTop
{
    if (!_goTop) {
        _goTop = [[UIButton alloc]xx_initWithFrame:kFrame(kScreen_W-12-44, kScreen_H-(kScreen_W-40)/335*45-20-kSafeAreaBottomHeight-50, 44, 44) img:@"top" bgImg:@"" cornerRadius:0 Block:^(NSInteger tag) {
            [self.scrollView scrollToTop];
        }];
        _goTop.hidden = YES;
    }
    return _goTop;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]xx_initLineFrame:kFrame(0, kScreen_H-(kScreen_W-40)/335*45-20-kSafeAreaBottomHeight, kScreen_W, (kScreen_W-40)/335*45+20) color:kWhite];
        _footView.hidden = YES;
        UIButton *btn = [[UIButton alloc]xx_initWithFrame:kFrame(20, 10, kScreen_W-40,(kScreen_W-40)/335*45 ) img:@"" bgImg:@"login_cutton" cornerRadius:0 Block:^(NSInteger tag) {
            GoodsDisplayVC *vc = (GoodsDisplayVC *)[self xx_getSb:@"Home" identifier:@"goodsDisplay_sb"];
            vc.model = self.model;
            [self xx_pushVC:vc];
        }];
        btn.xx_title = @"立即交易";
        [_footView addSubview:btn];
    }
    return _footView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > kScreen_W +100) {
        _footView.hidden = NO;
        _goTop.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(0, kScreen_W+kScreen_W*self.imgScale+260+(kScreen_W-40)/335*45+20);
    }
    else
    {
        _footView.hidden = YES;
        _goTop.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(0, kScreen_W+kScreen_W*self.imgScale+260+10);
    }
   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
