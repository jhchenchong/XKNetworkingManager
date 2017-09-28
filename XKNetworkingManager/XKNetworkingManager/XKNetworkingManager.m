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
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
            isCache ? [[XKCache sharedInstance] setHttpCache:responseObject URL:url parameters:parameters] : nil;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
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
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
            isCache ? [[XKCache sharedInstance] setHttpCache:responseObject URL:url parameters:parameters] : nil;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
    
    return signal;
}

+ (RACSignal *)uploadWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters files:(NSMutableArray <XKUploadModel *>*)files {
    
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
           
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
           
            [task cancel];
            
        }];
    }];
    
    return signal;
}

@end
