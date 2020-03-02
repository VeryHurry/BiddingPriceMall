//
//  ShareViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *qr_img;

@property (nonatomic, copy) NSString *shareLink;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = @"分享二维码";
    self.user_img.xx_cornerRadius = self.user_img.xx_width/2;
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    UserModel *model = [UserModel modelWithJSON:dic];
    [self.user_img sd_setImageWithURL:kUrl(model.headImg) placeholderImage:kImage(@"person-center_icon")];
    self.userName.text = model.userName;
    [self getShareLink];

}

- (void)getShareLink
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_shareQrCode andData:dic andSuccessBlock:^(id success) {
        self.shareLink = success[@"data"];
        self.qr_img.image=[self createNonInterpolatedUIImageFormCIImage:[self creatQRcodeWithUrlstring:self.shareLink] withSize:500];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (IBAction)save:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.qr_img.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (IBAction)paste:(id)sender
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.shareLink;
}

- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
