//
//  FoldersTableViewController.m
//  Evoco Docs
//
//  Created by Gabor Shaio on 2013-02-13.
//  Copyright (c) 2013 Evoco. All rights reserved.
//

#import "FoldersTableViewController.h"
#import "WebTopClient.h"
#import "FolderDTO.h"
#import "DocumentDTO.h"
#import "DocumentPreviewController.h"

@interface FoldersTableViewController ()

@property (nonatomic, strong) NSMutableArray *folderContents;
@property (nonatomic, strong) NSString *currentPreviewFilePath;
@property (nonatomic, strong) WebTopClient *wtClient;

@end

@implementation FoldersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	self.wtClient = [WebTopClient instance];
    if (self.folderID)
    {
		NSArray *items = [self.wtClient getFolderContents:self.folderID withDeleted:NO withEmptyFolders:YES];
        self.folderContents = [NSMutableArray arrayWithArray:items];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.folderContents)
        return self.folderContents.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (!self.folderContents)
    {
        static NSString *CellIdentifier = @"DocumentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"No document set";
        return cell;
    }
    
    
    id item = self.folderContents[indexPath.row];
    
    if ([item isKindOfClass:[FolderDTO class]])
    {
        static NSString *CellIdentifier = @"FolderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        FolderDTO *folder = (FolderDTO *)item;
        cell.textLabel.text = folder.Name;
    }
    else if ([item isKindOfClass:[DocumentDTO class]])
    {
        static NSString *CellIdentifier = @"DocumentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        DocumentDTO *doc = (DocumentDTO *)item;
        cell.textLabel.text = doc.Name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", doc.DisplaySize, doc.UploadedBy, doc.ModifiedDate];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.folderContents[indexPath.row];
    if ([item isKindOfClass:[DocumentDTO class]])
    {
		DocumentDTO *doc = (DocumentDTO *)item;
		NSString *downloadUrl = [NSString stringWithFormat: @"UserManagement/Application/Viewers/FileHandler.ashx?download=true&docID=%@", doc.ID];
		NSData *docData = [self.wtClient downloadFile:downloadUrl];
		
		self.currentPreviewFilePath = [NSString pathWithComponents: [NSArray arrayWithObjects: NSHomeDirectory(), @"Documents", doc.Name, nil]];
		NSLog(@"%@", self.currentPreviewFilePath);
		[docData writeToFile:self.currentPreviewFilePath atomically:NO];
		
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		{
			[self openQLPreviewController: [self navigationController]];
		}
		else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			[self openQLPreviewController:[[[self splitViewController] viewControllers] objectAtIndex:1]];
		}
	}
}

- (void)openQLPreviewController: (UINavigationController *) controller;
{
	// When user taps a row, create the preview controller
	QLPreviewController *previewer = [[QLPreviewController alloc] init];
	
	// Set data source
	previewer.dataSource = self;
	//[previewer setTitle:@"PDF Title"];
	
	// Which item to preview
	previewer.currentPreviewItemIndex = 0;
	
	[controller pushViewController:previewer animated:YES];
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Source Controller = %@", [segue sourceViewController]);
    //NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
    
    //FoldersTableViewController *source = segue.sourceViewController;

	
	if ([segue.identifier isEqualToString:@"DocumentView"]) {
	
		DocumentPreviewController *dest = (DocumentPreviewController *)segue.destinationViewController;
		
        // note that "sender" will be the tableView cell that was selected
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		
        dest.dto = (DocumentDTO *) self.folderContents[indexPath.row];
    }
	else if ([segue.identifier isEqualToString:@"FolderView"])
	{
		FoldersTableViewController *dest = segue.destinationViewController;
		FolderDTO *folder = self.folderContents[self.tableView.indexPathForSelectedRow.row];
		dest.folderID = folder.ID;
		dest.title = folder.Name;
	}
}






#pragma mark -
#pragma mark QLPreviewControllerDataSource

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



- (IBAction)addButtonPressed:(id)sender
{
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
		imagePicker.allowsEditing = NO;
		[self presentViewController:imagePicker	animated:YES completion:nil];
		//_newMedia = NO;
    }
	
	
	/*if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		
		imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		
		imagePicker.delegate = self;
	*/
	//	[self presentModalViewController:imagePicker animated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//NSDictionary *meta = (NSDictionary *)[info valueForKey:@"UIImagePickerControllerMediaMetadata"];
	//NSLog(@"%@", meta);
	
	
    NSData *imageData =  UIImageJPEGRepresentation(image, 0.5f);
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *now = [[NSDate alloc] init];
	NSString *theDate = [dateFormat stringFromDate:now];
	NSString *fileName = [NSString stringWithFormat:@"Photo %@.jpg", theDate];
	
	NSString *uploadUrl = [NSString stringWithFormat: @"Documents/Application/Documents/FileUpload.ashx?FolderID=%@", self.folderID];

	FileUploadDTO *uploadDTO = [self.wtClient uploadFile:uploadUrl withName:fileName fromData:imageData];
	
	if (uploadDTO.ErrorMessage.length > 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc]
								  initWithTitle:@"Upload Error"
								  message:uploadDTO.ErrorMessage
								  delegate:nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		[self.tableView beginUpdates];
		NSInteger count = self.folderContents.count;
		[self.folderContents addObject:uploadDTO.Document];
		NSIndexPath *path = [NSIndexPath indexPathForRow:count inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView endUpdates];
		
		[self dismissViewControllerAnimated:YES completion:nil];
		//dismissModalViewControllerAnimated:YES];
	}
}


@end
