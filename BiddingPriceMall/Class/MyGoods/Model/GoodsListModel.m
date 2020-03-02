//
//Created by ESJsonFormatForMac on 19/10/11.
//

#import "GoodsListModel.h"
@implementation GoodsListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [Rows class]};
}


@end

@implementation Rows


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


