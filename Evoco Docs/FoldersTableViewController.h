//
//  FoldersTableViewController.h
//  Evoco Docs
//
//  Created by Gabor Shaio on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebTopClient.h"


@interface FoldersTableViewController : UITableViewController

@property NSString *folderID;
@property WebTopClient *wtClient;

@end
