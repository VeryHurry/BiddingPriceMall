//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import <Foundation/Foundation.h>

@class CapitalModel;
@interface CapitalListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface CapitalModel : NSObject

@property (nonatomic, assign) NSInteger charge;

@property (nonatomic, assign) NSInteger channel;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) CGFloat newBalance;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger balance;

@property (nonatomic, copy) NSString *createTime;

@end

