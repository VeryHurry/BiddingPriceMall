//
//Created by ESJsonFormatForMac on 19/10/10.
//

#import <Foundation/Foundation.h>

@class GoodsModel;
@interface NoticeListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface NoticeModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *operatorName;

@property (nonatomic, copy) NSString *file;

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger operatorId;

@end

