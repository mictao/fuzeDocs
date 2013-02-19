//
//  DocumentDTO.h
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentDTO : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *DisplaySize;
@property (nonatomic, strong) NSString *UploadedBy;
@property (nonatomic, strong) NSString *ModifiedDate;
@property (nonatomic)         BOOL     IsRead;

+ (DocumentDTO *) fromDictionary:(NSDictionary*)dic;

@end
