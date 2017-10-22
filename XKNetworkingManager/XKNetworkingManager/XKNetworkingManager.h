//
//  XKNetworkingManager.h
//  MVVM+RACDemo
//
//  Created by 浪漫恋星空 on 2017/9/27.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "XKCache.h"
#import "XKUploadModel.h"

typedef void(^XKHttpRequestCache)(id responseCache);

@interface XKNetworkingManager : NSObject

+ (RACSignal *)GET:(NSString *)url parameters:(id)parameters isCache:(BOOL)isCache;

+ (RACSignal *)POST:(NSString *)url parameters:(id)parameters isCache:(BOOL)isCache;

+ (RACSignal *)uploadWithURL:(NSString *)url parameters:(id)parameters files:(NSMutableArray <XKUploadModel *>*)files;

@end
