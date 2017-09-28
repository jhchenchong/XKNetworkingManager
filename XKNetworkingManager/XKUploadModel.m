//
//  XKUploadModel.m
//  MVVM+RACDemo
//
//  Created by 浪漫恋星空 on 2017/9/28.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import "XKUploadModel.h"

@implementation XKUploadModel

+ (instancetype)modelWithfileData:(NSData *)fileData
                                  name:(NSString *)name
                              fileName:(NSString *)fileName
                              mimeType:(NSString *)mimeType {
    
    return [[self alloc] initWithfileData:fileData
                                     name:name
                                 fileName:fileName
                                 mimeType:mimeType];
}

- (instancetype)initWithfileData:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        mimeType:(NSString *)mimeType {
    
    if (self = [super init]) {
        
        _fileData = fileData;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end
