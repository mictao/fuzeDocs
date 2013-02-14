#import "WebTopClient.h"
#import "SiteDTO.h"
#import "ProjectDTO.h"

@implementation WebTopClient

- (id)init
{
    //self.clientUrl = @"http://docs.preview.myevoco.com/";
    self.umServiceUrl = @"UserManagement/Services/UserServices.svc";
    
    return [super init];
}

- (void) login:(NSString *)user password:(NSString *)pass
{
    NSString *urlString = [self.clientUrl stringByAppendingFormat: @"WebTop/Secured/VerifyLoginHandler.ashx?username=%@&password=%@&callback=*", user, pass];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *resp;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    
    if (data.length > 0 && error == nil)
    {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        json = [self fixLoginResultJSON:json];
        //NSLog(@"%@", json);

        data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //NSLog(@"Error: %@", error);
        NSLog(@"JSON: %@", dic);

        NSInteger hasError = [[dic objectForKey:@"HasError"] integerValue];

        if (hasError)
        {
            NSString *errorCode = [dic objectForKey:@"ErrorCode"];
            NSString *errorMessage = [dic objectForKey:@"ErrorMessage"];
            NSLog(@"LoginResponse Error Code:%@, Message:%@", errorCode, errorMessage);
        }
        else
        {
            NSString *authCookieValue = [dic objectForKey:@"AuthCookie"];
            [self setAuthCookie:authCookieValue];
        }
    }
    else if (error != nil)
    {
        NSLog(@"Error: %@", error);
    }

}


- (void) setAuthCookie:(NSString *)authCookieValue
{
    NSArray *arr = [authCookieValue componentsSeparatedByString:@";"];
    
    NSArray *cookieArr = [arr[0] componentsSeparatedByString:@"="];
    NSString *cookieKey = cookieArr[0];
    NSString *cookieVal = cookieArr[1];
    
    NSArray *pathArr = [arr[1] componentsSeparatedByString:@"="];
    NSString *pathVal = pathArr[1];
    
    NSDictionary *cookieDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.clientUrl, NSHTTPCookieDomain,
                               cookieKey, NSHTTPCookieName,
                               pathVal, NSHTTPCookiePath,
                               cookieVal, NSHTTPCookieValue,
                               nil];
    
    // Create a new cookie
    NSHTTPCookie *newCookie = [NSHTTPCookie cookieWithProperties:cookieDic];
    
    // Add the new cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:newCookie];

}


- (NSString *) fixLoginResultJSON:(NSString *)json
{
    NSString *result = [json substringWithRange:NSMakeRange(2, json.length - 4)];
    //NSLog(@"%@", result);
    result = [result stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:" withString:@"\"$1\":" options:NSRegularExpressionSearch range:NSMakeRange(0, result.length)];
    result = [result stringByReplacingOccurrencesOfString:@"'" withString : @"\"" options:NSRegularExpressionSearch range:NSMakeRange(0, result.length)];
    //NSLog(@"%@", result);
    return result;
}


- (NSDictionary *) makeServiceCall:(NSString *)serviceFunction withArgs:(NSDictionary *)args
{
    NSString *urlString = [self.clientUrl stringByAppendingFormat: @"%@/%@", self.umServiceUrl, serviceFunction];
    NSError *error = nil;
    NSData *reqData = [NSJSONSerialization dataWithJSONObject:args options:kNilOptions error:&error];
    NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%d", reqData.length];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [NSMutableURLRequest  requestWithURL:url];
    req.timeoutInterval = 30.0f;
    req.HTTPMethod = @"POST";
    req.HTTPBody = reqData;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [req setAllHTTPHeaderFields:headers];
    
    NSURLResponse *resp;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    
    if (data.length > 0 && error == nil)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Error: %@", error);
        //NSLog(@"JSON: %@", dic);
        
        NSDictionary *dic2 = [dic objectForKey:@"d"];
        return dic2;
        
    }
    else if (error != nil)
    {
        NSLog(@"Error: %@", error);
    }
    return nil;
    
}


