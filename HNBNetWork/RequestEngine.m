//
//  RequestEngine.m
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import "RequestEngine.h"
#import "AFNetworking.h"
#import "NSObject+HNB.h"

@implementation RequestEngine

+ (instancetype)sharedEngine{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSURLSessionTask *)addRequest:(BaseRequest*)baseRequest
                   successBlock:(IdBlock)successBlock
                   requestFailBlock:(RequestFailBlock)failBlock{
    NSURLSessionTask *task = nil;
    task = [self sessionTaskFotRequest:baseRequest successBlock:successBlock requestFailBlock:failBlock];
    return task;
}

- (NSURLSessionTask *)sessionTaskFotRequest:(BaseRequest*)baseRequest successBlock:(IdBlock)successBlock requestFailBlock:(RequestFailBlock)failBlock{
    NSURLSessionTask *task = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseRequest.baseUrl,baseRequest.apiUrl];
    NSDictionary *params = [self assembleParams:(NSMutableDictionary*)baseRequest.keyAndVaules];
    //TODO: chengk 待优化 颜色打印
    NSString *methordStr = nil;
    switch (baseRequest.apiMethord) {
        case APIGet:
            methordStr = @"GET";
            break;
        case APIPost:
            methordStr = @"POST";
            break;
        default:
            break;
    }
    NSLog(@"request:--------------\n method:%@,url:%@,\n params:%@",methordStr,url,params);
    switch (baseRequest.apiMethord) {
        case APIGet:
        {
            task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(responseObject);
                NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                failBlock(error);
            }];
        }
            break;
        case APIPost:{
            task = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                successBlock(responseObject);
                NSLog(@"reponse:++++++++++++++\n url:%@,\n params:%@,\n responseObject:%@ ",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
                failBlock(error);
            }];
        }
            break;
        default:
            break;
            
    }
    return task;
}


- (NSDictionary *)assembleParams:(NSDictionary*)param{
//    NSString *token = @"";
//    if (param[HNBConstantToken]) {
//        if([param[HNBConstantToken] isKindOfClass:[NSString class]]){
//        
//        }
//        token = param[HNBConstantToken];
//    }
//    NSString *build = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
//    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
//    NSString *deviceSystem = [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
//    NSDictionary *requestHead = @{@"Version":version,   // APP 版本号
//                                  @"Build": build,
//                                  @"ScreenWidth":@(screenWidth),
//                                  @"ScreenHeight":@(screenHeight),
//                                  @"OSVersion": deviceSystem,
//                                  @"DeviceType": [UIDevice currentDevice].model,
//                                  @"AppType":@(2),   //2 表示iOS
//                                  @"Token":token};
//    NSDictionary *dict = @{@"Head":requestHead,
//                           @"Content":param?(param):(@{})};
    NSDictionary *dict = param;
    return dict;
}

@end
