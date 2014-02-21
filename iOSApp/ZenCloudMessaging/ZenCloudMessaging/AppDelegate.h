//
//  AppDelegate.h
//  ZenCloudMessaging
//
//  Created by Jason Mimick on 2/20/14.
//  Copyright (c) 2014 Jason Mimick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSData *deviceId;
    NSDictionary *last_notificationUserInfo;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSData *deviceId;
@property (nonatomic, retain) NSDictionary *last_notificationUserInfo;

@end
