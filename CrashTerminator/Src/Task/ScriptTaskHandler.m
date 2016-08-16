//
//  ScriptTaskHandler.m
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

#import "ScriptTaskHandler.h"

@implementation ScriptTaskHandler

+ (void)invokeTaskWithScriptPath:(NSString *)path
                       executing:(void (^)(NSString *))executing
                      completion:(void (^)(BOOL))completion{
    [self invokeTaskWithScriptPath:path args:nil executing:executing completion:completion];
}

+ (void)invokeTaskWithScriptPath:(NSString *)path
                            args:(NSArray<NSString *> *)args
                       executing:(void (^)(NSString *))executing
                      completion:(void (^)(BOOL))completion{
    
    NSCParameterAssert(path);
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    if (args) {
        task.arguments  = args;
    }
    
    NSPipe *outputPipe = [[NSPipe alloc] init];
    task.standardOutput = outputPipe;
    
    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outputPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *data = outputPipe.fileHandleForReading.availableData;
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (output.length>0) {
            executing([output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        }else{
            if (![task isRunning] && completion) {
                BOOL success = ([task terminationStatus]==0);
                completion(success);
            }
            return;
        }
        [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [task launch];
    });
    [task waitUntilExit];
}


NSString *scriptPathInMainBundle(NSString *scriptName){
    return filePathInMainBundle(scriptName, @"sh");
}

NSString *filePathInMainBundle(NSString *fileName,NSString *suffix){
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:fileName ofType:suffix];
    return scriptPath;
}

@end

