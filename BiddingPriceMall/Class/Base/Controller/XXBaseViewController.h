//
//  XXBaseViewController.h
//  Unity-iPhone
//
//  Created by Aranion on 2018/3/2.
//

#import <UIKit/UIKit.h>
#import "XXNavView.h"

@interface XXBaseViewController : UIViewController

@property (strong, nonatomic) XXNavView *nav ;
@property (strong, nonatomic) UIImage * leftItemImg ;
@property (strong, nonatomic) NSString * leftItemTitle ;
@property (strong, nonatomic) UIColor *leftItemTilteColor ;
@property (strong, nonatomic) UIImage * rightItemImg ;
@property (strong, nonatomic) NSString * rightItemTitle ;
@property (strong, nonatomic) UIColor *rightItemTilteColor ;

// 左侧按钮事件
- (void)leftBarBtnClicked;
// 右侧按钮事件
- (void)rightBarBtnClicked;
@end
