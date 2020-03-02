
#ifndef HttpCommunicateDefine_h
#define HttpCommunicateDefine_h

/*
 IS_DEBUG  1 开发布环境
           2 生产环境
          
 */

#define IS_DEBUG  2

#if IS_DEBUG==1


#elif IS_DEBUG==2

//#define URL_BASE          @"http://271dc58681.qicp.vip/shopp"

#define URL_BASE          @"http://192.168.1.43:8080/shopp"

#endif



// 接口
//登录
// 获取验证码
static NSString * const api_sendSms = @"/shop/sms/sendSms";
// 注册
static NSString * const api_register = @"/shop/account/add.do";
//登录
static NSString * const api_login = @"/shop/login.do";
//退出登录
static NSString * const api_logOut = @"/shop/logOut.do";
//修改登录密码
static NSString * const api_updatePsd = @"/shop/account/updatePsd.do";
//修改支付密码
static NSString * const api_updatePayPsd = @"/shop/account/updatePayPsd.do";
//忘记密码，发送短信接口
static NSString * const api_forgetPws1 = @"/shop/account/forgetPws1.do";
//忘记密码，修改密码接口
static NSString * const api_forgetPws2 = @"/shop/account/forgetPws2.do";
//个人中心
static NSString * const api_accountInfo = @"/shop/account/accountInfo.do";
//头像上传接口
static NSString * const api_addHeadImg = @"/shop/account/addHeadImg.do";
//用户分享注册二维码
static NSString * const api_shareQrCode = @"/shop/account/shareQrCode.do";
//我的成员
static NSString * const api_myTeam = @"/shop/account/myTeam.do";
//我的钱包
static NSString * const api_myWallet = @"/shop/account/myWallet.do";
//资金明细
static NSString * const api_myBalanceRcord = @"/shop/account/myBalanceRcord.do";
//仓单明细
static NSString * const api_myPlacesRecord = @"/shop/account/myPlacesRecord.do";
//积分明细
static NSString * const api_myIntegralRecord = @"/shop/account/myIntegralRecord.do";



//首页
//公告
static NSString * const api_notice = @"/shop/notice/list.do";

//商品列表
static NSString * const api_goodsList = @"/shop/goods/list.do";
//商品交易信息展示接口
static NSString * const api_goodsTradeInfo = @"/shop/goods/goodsTradeInfo.do";
//验证用户是否购买提货订单接口
static NSString * const api_getDistributionFlag = @"/shop/buy/getDistributionFlag.do";
//新增挂买单接口
static NSString * const api_addGoods = @"/shop/buy/add.do";
//新增挂买单接口
static NSString * const api_buylist = @"/shop/sell/buylist.do";
//新增挂卖订单
static NSString * const api_addSell = @"/shop/sell/add.do";
//当日挂单
static NSString * const api_todayOrderList = @"/shop/sell/todayOrderList.do";
//我的订单
static NSString * const api_myOrder = @"/shop/buy/myOrder.do";


//地址列表
static NSString * const api_addressList = @"/shop/address/list.do";
//添加地址
static NSString * const api_andAddress = @"/shop/address/add.do";
//设置默认地址
static NSString * const api_setAddress = @"/shop/address/setDefaultAddress.do";
//获取默认地址
static NSString * const api_getAddress = @"/shop/address/getDefaultAddress.do";
//删除地址
static NSString * const api_deleteAddress = @"/shop/address/delete.do";
//修改地址
static NSString * const api_updateAddress = @"/shop/address/update.do";

//银行选择列表
static NSString * const api_bankList = @"/shop/bankList/list.do";
//银行卡列表
static NSString * const api_bankCardList = @"/shop/bank/list.do";
//添加银行卡
static NSString * const api_andBank = @"/shop/bank/add.do";
//获取我的默认银行卡
static NSString * const api_getBank = @"/shop/bank/list.do";
//解绑银行卡
static NSString * const api_deleteBank = @"/shop/bank/delete.do";
//余额转换可用提现
static NSString * const api_balanceConverWithdraw = @"/shop/account/balanceConverWithdraw.do";
//可用提现转换余额
static NSString * const api_withdrawConverBalance = @"/shop/account/withdrawConverBalance.do";

#endif
