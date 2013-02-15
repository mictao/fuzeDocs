#import <Foundation/Foundation.h>
#import "ClientDTO.h"
#import "SiteDTO.h"
#import "ProjectDTO.h"
#import "FolderDTO.h"
#import "DocumentDTO.h"

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

- (NSData *) downloadFile:(NSString *)urlString;

@end
