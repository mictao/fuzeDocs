//
//  DocumentPreviewController.h
//  fuze Docs
//
//  Created by Adam Clark on 2013-02-18.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "DocumentDTO.h"

@interface DocumentPreviewController : UIViewController <QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) DocumentDTO *dto;


@end
