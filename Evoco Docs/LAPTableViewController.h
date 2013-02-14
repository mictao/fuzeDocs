#import <UIKit/UIKit.h>
#import "WebTopClient.h"

@interface LAPTableViewController : UITableViewController

@property NSInteger currentLevel;
@property NSString *currentSiteID;
@property NSString *currentProjectID;

@property NSString *clientUrl;

@property (nonatomic,strong) NSString *docSectionTitle;

@property (nonatomic,strong) NSArray *sites;
@property (nonatomic,strong) NSArray *projects;

- (void) setWebTopClient:(WebTopClient*)client;

@end
