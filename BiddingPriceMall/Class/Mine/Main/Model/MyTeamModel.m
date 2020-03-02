//
//Created by ESJsonFormatForMac on 19/10/23.
//

#import "MyTeamModel.h"
@implementation MyTeamModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [TeamModel class]};
}


@end

@implementation TeamModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


