//
//  XKCache.h
//  MVVM+RACDemo
//
//  Created by 浪漫恋星空 on 2017/9/27.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKCache : NSObject

+ (instancetype)sharedInstance;

- (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters;

- (id)httpCacheForURL:(NSString *)URL parameters:(id)parameters;

@end
