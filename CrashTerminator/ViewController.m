//
//  ViewController.m
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

#import "ViewController.h"
#import "ViewModel.h"

@interface ViewController ()

@property (nonatomic,strong) FileItem *appItem;
@property (nonatomic,strong) FileItem *dsymItem;
@property (nonatomic,strong) FileItem *logItem;

@property (weak) IBOutlet NSTextField *appTextField;
@property (weak) IBOutlet NSTextField *dsymTextField;
@property (weak) IBOutlet NSTextField *logTextField;

@property (weak) IBOutlet NSButton *resolveButton;
@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (unsafe_unretained) IBOutlet NSTextView *terminalView;

@property (weak) IBOutlet NSButton *selectButton1;
@property (weak) IBOutlet NSButton *selectButton2;
@property (weak) IBOutlet NSButton *selectButton3;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [_terminalView setTextColor:[NSColor greenColor]];
    [_terminalView setFont:[NSFont systemFontOfSize:9 weight:2]];
}

- (void)viewDidAppear{
    [super viewDidAppear];
    
    [self startAnimation];
    _selectButton1.enabled = NO;
    _selectButton1.enabled = NO;
    
    [self appendString:@"程序初始化..."];
    @xWeakify
    [ViewModel prepareEnvironmentVariables:^(BOOL success) {
        @xStrongify
        self->_resolveButton.enabled = success;
        self->_selectButton1.enabled = success;
        self->_selectButton2.enabled = success;
        self->_selectButton3.enabled = success;
        [self->_indicator stopAnimation:self];
        if (success) {
            [self appendString:@"✅程序初始化成功"];
        }else{
            [self appendString:@"❌程序初始化失败"];
        }
    }];
}

#pragma mark - IBAction
- (IBAction)selectApp:(NSButton *)sender {
    [self handlerWithFileType:FileType_Ipa|FileType_App];
}

- (IBAction)selectDSYM:(NSButton *)sender {
    [self handlerWithFileType:FileType_DSYM];
}

- (IBAction)selectLog:(NSButton *)sender {
    [self handlerWithFileType:FileType_CrashLog];
}


- (void)handlerWithFileType:(FileType)type{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.showsHiddenFiles     = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles       = YES;
    openPanel.allowedFileTypes = fileSuffixs(type);
    
    NSWindow *mainWindow = [NSApplication sharedApplication].mainWindow;
    @xWeakify
    [openPanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result) {
        @xStrongify
        if (result == NSFileHandlingPanelOKButton) {
            [self initItemWithURL:openPanel.URL type:type];
        }
    }];
}


- (void)initItemWithURL:(NSURL *)url type:(FileType)type{
    
    if (type == (FileType_Ipa|FileType_App)) {
        if ([url.pathExtension isEqualToString:@"ipa"]) {
            type = FileType_Ipa;
        }else{
            type = FileType_App;
        }
    }
    
    if (type == FileType_Ipa || type == FileType_App) {
        @xWeakify
        _appItem = [FileItem itemWithFileURL:url type:type completion:^(NSString *displayString) {
            @xStrongify
            [self appendString:displayString];
        }];
        _appTextField.stringValue = _appItem.fileFullName;
    }
    
    else if (type == FileType_DSYM) {
        @xWeakify
        _dsymItem = [FileItem itemWithFileURL:url type:type completion:^(NSString *displayString) {
            @xStrongify
            [self appendString:displayString];
        }];
        _dsymTextField.stringValue = _dsymItem.fileFullName;
    }
    
    else if (type == FileType_CrashLog) {
        @xWeakify
        _logItem = [FileItem itemWithFileURL:url type:type completion:^(NSString *displayString) {
            @xStrongify
            [self appendString:displayString];
        }];
        _logTextField.stringValue = _logItem.fileFullName;
    }
    else{
        return;
    }
}

- (IBAction)resolveAction:(NSButton *)sender {
    
    BOOL runing = YES;
    [self startAnimation];
    if (!_appItem) {
        [self appendString:@"⚠️请选择一个Ipa或app文件"];
        runing = NO;
    }
    if (!_dsymItem) {
        [self appendString:@"⚠️请选择一个.dSYM文件"];
        runing = NO;
    }
    if (!_logItem) {
        [self appendString:@"⚠️请选择一个.crash文件"];
        runing = NO;
    }
    
    if (!runing) {
        [self stopAnimation];
        return;
    }
    
    // InvokeScript
    NSString *scriptPath = scriptPathInMainBundle(@"ResolveCrashLog");
    NSString *arg1 = [ViewModel symbolicatecrashPath];
    NSString *arg2 = self.logItem.filePath;
    NSString *arg3 = self.dsymItem.filePath;
    NSString *arg4 = [self.logItem.filePath stringByAppendingString:@".log"];
    NSArray<NSString *> *args = @[arg1,arg2,arg3,arg4];
    
    [ScriptTaskHandler invokeTaskWithScriptPath:scriptPath args:args executing:^(NSString *output) {
        [self appendString:output];
    } completion:^(BOOL success) {
        [self stopAnimation];
        if (success) {
            [self appendString:@"解析成功✅"];
        }else{
            [self appendString:@"解析失败❌"];
        }
    }];
}

- (IBAction)cleanAction:(NSButton *)sender {
    _terminalView.string = [NSString stringWithFormat:@"♻️Clean all messages...\r\n"];
}


- (void)appendString:(NSString *)aString{
    if (aString.length > 0 ) {
        
        NSString *previousString = _terminalView.string;
        NSString *context = [previousString stringByAppendingFormat:@"🌴: %@\r\n",aString];
        _terminalView.string = context;
        NSRange insertAtEnd = NSMakeRange(_terminalView.textStorage.length, 0);
        [_terminalView scrollRangeToVisible:insertAtEnd];
    }
}


- (void)startAnimation {
    _selectButton1.enabled = NO;
    _selectButton2.enabled = NO;
    _selectButton3.enabled = NO;
    _resolveButton.enabled = NO;
    [_indicator startAnimation:self];
}

- (void)stopAnimation {
    _selectButton1.enabled = YES;
    _selectButton2.enabled = YES;
    _selectButton3.enabled = YES;
    _resolveButton.enabled = YES;
    [_indicator stopAnimation:self];
}

@end
