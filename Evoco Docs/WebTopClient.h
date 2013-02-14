#import <Foundation/Foundation.h>
#import "ClientDTO.h"
#import "FolderDTO.h"

@interface WebTopClient : NSObject

@property NSString *clientUrl;
@property NSString *umServiceUrl;
@property NSString *docsServiceUrl;

- (NSString *) login:(NSString *)user password:(NSString *)pass;

- (void) setClientUrl:(NSString *)clientUrl;

- (ClientDTO *) getCurrentClient;
- (NSArray *) getSites;
- (NSArray *) getProjectsForSite:(NSString *)siteID;

- (FolderDTO *) getRootFolderForAssociation:(NSString *) assID;
- (NSArray *) getFolderContents:(NSString *)parentFolderID withDeleted:(BOOL)includeDeleted withEmptyFolders:(BOOL)includeEmptyFolders;

@end
