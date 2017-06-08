//
//  ViewModel.m
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

#import "ViewModel.h"

static NSString *const kSymbolicateCrashPathKey = @"kSymbolicateCrashPathKey";

@implementation ViewModel

// Mac OS开发过程中 UserDefault和SandBox的路径
// UserDefault
//      ~/Library/Preferences/*
//      ~/Library/SyncedPreferences/*
// SandBox
//      ~/Library/Containers/com.example.myapp/Data/Library/Preferences/*
//      ~/Library/Containers/com.example.myapp/Data/Library/SyncedPreferences/

+ (NSString *)symbolicatecrashPath{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *path = [userDefault valueForKey:kSymbolicateCrashPathKey];
    return [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (void)prepareEnvironmentVariables:(void (^)(BOOL success))completion{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *version = [userDefault valueForKey:@"version"];
    if (!version) {
        [userDefault removeObjectForKey:@"kSymbolicateCrashPathKey"];
        [userDefault setValue:@(1.1) forKey:@"version"];
    }else{
        NSString *str = [userDefault valueForKey:kSymbolicateCrashPathKey];
        if (str && str.length >0) {
            completion(YES);
            return;
        }
    }
    NSString *scriptPath = scriptPathInMainBundle(@"PrepareEnvironmentVariables");
    [ScriptTaskHandler invokeTaskWithScriptPath:scriptPath executing:^(NSString *output) {
        [userDefault setValue:output forKey:kSymbolicateCrashPathKey];
        [userDefault synchronize];
    } completion:^(BOOL success) {
        completion(success);
    }];
}



@end
