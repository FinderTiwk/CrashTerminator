//
//  FileItem.h
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
#import "ScriptTaskHandler.h"

/*! 文件类型*/
typedef NS_OPTIONS(NSUInteger,FileType){
    /*! .ipa文件*/
    FileType_Ipa      = 1<<0,
    /*! .app文件*/
    FileType_App      = 1<<1,
    /*! .dSYM文件*/
    FileType_DSYM     = 1<<2,
    /*! .crash文件*/
    FileType_CrashLog = 1<<3,
    /*! 所有文件*/
    FileType_All      = 1<<7,
};


@interface FileItem : NSObject
/*! 文件类型*/
@property (nonatomic,readonly) FileType type;
/*! 文件绝对路径*/
@property (nonatomic,readonly) NSString *filePath;
/*! 文件父路径*/
@property (nonatomic,readonly) NSString *parentPath;
/*! 文件全名*/
@property (nonatomic,readonly) NSString *fileFullName;

/*!
 *  @author _Finder丶Tiwk, 16-08-16 13:08:37
 *
 *  @brief 构造方法
 *  @param url        文件URL
 *  @param type       文件类型
 *  @param completion 初始化完成回调
 *  @return FileItem实例对象
 *  @since v1.0.0
 */
+ (instancetype)itemWithFileURL:(NSURL *)url
                           type:(FileType)type
                     completion:(void (^)(NSString *displayString))completion;

/*!
 *  @author _Finder丶Tiwk, 16-08-15 14:08:44
 *
 *  @brief 根据文件类型,返回文件后缀
 *  @param type 文件类型
 *  @return 文件后缀数组
 *  @since v1.0.0
 */
extern NSArray<NSString *> *fileSuffixs(FileType type);

@end
