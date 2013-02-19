#import "SiteDTO.h"

@implementation SiteDTO
+ (SiteDTO *) fromDictionary:(NSDictionary *)dic
{
    SiteDTO *site = [[SiteDTO alloc] init];
    site.SiteID = [dic objectForKey:@"LocationID"];
    site.Name = [dic objectForKey:@"Name"];
    site.ProjectCount = [[dic objectForKey:@"ProjectCount"] integerValue];
    site.City = [dic objectForKey:@"City"];
    site.State = [dic objectForKey:@"StateCode"];
    return site;
}
@end
