//
//  AliyunConfig.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AliyunConfig.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@implementation AliyunConfig

+ (void)setup {
    HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];
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
