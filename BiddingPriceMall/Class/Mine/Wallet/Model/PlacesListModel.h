//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import <Foundation/Foundation.h>

@class PlacesModel;
@interface PlacesListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface PlacesModel : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger dynamic;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) NSInteger placesChannel;

@property (nonatomic, assign) NSInteger statically;

@property (nonatomic, copy) NSString *ticketNumber;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *createTime;

@end

