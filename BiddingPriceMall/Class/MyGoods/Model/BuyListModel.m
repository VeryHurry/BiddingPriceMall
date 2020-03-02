//
//Created by ESJsonFormatForMac on 19/10/28.
//

#import "BuyListModel.h"
@implementation BuyListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [BuyModel class]};
}


@end

@implementation BuyModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


