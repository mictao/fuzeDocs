//
//  FolderDTO.m
//  fuze Docs
//
//  Created by Gabor Shaio on 2013-02-14.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "FolderDTO.h"

@implementation FolderDTO
+ (FolderDTO *) fromDictionary:(NSDictionary *)dic
{
    NSDictionary *tdic = [dic objectForKey:@"TemplateFolder"];
    FolderDTO *folder = [[FolderDTO alloc] init];
    folder.ID = [dic objectForKey:@"ID"];
    folder.Name = [tdic objectForKey:@"Name"];
    folder.HasDocuments = [[dic objectForKey:@"HasDocuments"] boolValue];
    folder.SubfolderCount = [[dic objectForKey:@"SubfolderCount"] integerValue];
    return folder;
}
@end
