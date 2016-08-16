//
//  FileItem.m
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

#import "FileItem.h"

@implementation FileItem{
    NSString *_fileName; /**< 文件名称*/
}

+ (instancetype)itemWithFileURL:(NSURL *)url type:(FileType)type completion:(void (^)(NSString *))completion{
    FileItem *item = [[FileItem alloc] init];
    item->_type          = type;
    item->_filePath      = url.path;
    item->_parentPath    = [url.path stringByDeletingLastPathComponent];
    item->_fileFullName  = [url.path lastPathComponent];
    item->_fileName      = [item.fileFullName stringByDeletingPathExtension];
    
    if (type == FileType_Ipa) {
        [item unzipIpaCompletion:completion];
    }else{
        [item invokeScriptCompletion:completion];
    }
    return item;
}


- (void)invokeScriptCompletion:(void (^)(NSString *))completion{
    NSArray<NSString *> *args;
    
    if (_type == FileType_Ipa || _type == FileType_App) {
        args = @[[_filePath stringByAppendingPathComponent:_fileName]];
    }else if (_type == FileType_DSYM){
        args = @[_filePath];
    }else{
        return;
    }
    NSString *scriptPath = scriptPathInMainBundle(@"Dwarfdump");
    [ScriptTaskHandler invokeTaskWithScriptPath:scriptPath args:args executing:^(NSString *output) {
        completion(output);
    } completion:NULL];
}

- (void)unzipIpaCompletion:(void (^)(NSString *))completion{
    NSString *scriptPath = scriptPathInMainBundle(@"ExtractIpa");
    NSArray<NSString *> *args;
    NSString *arg1 = _filePath;
    NSString *arg2 = _parentPath;
    NSString *arg3 = [_parentPath stringByAppendingPathComponent:@"Payload"];
    args = @[arg1,arg2,arg3];
    
    @xWeakify
    [ScriptTaskHandler invokeTaskWithScriptPath:scriptPath args:args executing:^(NSString *output) {
        @xStrongify
        self->_filePath = [arg3 stringByAppendingPathComponent:output];
        self->_fileName = [[self->_filePath lastPathComponent] stringByDeletingPathExtension];
        completion(output);
    } completion:^(BOOL success) {
        @xStrongify
        if (success) {
            [self invokeScriptCompletion:completion];
        }else{
            completion(@"❗️ipa文件解压失败");
        }
    }];
}

- (BOOL)isEqualTo:(id)object{
//TODO: 判断.app .dSYM .crash的UUID是否相同
//@property (nonatomic,readonly) NSString *uuidString;
    return NO;
}


NSArray<NSString *> *fileSuffixs(FileType type){
    NSMutableArray *suffixArray = [NSMutableArray arrayWithCapacity:2];
    if ((type & FileType_Ipa) == FileType_Ipa) {
        [suffixArray addObject:@"ipa"];
    }
    if ((type & FileType_App) == FileType_App) {
        [suffixArray addObject:@"app"];
    }
    if ((type & FileType_DSYM) == FileType_DSYM) {
        [suffixArray addObject:@"dSYM"];
    }
    if ((type & FileType_CrashLog) == FileType_CrashLog) {
        [suffixArray addObject:@"crash"];
    }
    if ((type & FileType_All) == FileType_All) {
        suffixArray = nil;
    }
    return suffixArray;
}


@end
