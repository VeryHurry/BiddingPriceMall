//
//  ForgetVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ForgetVC.h"
#import "NewPasswordVC.h"

@interface ForgetVC ()

@property (weak, nonatomic) IBOutlet UITextField *phone_txt;
@property (weak, nonatomic) IBOutlet UITextField *code_txt;
@property (weak, nonatomic) IBOutlet UIButton *code_btn;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;

@end

@implementation ForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = @"忘记密码";
    // Do any additional setup after loading the view.
}

#pragma mark - networking
/* 获取验证码
 1：登录验证码
 2：修改支付密码
 3：忘记密码
 4：提现验证码
 5：注册验证码
 */
- (void)getSMSCode
{
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_sendSms andData:@{@"phone":_phone_txt.text,@"type":@"3"} andSuccessBlock:^(id success) {
        [self openCountdown];
    } andFailureBlock:^(id failure) {
        
    }];
}

-(void)changePassword
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone],@"verifyCode":_code_txt.text};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_forgetPws1 andData:dic andSuccessBlock:^(id success) {
        [self xx_pushVC:[self xx_getSb:@"Login" identifier:@"newPSW_sb"]];
    } andFailureBlock:^(id failure) {
        
    }];
}


- (IBAction)sure_action:(id)sender
{
    if (kIsEmptyStr(_phone_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPhone];
    }
    else if (![XXTollClass isTelphoneNum:_phone_txt.text])
    {
        [MBProgressHUD showError:txt_phoneError];
    }
    else if (kIsEmptyStr(_code_txt.text))
    {
        [MBProgressHUD showError:txt_emptyCode];
    }
    else
    {
        [self changePassword];
    }
}

- (IBAction)code_action:(id)sender
{
    if (kIsEmptyStr(_phone_txt.text)) {
        [MBProgressHUD showError:txt_emptyPhone];
    }
    else if (![XXTollClass isTelphoneNum:_phone_txt.text])
    {
        [MBProgressHUD showError:txt_phoneError];
    }
    else
    {
        
        [self getSMSCode];
    }
}

#pragma mark - 开启倒计时效果
-(void)openCountdown{
    __block NSInteger time = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.code_btn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.code_btn.xx_titleColor = kWhite;
                self.code_btn.xx_borderColor = Home_Text_Color;
                self.code_btn.backgroundColor = Home_Text_Color;
                self.code_btn.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 120;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NSString *resend = @"已发送";
                [self.code_btn setTitle:[NSString stringWithFormat:@"%@(%ds)", resend,seconds] forState:UIControlStateNormal];
                self.code_btn.xx_titleColor = Home_Text_Color;
                self.code_btn.xx_borderColor = Home_Text_Color;
                self.code_btn.backgroundColor = kWhite;
                self.code_btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
