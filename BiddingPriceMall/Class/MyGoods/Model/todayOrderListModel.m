//
//Created by ESJsonFormatForMac on 19/10/30.
//

#import "todayOrderListModel.h"
@implementation todayOrderListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [Data1 class], @"rows" : [Data2 class]};
}


@end

@implementation Data1


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation Data2


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