- (NSArray *) getSites
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys: @"", @"searchText", nil];
    NSDictionary *dic = [self makeServiceCall:@"GetLocationsQuick" withArgs:args];
        
    NSArray *arr = [dic objectForKey:@"List"];

    NSMutableArray *sites = [[NSMutableArray alloc] init];
    for (NSDictionary *d in arr)
    {
        SiteDTO *site = [[SiteDTO alloc] init];
        site.SiteID = [d objectForKey:@"LocationID"];
        site.Name = [d objectForKey:@"Name"];
        site.ProjectCount = [[d objectForKey:@"ProjectCount"] integerValue];
        site.City = [d objectForKey:@"City"];
        site.State = [d objectForKey:@"StateCode"];
        [sites addObject:site];
    }
    NSLog(@"sites: %@", sites);
    return sites;
}


- (NSArray *) getProjectsForSite:(NSString *)siteID
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys: siteID, @"locationID", nil];
    NSDictionary *dic = [self makeServiceCall:@"GetProjectsForLocation" withArgs:args];
    
    NSArray *arr = [dic objectForKey:@"List"];
    
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    for (NSDictionary *d in arr)
    {
        ProjectDTO *project = [[ProjectDTO alloc] init];
        project.ProjectID = [d objectForKey:@"ProjectID"];
        project.Name = [d objectForKey:@"Name"];
        [projects addObject:project];
    }
    NSLog(@"projects: %@", projects);
    return projects;
}







/*
- (void) login:(NSString *)user password:(NSString *)pass
{
    NSString *urlString = [self.clientUrl stringByAppendingFormat: @"WebTop/Secured/VerifyLoginHandler.ashx?username=%@&password=%@&callback=*", user, pass];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data.length > 0 && error == nil)
         {
             NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             json = [self fixLoginResultJSON:json];
             //NSLog(@"%@", json);
             
             data = [json dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             //NSLog(@"Error: %@", error);
             NSLog(@"JSON: %@", dic);
             
             NSInteger hasError = [[dic objectForKey:@"HasError"] integerValue];
             
             if (hasError)
             {
                 NSString *errorCode = [dic objectForKey:@"ErrorCode"];
                 NSString *errorMessage = [dic objectForKey:@"ErrorMessage"];
                 NSLog(@"LoginResponse Error Code:%@, Message:%@", errorCode, errorMessage);
             }
             else
             {
                 NSString *authCookieValue = [dic objectForKey:@"AuthCookie"];
                 [self setAuthCookie:authCookieValue];
                 
                 [self getSites];
             }
             
             
         }
         else if (error != nil)
         {
             NSLog(@"Error: %@", error);
         }
     }];
    
    
}
*/














/*
 
 - (void) getSites
 {
 
 NSString *urlString = [self.clientUrl stringByAppendingFormat: @"%@/GetLocationsQuick", self.umServiceUrl];
 
 NSDictionary *reqDic = [NSDictionary dictionaryWithObjectsAndKeys: @"", @"searchText", nil];
 NSError *error;
 NSData *reqData = [NSJSONSerialization dataWithJSONObject:reqDic options:kNilOptions error:&error];
 NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%d", reqData.length];
 
 NSURL *url = [NSURL URLWithString:urlString];
 NSMutableURLRequest *req = [NSMutableURLRequest  requestWithURL:url];
 req.timeoutInterval = 30.0f;
 req.HTTPMethod = @"POST";
 req.HTTPBody = reqData;
 [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [req setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
 
 
 NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
 NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
 [req setAllHTTPHeaderFields:headers];
 
 
 NSOperationQueue *queue = [[NSOperationQueue alloc]init];
 
 
 [NSURLConnection
 sendAsynchronousRequest:req
 queue:queue
 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
 {
 if (data.length > 0 && error == nil)
 {
 //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 //NSLog(@"%@", json);
 
 //data = [json dataUsingEncoding:NSUTF8StringEncoding];
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 NSLog(@"Error: %@", error);
 //NSLog(@"JSON: %@", dic);
 
 NSDictionary *dic2 = [dic objectForKey:@"d"];
 
 NSArray *arr = [dic2 objectForKey:@"List"];
 
 NSMutableArray *sites = [[NSMutableArray alloc] init];
 for (NSDictionary *dic in arr)
 {
 SiteDTO *site = [[SiteDTO alloc] init];
 site.SiteID = [dic objectForKey:@"LocationID"];
 site.Name = [dic objectForKey:@"Name"];
 site.ProjectCount = [[dic objectForKey:@"ProjectCount"] integerValue];
 [sites addObject:site];
 }
 NSLog(@"sites: %@", sites);
 }
 else if (error != nil)
 {
 NSLog(@"Error: %@", error);
 }
 }];
 
 
 
 
 }

 
 */





@end
