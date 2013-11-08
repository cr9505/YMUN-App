//
//  YMAPIInterfaceCenter.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/25/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMAPIInterfaceCenter.h"
#import "Form+CreateAndModify.h"
#import "Transaction+Create.h"

@interface YMAPIInterfaceCenter ()

@property (nonatomic) BOOL isLoggedIn;


@end

@implementation YMAPIInterfaceCenter

@synthesize isLoggedIn = _isLoggedIn;

- (BOOL)isLogin
{
    return self.isLoggedIn;
}

+ (BOOL)hasUserAccessToken
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSDictionary *)parseJSON:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *parsedDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    return parsedDict;
}

+ (void)getUserInfo
{
    NSURL *url = [NSURL URLWithString:YMUN_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObject:[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN] forKey:@"access_token"];
    [client getPath:@"Registration/api/user_info.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        NSDictionary *jsonResponse = [YMAPIInterfaceCenter parseJSON:response];
        // post a notification
        NSLog(@"%@", jsonResponse);
        [[NSNotificationCenter defaultCenter] postNotificationName:YMUNDidGetUserInfoNotification object:self userInfo:jsonResponse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning tell user there is a network error
        DLog(@"Network error!");
        [[NSNotificationCenter defaultCenter] postNotificationName:YMUNNetworkErrorNotificatoin object:self userInfo:nil];
    }];
}

+ (BOOL)validateUserInfo:(NSDictionary *)userinfo
{
    if ([userinfo objectForKey:@"error"]) {
        return NO;
    }
    return YES;
}

- (id)initWithEmail:(NSString *)email Password:(NSString *)password
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:YMUN_URL];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            email, @"user_email",
                            password, @"user_password",
                            nil];
        [client postPath:@"Registration/api/login.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // determine whether login succeded or not
            NSString *response = [operation responseString];
            NSDictionary *jsonResponse = [YMAPIInterfaceCenter parseJSON:response];
            if ([[jsonResponse objectForKey:LOGIN_STATUS] isEqualToString:@"failure"]) {
                // password or email error
                self.isLoggedIn = NO;
            } else {
                // login successful, should post an NSNotification here
                self.isLoggedIn = YES;
                [[NSUserDefaults standardUserDefaults] setObject:[jsonResponse objectForKey:ACCESS_TOKEN] forKey:ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:YMUNLoginStatusNotification object:self userInfo:jsonResponse];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning tell user there is a network error
            DLog(@"Network error!");
            [[NSNotificationCenter defaultCenter] postNotificationName:YMUNNetworkErrorNotificatoin object:self userInfo:nil];
            self.isLoggedIn = NO;
        }];
    }
    return self;
}

+ (NSString *)addressForHotel:(NSString *)name
{
    NSDictionary *address =
    @{
      @"La Quinta": @"400 Sargent Dr, New Haven, CT 06511",
      @"Omni": @"155 Temple St, New Haven, CT 06510",
      @"Other": @"NA",
      @"New Haven Hotel": @"229 George Street, New Haven, Connecticut 06510",
      @"Courtyard Marriott": @"30 Whalley Ave, New Haven, Connecticut 06511"
      };
    if ([address objectForKey:name])
        return [address objectForKey:name];
    else
        return @"NA";
}

+ (void)destroySession
{
    // remove access token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:ACCESS_TOKEN];
    [userDefaults synchronize];
    [Form deleteAll];
    [Transaction deleteAll];
}

@end
