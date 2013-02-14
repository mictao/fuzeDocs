#import <UIKit/UIKit.h>

@interface DocsTableViewController : UITableViewController

@property NSInteger currentLevel;
@property NSString *currentSiteID;
@property NSString *currentProjectID;

@property (nonatomic,strong) NSString *docSectionTitle;

@property (nonatomic,strong) NSArray *sites;
@property (nonatomic,strong) NSArray *projects;

@end
