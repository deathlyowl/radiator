//
//  main.m
//  Radiator
//
//  Created by Paweł Ksieniewicz on 17.08.2012.
//  Copyright (c) 2012 Deathly Owl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
// clean the console output.

typedef int (*PYStdWriter)(void *, const char *, int);

static PYStdWriter _oldStdWrite;

int __pyStderrWrite(void *inFD, const char *buffer, int size)
{
    if ( strncmp(buffer, "AssertMacros:", 13) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}

void __iOS7B5CleanConsoleOutput(void)
{
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
}

int main(int argc, char *argv[])
{
    @autoreleasepool {
        __iOS7B5CleanConsoleOutput();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
