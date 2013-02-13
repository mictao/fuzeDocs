//
//  UserController.m
//  Storyboard
//
//  Created by Adam Clark on 2013-02-12.
//  Copyright (c) 2013 Adam Clark. All rights reserved.
//

#import "UserController.h"

@implementation UserController



- (id) init
{
    self = [super init];
    return self;
}

- (BOOL) loginToFuzeWithUsername:(NSString *)username withPassword:(NSString *)password forHost:(NSString *)urlHost
{

    BOOL success = NO;
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/Webtop/Secured/VerifyLoginHandler.ashx?username=%@&password=%@&callback=*",urlHost,username,password];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse __autoreleasing *response = nil;
    NSError __autoreleasing *error = nil;
    
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
       
    if([data length] >0 && error == nil)
    {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        json = [json substringWithRange:NSMakeRange(2,[json length] - 4)];

        json = [json stringByReplacingOccurrencesOfString:@"(\\w+):"
                     withString : @"\"$1\":"
                     options    : NSRegularExpressionSearch
                     range      : NSMakeRange(0, json.length)];
        
        json = [json stringByReplacingOccurrencesOfString:@"'" withString:@"\"" options: NSRegularExpressionSearch range: NSMakeRange(0,json.length)];
        
        
       NSLog(@"VerifyLoginRequest: [Fixed Response Data] - %@", json);
        
        NSError *jsonParsingError;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&jsonParsingError];
       
        
        if (jsonParsingError == nil)
        {
            success =  ![[response objectForKey:@"HasError"] boolValue];
        }
        else {
            success = NO;
            NSLog(@"LogonRequest: JSON Parsing Error: %@", jsonParsingError);
        }
        
    }
    else if ([data length] == 0 && error == nil)
    {
        NSLog(@"VerifyLoginRequest: Nothing was returned");
        success = NO;
        
    }
    else if (error != nil)
    {
        NSLog(@"VerifyLoginRequest: Error");
        success = NO;
    }
    
    return success;;
}



@end
