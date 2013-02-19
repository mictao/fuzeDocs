//
//  FileUploadDTO.h
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-18.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentDTO.h"

@interface FileUploadDTO : NSObject
@property (nonatomic, strong) NSString *SuccessMessage;
@property (nonatomic, strong) NSString *ErrorMessage;
@property (nonatomic, strong) DocumentDTO *Document;
@property (nonatomic, strong) NSString *TempID;
@end
