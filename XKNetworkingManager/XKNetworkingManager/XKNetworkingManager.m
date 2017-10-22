//
//  XKNetworkingManager.m
//  MVVM+RACDemo
//
//  Created by 浪漫恋星空 on 2017/9/27.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import "XKNetworkingManager.h"

static AFHTTPSessionManager *_sessionManager;

@implementation XKNetworkingManager

+ (void)initialize {
    
    _sessionManager = [AFHTTPSessionManager manager];
    
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    
    response.removesKeysWithNullValues = YES;
    
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    _sessionManager.responseSerializer = response;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
 
+ (RACSignal *)GET:(NSString *)url parameters:(id)parameters isCache:(BOOL)isCache {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        isCache ? [subscriber sendNext:[[XKCache sharedInstance] httpCacheForURL:url parameters:parameters]] : nil;
        
        NSURLSessionDataTask *task = [_sessionManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
#if DEBUG
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"请求(地址:%@参数:%@)---%@", url, parameters,  [self jsonStringWithObject:responseObject]);
            });
#endif
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
            isCache ? [[XKCache sharedInstance] setHttpCache:responseObject URL:url parameters:parameters] : nil;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
#if DEBUG
            NSLog(@"请求(地址:%@参数:%@)%@", url, parameters, error);
#endif
            
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
           
            [task cancel];
        }];
    }];
    
    return signal;
}

+ (RACSignal *)POST:(NSString *)url parameters:(id)parameters isCache:(BOOL)isCache {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        isCache ? [subscriber sendNext:[[XKCache sharedInstance] httpCacheForURL:url parameters:parameters]] : nil;
        
        NSURLSessionDataTask *task = [_sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
#if DEBUG
            dispatch_async(dispatch_get_main_queue(), ^{
               
                NSLog(@"请求(地址:%@参数:%@)---%@", url, parameters,  [self jsonStringWithObject:responseObject]);
            });
#endif
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
            isCache ? [[XKCache sharedInstance] setHttpCache:responseObject URL:url parameters:parameters] : nil;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
#if DEBUG
            NSLog(@"请求(地址:%@参数:%@)%@", url, parameters, error);
#endif
            
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
    
    return signal;
}

+ (RACSignal *)uploadWithURL:(NSString *)url parameters:(id)parameters files:(NSMutableArray <XKUploadModel *>*)files {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSURLSessionDataTask *task = [_sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (XKUploadModel *model in files) {
                
                [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            [subscriber sendNext:uploadProgress];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
#if DEBUG
            NSLog(@"请求(地址:%@参数:%@)%@", url, parameters, error);
#endif
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
           
            [task cancel];
            
        }];
    }];
    
    return signal;
}

#pragma mark -- 私有方法 在DEBUG模式下将请求结果转换成json字符串打印出来 方便后续创建模型

+ (NSString *)jsonStringWithObject:(id)jsonObject {
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if ([jsonString length] > 0 && error == nil) {
        
        return jsonString;
        
    } else {
        
        return nil;
    }
}

@end
