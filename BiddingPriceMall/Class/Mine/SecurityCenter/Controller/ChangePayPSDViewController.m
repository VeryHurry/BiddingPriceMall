//
//  ChangePayPSDViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ChangePayPSDViewController.h"

@interface ChangePayPSDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phone_txt;
@property (weak, nonatomic) IBOutlet UITextField *psd1_txt;
@property (weak, nonatomic) IBOutlet UITextField *psd2_txt;
@property (weak, nonatomic) IBOutlet UITextField *code_txt;
@property (weak, nonatomic) IBOutlet UIButton *code_btn;
@property (weak, nonatomic) IBOutlet UIButton *psd1_btn;
@property (weak, nonatomic) IBOutlet UIButton *psd2_btn;

@end

@implementation ChangePayPSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = @"修改支付密码";
    self.phone_txt.text = [kUserDefaults objectForKey:def_phone];
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
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_sendSms andData:@{@"phone":_phone_txt.text,@"type":@"2"} andSuccessBlock:^(id success) {
        [self openCountdown];
    } andFailureBlock:^(id failure) {
        
    }];
}


-(void)changePayPassword
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id],@"phone":_phone_txt.text,@"password1":[DES3Util doEncryptStr:_psd1_txt.text],@"password2":[DES3Util doEncryptStr:_psd2_txt.text],@"verifyCode":_code_txt.text};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_updatePayPsd andData:dic andSuccessBlock:^(id success) {
        [self xx_pop];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
    } andFailureBlock:^(id failure) {
        
    }];
}

#pragma mark - action
- (IBAction)psd1_action:(id)sender
{
    _psd1_txt.secureTextEntry = _psd1_btn.selected;
    _psd1_btn.selected = !_psd1_btn.selected;
    _psd1_btn.xx_img = _psd1_btn.selected?kImage(@"logon_open"):kImage(@"login_close");
}

- (IBAction)psd2_action:(id)sender
{
    _psd2_txt.secureTextEntry = _psd2_btn.selected;
    _psd2_btn.selected = !_psd2_btn.selected;
    _psd2_btn.xx_img = _psd2_btn.selected?kImage(@"logon_open"):kImage(@"login_close");
}

- (IBAction)save_action:(id)sender
{
    if (kIsEmptyStr(_phone_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPhone];
    }
    else if (![XXTollClass isTelphoneNum:_phone_txt.text])
    {
        [MBProgressHUD showError:txt_phoneError];
    }
    else if (kIsEmptyStr(_psd1_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPassword1];
    }
    else if (kIsEmptyStr(_psd2_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPassword2];
    }
    else if (!kStrEqual(_psd1_txt.text, _psd2_txt.text))
    {
        [MBProgressHUD showError:txt_passwordError];
    }
    else if (kIsEmptyStr(_code_txt.text))
    {
        [MBProgressHUD showError:txt_emptyCode];
    }
    else
    {
        [self changePayPassword];
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


@end
