//
//  ViewModel.h
//  CrashTerminator
//
//   _____ _           _          _____ _          _
//  |  ___(_)_ __   __| | ___ _ _|_   _(_)_      _| | __
//  | |_  | | '_ \ / _` |/ _ \ '__|| | | \ \ /\ / / |/ /
//  |  _| | | | | | (_| |  __/ |   | | | |\ V  V /|   <
//  |_|   |_|_| |_|\__,_|\___|_|   |_| |_| \_/\_/ |_|\_\
//
//  Created by _Finder丶Tiwk on 16/8/16.
//  Copyright © 2016年 _Finder丶Tiwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileItem.h"

@interface ViewModel : NSObject

/*! symbolicatecrash文件在系统中的路径*/
+ (NSString *)symbolicatecrashPath;

/*! 设置程序环境变量*/
+ (void)prepareEnvironmentVariables:(void (^)(BOOL success))completion;

@end
