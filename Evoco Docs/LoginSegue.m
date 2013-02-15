//
//  LoginSegue.m
//  fuze Docs
//
//  Created by Adam Clark on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "LoginSegue.h"

@implementation LoginSegue
- (void) perform {
    NSLog(@"Do the segue you way");
    UIViewController *src = self.sourceViewController;
    UIWindow *window = src.view.window;
    [window addSubview:[self.destinationViewController view]];
    window.rootViewController = self.destinationViewController;
}
@end