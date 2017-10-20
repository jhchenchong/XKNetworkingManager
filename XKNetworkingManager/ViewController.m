//
//  ViewController.m
//  XKNetworkingManager
//
//  Created by 浪漫恋星空 on 2017/9/28.
//  Copyright © 2017年 浪漫恋星空. All rights reserved.
//

#import "ViewController.h"
#import "XKNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[XKNetworkingManager GET:@"http://product.toommi.com/aisport/public/user/personal/getcompanyinfo" parameters:nil isCache:YES] subscribeNext:^(id  _Nullable x) {
        
        // 如果选择了缓存  这个订阅信号的block会走两次  第一次返回的是缓存数据  第二次返回的是请求成功的数据
        
    } error:^(NSError * _Nullable error) {
        
        // 错误的回调
        
    } completed:^{
       
        // 订阅完成的回调
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
