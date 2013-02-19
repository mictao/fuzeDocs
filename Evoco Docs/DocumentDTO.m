//
//  DocumentDTO.m
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "DocumentDTO.h"

@implementation DocumentDTO

+ (DocumentDTO *) fromDictionary:(NSDictionary*)dic
{
    DocumentDTO *doc = [[DocumentDTO alloc] init];
    doc.ID = [dic objectForKey:@"ID"];
    doc.Name = [dic objectForKey:@"Name"];
    doc.DisplaySize = [dic objectForKey:@"DisplaySize"];
    doc.UploadedBy = [dic objectForKey:@"UploadedBy"];
    doc.ModifiedDate = [dic objectForKey:@"ModifiedDate"];
    doc.IsRead = [[dic objectForKey:@"IsRead"] boolValue];
    return doc;
}

@end
