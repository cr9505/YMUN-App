//
//  YMAPIInterfaceCenter.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/25/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#define YMUN_URL        @"http://ymun.yira.org/"
#define PUSH_CENTER_URL @"http://ymunpushcenter.herokuapp.com/"
// define some macro for access userInfo dictionary
#define ACCESS_TOKEN    @"access_token"
#define LOGIN_STATUS    @"status"
#define USER_ID         @"user_id"
#define ADVISOR_COUNT   @"advisor_count"
#define DELEGATE_COUNT  @"delegate_count"
#define USER_NAME       @"full_name"
#define HOTEL           @"hotel"
#define PAID_DEPOSIT    @"paid_deposit"
#define PAYMENTS        @"payments"
#define PURCHASES       @"purchases"
#define PAYMENTS        @"payments"
#define AMOUNT      @"amount"
#define DATE        @"date"
#define DUEDATE     @"due"
#define NAME        @"name"
#define SCHOOL_NAME     @"school_name"
#define SUBMITTED_FORM  @"submitted_forms"
#define ID          @"id"
#define FORMS       @"forms"
#define SUBMITTED   @"submitted"
#define IS_DELEGATE @"is_delegate"

#define YMUNLoginStatusNotification @"YMUNLoginStatusNotification"
#define YMUNDidGetUserInfoNotification @"YMUNDidGetUserInfoNotification"
#define YMUNDidGetForumInfoNotification @"YMUNDidGetForumInfoNotification"
#define YMUNNetworkErrorNotificatoin @"YMUNNetworkErrorNotificatoin"
#define YMUNDidPostToForumNotification @"YMUN_DID_POST_TO_FORUM_NOTIFICATION"

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol YMAPIInterfaceCenterDelegate <NSObject>
@optional;
- (void)interfaceCenterDidGetUserInfo:(NSDictionary *)userInfo;
@end

@interface YMAPIInterfaceCenter : NSObject

@property (nonatomic, readonly, getter = isLogin) BOOL login;
@property (nonatomic, weak) id<YMAPIInterfaceCenterDelegate> delegate;
- (id)initWithEmail:(NSString *)email Password:(NSString *)password;
+ (void)getUserInfo;
+ (BOOL)validateUserInfo:(NSDictionary *)userinfo;
+ (BOOL)hasUserAccessToken;
+ (NSString *)addressForHotel:(NSString *)name;
+ (void)getForumInfo;
+ (void)getTopicsWithForumID:(NSNumber *)forumID;
+ (void)getPostsWithTopicID:(NSNumber *)topicID;
+ (void)destroySession;
+ (void)postTokenToPushCenter:(NSString *)token;
+ (BOOL)hasRegisteredOnPushCenter;
+ (void)createNewTopicWithForumID:(NSNumber *)forumID content:(NSString *)content title:(NSString *)title;
+ (void)replyToTopicWithTopicID:(NSNumber *)topicID content:(NSString *)content;

@end
