//
//  FolderDTO.h
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FolderDTO : NSObject
@property NSString *ID;
@property NSString *Name;
@property BOOL HasDocuments;
@property NSInteger SubfolderCount;
@end
