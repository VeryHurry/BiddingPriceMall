//
//  BaseModel.h
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(id) initWithDictionary:(NSDictionary*) jsonObject;

+ (id) modelWithDictionary:(NSDictionary *)dict;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
