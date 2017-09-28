//
//  XKCache.m
//  MVVM+RACDemo
//
//  Created by 浪漫恋星空 on 2017/9/27.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import "XKCache.h"
#import <YYCache/YYCache.h>

static NSString *const kXKCacheName = @"XKCacheName";

@interface XKCache ()

@property (nonatomic, strong)  YYCache *cache;

@end

@implementation XKCache

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    static XKCache *instance = nil;
    
    dispatch_once(&onceToken,^{
        
        instance = [[XKCache alloc] init];
    });
    
    return instance;
}

- (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters {
    
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];

    [self.cache setObject:httpData forKey:cacheKey withBlock:nil];

}

- (id)httpCacheForURL:(NSString *)URL parameters:(id)parameters {
    
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    
    return [self.cache objectForKey:cacheKey];
}

- (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    
    if(!parameters || parameters.count == 0) {
        
        return URL;
    };
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    
    return [NSString stringWithFormat:@"%ld",cacheKey.hash];
}

- (YYCache *)cache {
    
    if (!_cache) {
        
        _cache = [YYCache cacheWithName:kXKCacheName];
    }
    return _cache;
}

@end
