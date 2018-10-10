//
//  CommonDefine.h
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)
#define HEXCOLOR(hex)   RGB((float)((hex & 0xFF0000) >> 16), (float)((hex & 0xFF00) >> 8), (float)(hex & 0xFF))

// 获取Size中的较大值
#define MAX_LENGTH(size) (size.width > size.height ? size.width : size.height)

// 判断当前设备是否是刘海屏，不只是iPhone X
#define iPhoneX ((NSInteger)MAX_LENGTH([UIScreen mainScreen].bounds.size) >= 812)

// 判断当前设备是否是竖屏
#define isDevicePortrait ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)

#define kNaviBarHeight (iPhoneX ? (isDevicePortrait ? 88.f : 32.f) : (isDevicePortrait ? 64.f : 32.f))

#endif /* CommonDefine_h */
