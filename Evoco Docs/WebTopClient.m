#import "WebTopClient.h"

@interface WebTopClient ()

@property (nonatomic, strong) NSString *umServiceUrl;
@property (nonatomic, strong) NSString *docsServiceUrl;

@end

@implementation WebTopClient



+ (WebTopClient *) instance
{
    static WebTopClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        instance = [[WebTopClient alloc] initInstance];
    });
    return instance;
}


- (id)initInstance {
    if (self = [super init])
    {
        self.umServiceUrl = @"UserManagement/Services/UserServices.svc";
        self.docsServiceUrl = @"Documents/Services/DocumentsService.svc";
        self.clientUrl = @"example.myevoco.com";
    }
    
    return self;
}

- (NSString *) login:(NSString *)user password:(NSString *)pass
{
    NSString *urlString = [self.clientUrl stringByAppendingFormat: @"WebTop/Secured/VerifyLoginHandler.ashx?username=%@&password=%@&callback=*&DropDuplicateLogin=1", user, pass];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *resp;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
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
            
            if ([errorCode isEqualToString:@"um.AlreadyLoggedIn"]) { return nil; }
            
            NSString *errorMessage = [dic objectForKey:@"ErrorMessage"];
            NSLog(@"LoginResponse Error Code:%@, Message:%@", errorCode, errorMessage);
            return errorMessage;
        }
        else
        {
            NSString *authCookieValue = [dic objectForKey:@"AuthCookie"];
            [self setAuthCookie:authCookieValue];
            return nil;
        }
    }
    else if (error != nil)
    {
        NSLog(@"Error: %@", error);
        return [NSString stringWithFormat:@"Error: %@",error];
    }
    else {
        return [error localizedDescription];
    }
    
    return @"Internal Error";
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

- (NSDictionary *) makeServiceCall:(NSString *)serviceUrl method:(NSString *)serviceFunction withArgs:(NSDictionary *)args
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlString = [self.clientUrl stringByAppendingFormat: @"%@/%@", serviceUrl, serviceFunction];
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [NSMutableURLRequest  requestWithURL:url];
    req.timeoutInterval = 30.0f;
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if (args)
    {
        NSData *reqData = [NSJSONSerialization dataWithJSONObject:args options:kNilOptions error:&error];
        NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%d", reqData.length];
        req.HTTPBody = reqData;
        [req setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    }

    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [req setAllHTTPHeaderFields:headers];
    
    NSURLResponse *resp;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    //NSLog(@"Error: %@", error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (data.length > 0 && error == nil)
    {
        //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", json);
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //NSLog(@"Error: %@", error);
        //NSLog(@"JSON: %@", dic);
        
        NSDictionary *dic2 = [dic objectForKey:@"d"];
        if ((NSNull *)dic2 == [NSNull null])
            return nil;
        return dic2;
        
    }
    else if (error != nil)
    {
        NSLog(@"Error: %@", error);
    }
    return nil;
    
}

- (NSData *) downloadFile:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:[self.clientUrl stringByAppendingString:urlString]];
    NSLog(@"%@", url);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [req setAllHTTPHeaderFields:headers];
    
    NSError *error;
    NSURLResponse *resp;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (error == nil)
    {
        NSLog(@"Downloaded %d bytes", data.length);
        return data;
    }
    else
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
}


- (FileUploadDTO *) uploadFile:(NSString *)urlString withName:(NSString *)fileName fromData:(NSData *)fileData
{
    NSURL *url = [NSURL URLWithString:[self.clientUrl stringByAppendingString:urlString]];
    NSLog(@"%@", url);
    
    NSMutableURLRequest *req = [NSMutableURLRequest  requestWithURL:url];
    req.timeoutInterval = 180.0f;
    req.HTTPMethod = @"POST";
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [req setAllHTTPHeaderFields:cookieHeaders];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:fileName                             forHTTPHeaderField:@"X-File-Name"];
    [req setValue:@"0"                                 forHTTPHeaderField:@"X-File-TempId"];
    
    NSString* len = [[NSString alloc] initWithFormat:@"%d", fileData.length];
    [req setValue:len forHTTPHeaderField:@"Content-Length"];
    [req setValue:len forHTTPHeaderField:@"X-File-Size"];
    
    req.HTTPBody = fileData;
    
    NSError *error = nil;
    NSURLResponse *resp;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    
    //NSLog(@"Error: %@", error);
    
    if (data.length > 0 && error == nil)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //NSLog(@"Error: %@", error);
        //NSLog(@"JSON: %@", dic);
        
        FileUploadDTO *uploadDTO = [[FileUploadDTO alloc] init];
        uploadDTO.SuccessMessage = [dic objectForKey:@"SuccessMsg"];
        uploadDTO.ErrorMessage = [dic objectForKey:@"ErrorMsg"];
        uploadDTO.TempID = [dic objectForKey:@"TempId"];
        
        NSDictionary *docDic = [dic objectForKey:@"Doc"];
        uploadDTO.Document = [DocumentDTO fromDictionary:docDic];
        
        /*if ((NSNull *)uploadDTO.ErrorMessage == [NSNull null])
        {
            uploadDTO.ErrorMessage = nil;
        }*/
        
        return uploadDTO;
    }
    else if (error != nil)
    {
        NSLog(@"Error: %@", error);
    }
    return nil;
}




