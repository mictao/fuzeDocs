#import <Foundation/Foundation.h>
#import "ClientDTO.h"
#import "SiteDTO.h"
#import "ProjectDTO.h"
#import "FolderDTO.h"
#import "DocumentDTO.h"
#import "FileUploadDTO.h"



@interface WebTopClient : NSObject

@property (nonatomic, strong) NSString *clientUrl;

+ (WebTopClient *)instance;


- (NSString *) login:(NSString *)user password:(NSString *)pass;

- (ClientDTO *) getCurrentClient;
- (NSArray *) getSites;
- (NSArray *) getProjectsForSite:(NSString *)siteID;

- (FolderDTO *) getRootFolderForAssociation:(NSString *) assID;
- (NSArray *) getFolderContents:(NSString *)parentFolderID withDeleted:(BOOL)includeDeleted withEmptyFolders:(BOOL)includeEmptyFolders;

- (NSData *) downloadFile:(NSString *)urlString;
- (FileUploadDTO *) uploadFile:(NSString *)urlString withName:(NSString *)fileName fromData:(NSData *)fileData;

@end
