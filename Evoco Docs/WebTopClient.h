#import <Foundation/Foundation.h>

@interface WebTopClient : NSObject

@property NSString *clientUrl;
@property NSString *umServiceUrl;

- (void) login:(NSString *)user password:(NSString *)pass;
- (NSArray *) getSites;
- (NSArray *) getProjectsForSite:(NSString *)siteID;

@end
