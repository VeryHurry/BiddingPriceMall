//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import "PlacesListModel.h"
@implementation PlacesListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [PlacesModel class]};
}


@end

@implementation PlacesModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


