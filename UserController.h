//
//  UserController.h
//  Storyboard
//
//  Created by Adam Clark on 2013-02-12.
//  Copyright (c) 2013 Adam Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserController : NSObject

- (BOOL)loginToFuzeWithUsername:(NSString *)username withPassword:(NSString *)password forHost:(NSString *) urlHost;

@end
