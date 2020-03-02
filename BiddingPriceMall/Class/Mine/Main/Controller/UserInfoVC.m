

//
//  UserInfoVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UserInfoVC.h"
#import "User1Cell.h"
#import "User2Cell.h"
#import "User3Cell.h"
#import "ChangePassWordViewController.h"
#import "ChangePayPSDViewController.h"
#import "AddressListVC.h"
#import "BankListViewController.h"
#import "ShareViewController.h"
#import "MyTeamViewController.h"

@interface UserInfoVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation UserInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!kIsEmptyStr([kUserDefaults objectForKey:def_id])) {
        [self getUserInfoMessage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"个人信息";
    self.tableView.frame = kFrame(0, kNav_H, kScreen_W, kScreen_H-kNav_H-kSafeAreaBottomHeight-kScale_W(49)-kScale_W(8));
    
    [self.tableView registerNib:[UINib nibWithNibName:@"User1Cell" bundle:nil] forCellReuseIdentifier:@"user1_cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"User2Cell" bundle:nil] forCellReuseIdentifier:@"user2_cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"User3Cell" bundle:nil] forCellReuseIdentifier:@"user3_cell"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kFrame(0, kScreen_H-kScale_W(49)-kSafeAreaBottomHeight, kScreen_W, kScale_W(49));
    btn.xx_title = @"退出登录";
    btn.xx_titleColor = kRed;
    btn.titleLabel.font = kFont_Medium(16);
    btn.backgroundColor = kWhite;
    [btn xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self logout];
    }];
    
    UIView *line = [[UIView alloc]xx_initLineFrame:kFrame(0, 0, kScreen_W, 1) color:kBgGray];
    [btn addSubview:line];
    [self.view addSubview:btn];
}

#pragma mark - network
//获取用户信息
- (void)getUserInfoMessage
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_accountInfo andData:dic andSuccessBlock:^(id success) {
        UserModel *model = [UserModel modelWithJSON:success[@"rows"]];
        [kUserDefaults setObject:success[@"rows"] forKey:def_userModel];
        [kUserDefaults setObject:model.accountNo forKey:def_phone];
        [kUserDefaults setObject:model.ID forKey:def_id];
        [kUserDefaults synchronize];
        [self.tableView reloadData];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

//上传头像
- (void)updateHeadImg:(UIImage *)img
{
    [MBProgressHUD showMessage:txt_upLoad toView:kWindow];
    NSData *imageData = UIImageJPEGRepresentation(img, 1);
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addHeadImg imageData:imageData fileName:@"headImg" parameter:dic andSuccessBlock:^(id success) {
        [self getUserInfoMessage];
        [MBProgressHUD hideHUDForView:kWindow];
        [MBProgressHUD showSuccess:txt_upLoadSuccess];
    } andFailureBlock:^(id failure) {
        [MBProgressHUD hideHUDForView:kWindow];
    }];
}

//退出登录
- (void)logout
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_logOut andData:dic andSuccessBlock:^(id success) {
//        NSUserDefaults*defatluts = [NSUserDefaults standardUserDefaults];
//        NSDictionary*dictionary = [defatluts dictionaryRepresentation];
//        for(NSString*key in [dictionary allKeys])
//        {
//           [defatluts removeObjectForKey:key];
//           [defatluts synchronize];
//        }
        [kUserDefaults removeObjectForKey:def_userModel];
        [self xx_pop];
        [MBProgressHUD showSuccess:@"退出成功" toView:kWindow];
        
        
    } andFailureBlock:^(id failure) {
        
    }];
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self choosePhoto];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 3) {
            [self xx_pushVC:[MyTeamViewController new]];
        }
        else if (indexPath.row == 4)
        {
            ShareViewController *vc = (ShareViewController *)[self xx_getSb:@"Mine" identifier:@"share_sb"];
            [self xx_pushVC:vc];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            [self xx_pushVC:[self xx_getSb:@"SecurityCenter" identifier:@"loginPSW_sb"] animated:YES];
        }
        else
        {
            [self xx_pushVC:[self xx_getSb:@"SecurityCenter" identifier:@"payPSW_sb"] animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
            [self xx_pushVC:[AddressListVC new] animated:YES];
        }
        else
        {
            [self xx_pushVC:[BankListViewController new] animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    UserModel *model = [UserModel modelWithJSON:dic];
    if (indexPath.section == 0) {
        User1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"user1_cell" forIndexPath:indexPath];
        [cell.user_img sd_setImageWithURL:kUrl(model.headImg) placeholderImage:kImage(@"person-center_icon")];
        return cell;
        
    }
    else if (indexPath.section == 1) {
        
        NSArray *arr = @[@[@"手机号码",model.accountNo],@[@"姓名",kString(model.userName)],@[@"身份证号",model.idcard],@"我的拼团",@"分享二维码"];
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
            User2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"user2_cell" forIndexPath:indexPath];
            [cell setData:arr[indexPath.row]];
            return cell;
        }
        else
        {
            User3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"user3_cell" forIndexPath:indexPath];
            [cell setData:arr[indexPath.row]];
            return cell;
        }
        
    }
    else
    {
        NSArray *arr;
        if (indexPath.section == 2) {
            arr = @[@"登录密码",@"支付密码"];
        }
        else
        {
            arr = @[@"收货地址",@"银行卡"];
        }
        User3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"user3_cell" forIndexPath:indexPath];
        [cell setData:arr[indexPath.row]];
        return cell;
        
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 5;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else
    {
        return kScale_W(48);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScale_W(8);
}

#pragma mark - other
- (void)choosePhoto
{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self updateHeadImg:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

