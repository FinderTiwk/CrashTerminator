//
//  ScriptTaskHandler.h
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

#ifndef    xWeakify
#if __has_feature(objc_arc)
#define xWeakify autoreleasepool{} __weak __typeof__(self) weakRef = self;
#else
#define xWeakify autoreleasepool{} __block __typeof__(self) blockRef = self;
#endif
#endif

#ifndef     xStrongify
#if __has_feature(objc_arc)
#define xStrongify try{} @finally{} __strong __typeof__(weakRef) self = weakRef;
#else
#define xStrongify try{} @finally{} __typeof__(blockRef) self = blockRef;
#endif
#endif


@interface ScriptTaskHandler : NSObject

/*!
 *  @author _Finder丶Tiwk, 16-08-15 10:08:48
 *
 *  @brief 执行一个Shell脚本
 *  @param path       脚本的路径
 *  @param args       脚本参数
 *  @param executing  执行过程回调
 *  @param completion 完成回调
 *  @since v1.0.0
 */
+ (void)invokeTaskWithScriptPath:(NSString *)path
                       executing:(void (^)(NSString *output))executing
                      completion:(void (^)(BOOL success))completion;

+ (void)invokeTaskWithScriptPath:(NSString *)path
                            args:(NSArray<NSString *> *)args
                       executing:(void (^)(NSString *output))executing
                      completion:(void (^)(BOOL success))completion;


/*!
 *  @author _Finder丶Tiwk, 16-08-15 10:08:44
 *
 *  @brief 返回Shell脚本文件的路径
 *  @param scriptName Shell脚本文件名
 *  @return Shell脚本路径
 *  @since v1.0.0
 */
extern NSString *scriptPathInMainBundle(NSString *scriptName);
extern NSString *filePathInMainBundle(NSString *fileName,NSString *suffix);

@end
