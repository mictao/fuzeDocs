//
//  FoldersTableViewController.h
//  Evoco Docs
//
//  Created by Gabor Shaio on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebTopClient.h"
#import <QuickLook/QuickLook.h>

@interface FoldersTableViewController : UITableViewController   <QLPreviewControllerDataSource,
                                                                QLPreviewControllerDelegate,
                                                                UIDocumentInteractionControllerDelegate,
                                                                UIImagePickerControllerDelegate,
                                                                UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addButtonPressed:(id)sender;


@property NSString *folderID;

@end
