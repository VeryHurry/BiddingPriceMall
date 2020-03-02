//
//Created by ESJsonFormatForMac on 19/10/09.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSString *ID;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger isLively;

@property (nonatomic, assign) CGFloat balance;

@property (nonatomic, assign) CGFloat enableBalance;

@property (nonatomic, assign) CGFloat freezeBalance;

@property (nonatomic, copy) NSString *idcard;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) CGFloat placesNum;

@property (nonatomic, assign) CGFloat integral;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger holdNum;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, copy) NSString *parentMobile;

@property (nonatomic, copy) NSString *parentId;

@end
