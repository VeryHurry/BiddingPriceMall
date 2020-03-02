//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import <Foundation/Foundation.h>

@class IntegralModel;
@interface IntegralListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface IntegralModel : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger channel;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) CGFloat integral;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *createTime;

@end

