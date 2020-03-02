//
//Created by ESJsonFormatForMac on 19/10/29.
//

#import "OrderListModel.h"
@implementation OrderListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [OrderModel class]};
}


@end

@implementation OrderModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


