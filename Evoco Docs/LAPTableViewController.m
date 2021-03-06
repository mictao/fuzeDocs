#import "LAPTableViewController.h"
#import "FoldersTableViewController.h"
#import "WebTopClient.h"
#import "ClientDTO.h"
#import "SiteDTO.h"
#import "ProjectDTO.h"

@interface LAPTableViewController ()
@property (nonatomic, strong) WebTopClient *wtClient;
@end

@implementation LAPTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.wtClient = [WebTopClient instance];
    
    switch (self.currentLevel) {
        case 0:
        {
            self.sites = [self.wtClient getSites];
            break;
        }
        case 1:
        {
            self.projects = [self.wtClient getProjectsForSite:self.currentSiteID];
            break;
        }
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear level:%d", self.currentLevel);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![tableView isEqual:self.tableView])
        return 0;
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (![tableView isEqual:self.tableView])
        return 0;
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            switch (self.currentLevel) {
                case 0:
                    return self.sites.count;
                case 1:
                    return self.projects.count;
            }
        default:
            return 0;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![tableView isEqual:self.tableView])
        return nil;

    self.title = self.docSectionTitle;
    
    switch (section)
    {
        case 0:
            switch (self.currentLevel) {
                case 0:
                    return self.wtClient.clientUrl; // @"Home";
                case 1:
                    return self.docSectionTitle;
            }
            break;
        case 1:
            
            switch (self.currentLevel)
            {
                case 0:
                    return @"Sites";
                case 1:
                    return @"Project Documents";
            }
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![tableView isEqual:self.tableView])
        return nil;
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            
            switch (self.currentLevel) {
                case 0:
                    cell = [self createNewCell:@"DocCell"];
                    cell.textLabel.text = @"Home Documents";
                    break;
                case 1:
                    cell = [self createNewCell:@"DocCell"];
                    cell.textLabel.text = @"Site Documents";
                    break;
            }
            break;
        case 1:
            switch (self.currentLevel) {
                case 0:
                {
                    cell = [self createNewCell:@"LAPCell"];
                    SiteDTO *site = self.sites[indexPath.row];
                    cell.textLabel.text = site.Name;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", site.City, site.State ] ;
                    break;
                }
                case 1:
                {
                    cell = [self createNewCell:@"DocCell"];
                    ProjectDTO *project = self.projects[indexPath.row];
                    cell.textLabel.text = project.Name;
                    break;
                }
            }
            
            
            
    }
    
    
    return cell;
}


- (UITableViewCell *) createNewCell:(NSString *)cellID
{
    UITableViewCell *cell = nil;
    

    
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:10.0];
        //cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return cell;

}





- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Source Controller = %@", [segue sourceViewController]);
    NSLog(@"Destination Controller = %@", [segue destinationViewController]);
    NSLog(@"Segue Identifier = %@", [segue identifier]);
    
    if ([segue.identifier isEqualToString:@"LAPSegue"])
    {
        LAPTableViewController *source = segue.sourceViewController;
        LAPTableViewController *dest = segue.destinationViewController;
                
        dest.currentLevel = source.currentLevel + 1;
        SiteDTO *site = self.sites[self.tableView.indexPathForSelectedRow.row];
        dest.docSectionTitle = site.Name;
        dest.currentSiteID = site.SiteID;
    }
    else if ([segue.identifier isEqualToString:@"DocSegue"])
    {
        LAPTableViewController *source = segue.sourceViewController;
        FoldersTableViewController *dest = segue.destinationViewController;
        
        
        NSString *assID;
        switch (source.currentLevel)
        {
            case 0:
            {
                ClientDTO *client = [self.wtClient getCurrentClient];
                assID = client.ClientID;
                dest.title = client.Name;
                break;
            }
            case 1:
            {
                if (self.tableView.indexPathForSelectedRow.section == 0)
                {
                    assID = source.currentSiteID;
                    dest.title = self.docSectionTitle;
                }
                else
                {
                    ProjectDTO *project = self.projects[self.tableView.indexPathForSelectedRow.row];
                    assID = project.ProjectID;
                    dest.title = project.Name;
                }
                break;
            }
        }
        
        
       
        FolderDTO *folder = [self.wtClient getRootFolderForAssociation:assID];
        if (folder)
        {
            dest.folderID = folder.ID;
        }
    }
}




@end
