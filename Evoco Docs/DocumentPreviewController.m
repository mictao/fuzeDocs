//
//  DocumentPreviewController.m
//  fuze Docs
//
//  Created by Adam Clark on 2013-02-18.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "DocumentPreviewController.h"
#import "WebTopClient.h"

@interface DocumentPreviewController ()

@property (nonatomic, strong) NSString *currentPreviewFilePath;
@property (nonatomic, strong) WebTopClient *wtClient;

@end

@implementation DocumentPreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wtClient = [WebTopClient instance];
    
    if (self.dto != nil)
    {
        [self documentSelected];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) documentSelected
{
    
    NSString *downloadUrl = [NSString stringWithFormat: @"UserManagement/Application/Viewers/FileHandler.ashx?download=true&docID=%@", self.dto.ID];
    NSData *docData = [self.wtClient downloadFile:downloadUrl];
    
    self.currentPreviewFilePath = [NSString pathWithComponents: [NSArray arrayWithObjects: NSHomeDirectory(), @"Documents", self.dto.Name, nil]];
    NSLog(@"%@", self.currentPreviewFilePath);
    [docData writeToFile:self.currentPreviewFilePath atomically:NO];
    

    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    [previewController setDataSource:self];
    [previewController setDelegate:self];
    [self.navigationController pushViewController:previewController animated:NO];
    
}

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
	return [NSURL fileURLWithPath:self.currentPreviewFilePath];
}
@end
