//
//  AliyunConfig.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AliyunConfig.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface AliyunConfig(HttpDNSDegradationDelegate) <HttpDNSDegradationDelegate>

@end

@implementation AliyunConfig

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AliyunConfig *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (void)setup {
    HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];
//    [httpdns setDelegateForDegradationFilter:AliyunConfig.sharedInstance];
#if DEBUG
    [httpdns setLogEnabled:YES];
#endif
    [httpdns setExpiredIPEnabled:YES];
    [httpdns setPreResolveHosts:@[
        @"redrock.cqupt.edu.cn"
    ]];
}

+ (NSString *)ipByHost:(NSString *)host {
    HttpDnsService *httpdns = HttpDnsService.sharedInstance;
    NSString *res = [httpdns getIpByHostAsyncInURLFormat:host];
    return res;
}

@end

@implementation AliyunConfig(HttpDNSDegradationDelegate)

- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    return YES;
}

@end
