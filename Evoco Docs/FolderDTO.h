//
//  FolderDTO.h
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FolderDTO : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic)         BOOL HasDocuments;
@property (nonatomic)         NSInteger SubfolderCount;
+ (FolderDTO *) fromDictionary:(NSDictionary *)dic;
@end
