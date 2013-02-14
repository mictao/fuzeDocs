#import <Foundation/Foundation.h>
#import "ClientDTO.h"
#import "FolderDTO.h"

@interface WebTopClient : NSObject

@property NSString *clientUrl;
@property NSString *umServiceUrl;
@property NSString *docsServiceUrl;


- (void) setClientUrl:(NSString *)clientUrl;

- (NSString *) login:(NSString *)user password:(NSString *)pass;
- (NSArray *) getSites;
- (NSArray *) getProjectsForSite:(NSString *)siteID;

- (FolderDTO *) getRootFolderForAssociation:(NSString *) assID;
- (NSArray *) getFolderContents:(NSString *)parentFolderID withDeleted:(BOOL)includeDeleted withEmptyFolders:(BOOL)includeEmptyFolders;

@end
