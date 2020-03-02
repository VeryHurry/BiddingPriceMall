//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import "IntegralListModel.h"
@implementation IntegralListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [IntegralModel class]};
}


@end

@implementation IntegralModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


