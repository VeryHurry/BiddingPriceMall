//
//Created by ESJsonFormatForMac on 19/10/23.
//

#import <Foundation/Foundation.h>

@class BankModel;
@interface BankListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface BankModel : NSObject

@property (nonatomic, assign) NSInteger accountId;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *usreName;

@property (nonatomic, copy) NSString *bankAccount;

@property (nonatomic, copy) NSString *bankAddress;

@property (nonatomic, assign) NSInteger defaultBank;

@end

