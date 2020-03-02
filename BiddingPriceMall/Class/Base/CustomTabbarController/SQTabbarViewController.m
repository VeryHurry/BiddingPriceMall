//
//  SQTabbarViewController.m
//  LeTu
//
//  Created by MacStudent on 2019/5/8.
//  Copyright © 2019 mtt. All rights reserved.
//

#import "SQTabbarViewController.h"
#import "HomeViewController.h"
#import "MyGoodsViewController.h"
#import "MineViewController.h"
#import "CanUsePlaceViewController.h"

@interface SQTabbarViewController ()<UITabBarDelegate>

@end

@implementation SQTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    
    //选中tabbar第一个item
    self.selectedIndex = 0;
    
    
}

#pragma mark -------------------- 设置tabbar上文字、图片 --------------------
- (void)setUpTabBarItemTextAttributes {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = kGray;
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = Home_Text_Color;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

#pragma mark -------------------- 添加子控制器 --------------------
- (void)setUpChildViewController {
    [self addOneChildViewController:[[HomeViewController alloc]init]
                          WithTitle:@"川藏亚吉"
                          imageName:@"index_1"
                  selectedImageName:@"index"];
    [self addOneChildViewController:[self xx_getSb:@"MyGoods" identifier:@"myGoods_sb"]
                          WithTitle:@"我的商品"
                          imageName:@"commodity_1"
                  selectedImageName:@"commodity"];
    [self addOneChildViewController:[[CanUsePlaceViewController alloc]init]
                          WithTitle:@"协议仓单"
                          imageName:@"place_1"
                  selectedImageName:@"place"];
    [self addOneChildViewController:[self xx_getSb:@"Mine" identifier:@"mine_sb"]
                          WithTitle:@"个人中心"
                          imageName:@"mine_1"
                  selectedImageName:@"mine"];
    
}

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    viewController.tabBarItem.title = title;
    CGFloat a = kStatus_H == 20.0 ? -3 : 0;
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, a)];
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:navi];
}

#pragma mark -------------------- tabbarItem点击事件 --------------------
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    [self addAnimationToIndex:index];
}

#pragma mark -------------------- tabbarItem抖动动画 --------------------
- (void)addAnimationToIndex:(NSInteger)index{
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CAKeyframeAnimation *bounceAnimation = [[CAKeyframeAnimation alloc] init];
    bounceAnimation.keyPath = @"transform.scale";
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.6;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [[tabbarbuttonArray[index] layer] addAnimation:bounceAnimation forKey:@"TabBarItemAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
