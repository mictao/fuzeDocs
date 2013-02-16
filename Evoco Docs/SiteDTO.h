#import <Foundation/Foundation.h>

@interface SiteDTO : NSObject
@property (nonatomic, strong) NSString  *SiteID;
@property (nonatomic, strong) NSString  *Name;
@property (nonatomic)         NSInteger ProjectCount;
@property (nonatomic, strong) NSString  *City;
@property (nonatomic, strong) NSString  *State;
@end