- (ClientDTO *) getCurrentClient
{
    NSDictionary *dic = [self makeServiceCall:self.umServiceUrl method:@"GetCurrentClient" withArgs:nil];
    //NSLog(@"JSON: %@", dic);
    
    ClientDTO *client = [[ClientDTO alloc] init];
    client.ClientID = [dic objectForKey:@"ClientID"];
    client.Name = [dic objectForKey:@"ClientName"];
    client.Url = [dic objectForKey:@"Url"];
    return client;
}

- (NSArray *) getSites
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys: @"", @"searchText", nil];
    NSDictionary *dic = [self makeServiceCall:self.umServiceUrl method:@"GetLocationsQuick" withArgs:args];
    
    NSArray *arr = [dic objectForKey:@"List"];

    NSMutableArray *sites = [[NSMutableArray alloc] init];
    for (NSDictionary *d in arr)
    {
        [sites addObject:[SiteDTO fromDictionary:d]];
    }
    //NSLog(@"sites: %@", sites);
    return sites;
}

- (NSArray *) getProjectsForSite:(NSString *)siteID
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys: siteID, @"locationID", nil];
    NSDictionary *dic = [self makeServiceCall:self.umServiceUrl method:@"GetProjectsForLocation" withArgs:args];

    NSArray *arr = [dic objectForKey:@"List"];
    
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    for (NSDictionary *d in arr)
    {
        ProjectDTO *project = [[ProjectDTO alloc] init];
        project.ProjectID = [d objectForKey:@"ProjectID"];
        project.Name = [d objectForKey:@"Name"];
        [projects addObject:project];
    }
    //NSLog(@"projects: %@", projects);
    return projects;
}

- (FolderDTO *) getRootFolderForAssociation:(NSString *) assID;
{
    //NSLog(@"assID: %@", assID);
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys: assID, @"assID", nil];
    NSDictionary *dic = [self makeServiceCall:self.docsServiceUrl method:@"GetRootFolderForAssociation" withArgs:args];
    
    //NSLog(@"JSON: %@", dic);
    
    if (!dic)
        return nil;
    
    NSDictionary *tdic = [dic objectForKey:@"TemplateFolder"];
    
    FolderDTO *folder = [[FolderDTO alloc] init];
    folder.ID = [dic objectForKey:@"ID"];
    folder.Name = [tdic objectForKey:@"Name"];
    return folder;
}

- (NSArray *) getFolderContents:(NSString *)parentFolderID withDeleted:(BOOL)includeDeleted withEmptyFolders:(BOOL)includeEmptyFolders;
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
        parentFolderID, @"folderId",
        includeDeleted, @"includeDeleted",
        includeEmptyFolders, @"includeEmptyFolders",
        nil];
    NSDictionary *dic = [self makeServiceCall:self.docsServiceUrl method:@"GetFolderContents" withArgs:args];
    //NSLog(@"JSON: %@", dic);
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    NSArray *foldersArr = [dic objectForKey:@"Folders"];
    for (NSDictionary *folderDic in foldersArr)
    {
        [results addObject:[FolderDTO fromDictionary:folderDic]];
    }

    NSArray *docsArr = [dic objectForKey:@"Documents"];
    for (NSDictionary *docDic in docsArr)
    {
        //NSLog(@"Doc: %@", docDic);
        [results addObject:[DocumentDTO  fromDictionary:docDic]];
    }

    return results;
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
