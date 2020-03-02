//
//  XXBaseViewController.m
//  Unity-iPhone
//
//  Created by Aranion on 2018/3/2.
//

#import "XXBaseViewController.h"
#import "XXNavView.h"

@interface XXBaseViewController ()

@end

@implementation XXBaseViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//    //    return UIStatusBarStyleDefault;
//    
//}

#pragma mark - get

- (XXNavView*)nav
{
    if(_nav == nil)
    {
        _nav = [[XXNavView alloc] initWithType:0 block:^(NSInteger num) {
            
            if (num == 0)
            {
                [self leftBarBtnClicked];
            }
            else
            {
                [self rightBarBtnClicked];
            }
        }];
        [self.view addSubview:_nav];
        
//        _nav.btnRigth.xx_img = kImage(@"icon_top_xsjc_home");
        
    }
    return _nav;
}


#pragma mark - set

-(void)setLeftItemImg:(UIImage *)leftItemImg
{
    self.nav.btnleft.xx_title = nil;
    self.nav.btnleft.xx_img = leftItemImg;
    self.nav.btnleft.xx_width = 25;
    self.nav.btnleft.hidden = NO;
    _leftItemImg = leftItemImg;
}
- (void)setLeftItemTitle:(NSString *)leftItemTitle
{
    self.nav.btnleft.xx_title = leftItemTitle;
    self.nav.btnleft.xx_img = nil;
    self.nav.btnleft.xx_width = [XXTollClass calStrSize:leftItemTitle andMaxSize:kSize(200, 18) andFontSize:18].width;
    self.nav.btnleft.hidden = NO;
    _leftItemTitle = leftItemTitle;
}
- (void)setLeftItemTilteColor:(UIColor *)leftItemTilteColor
{
    self.nav.btnleft.xx_titleColor = leftItemTilteColor;
    _leftItemTilteColor = leftItemTilteColor;
}
-(void)setRightItemImg:(UIImage *)rightItemImg
{
    self.nav.btnRigth.xx_title = nil;
    self.nav.btnRigth.xx_img = rightItemImg;
    self.nav.btnRigth.xx_width = 25;
    self.nav.btnRigth.hidden = NO;
    _rightItemImg = rightItemImg;
}
- (void)setRightItemTitle:(NSString *)rightItemTitle
{
    self.nav.btnRigth.xx_title = rightItemTitle;
    self.nav.btnRigth.xx_img = nil;
    CGFloat w = [XXTollClass calStrSize:rightItemTitle andMaxSize:kSize(200, 18) andFontSize:18].width;
    self.nav.btnRigth.xx_width = w;
    self.nav.btnRigth.xx_x = kScreen_W-w-10;
    self.nav.btnRigth.hidden = NO;
    _rightItemTitle  = rightItemTitle;
}
- (void)setRightItemTilteColor:(UIColor *)rightItemTilteColor
{
    self.nav.btnRigth.xx_titleColor = rightItemTilteColor;
    _rightItemTilteColor = rightItemTilteColor;
}
- (void)rightBarBtnClicked{
    
}
- (void)leftBarBtnClicked
{
    [self xx_pop];
}


@end
