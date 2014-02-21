//
//  ViewController.m
//  ZenCloudMessaging
//
//  Created by Jason Mimick on 2/20/14.
//  Copyright (c) 2014 Jason Mimick. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)pushNotificationReceived:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    NSLog(@"View got notification %@",info);
    self.textView.text = [info description];
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField.text: %@", textField.text);
    // Get device unique ID
    //UIDevice *device = [UIDevice currentDevice];
    //NSString *uniqueIdentifier = [device
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSData *device_id =appDelegate.deviceId;
    
    NSLog(@"device_id=%@", device_id);
    
    // Start request
    //NSString *code = textField.text;
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.135:57774/"];
    NSString *addr = @"http://192.168.1.135:9980/";
    
    const unsigned *tokenBytes = [device_id bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSURL *getUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",addr,hexToken]];
    
    NSLog(@"getUrl=%@", getUrl);
    
    //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:getUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:getUrl];
    //[request setData:<#(NSData *)#> forKey:<#(NSString *)#>]
    //[request setPostValue:@"1" forKey:@"rw_app_id"];
    //[request setPostValue:code forKey:@"code"];
    //[request setPostValue:uniqueIdentifier forKey:@"device_id"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    // Hide keyword
    [textField resignFirstResponder];
    
    // Clear text field
    textField.text = @"";
    
    return TRUE;
}



-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 400) {
        self.textView.text = @"Invalid code";
    } else if (request.responseStatusCode == 403) {
        self.textView.text = @"Got 403";
    } else if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        NSString *unlockCode = [responseDict objectForKey:@"msg"];
        
        self.textView.text = [NSString stringWithFormat:@"Received: %@", unlockCode];
        
    } else if (request.responseStatusCode == 404 ) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        NSString *msg = [responseDict objectForKey:@"msg"];
        
        self.textView.text = [NSString stringWithFormat:@"Got 404 msg=%@", msg];
    }else {
        self.textView.text = @"Unexpected error";
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.textView.text = error.localizedDescription;
}

- (IBAction)notifyBtn:(id)sender {
    NSLog(@"Notify Me! %@",sender);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSData *device_id =appDelegate.deviceId;
    const unsigned *tokenBytes = [device_id bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSString *service = @"APNS";
    NSString *appId = @"ZCMiOS";
    NSString *appToken = @"App1";
    NSString *payload = [NSString stringWithFormat:@"{\"Service\":\"%@\", \"Identifier\":\"%@\",\"AppIdentifier\":\"%@\",\"AppToken\":\"%@\"}",service,hexToken,appId,appToken];
    
    //NSString *addr = @"http://192.168.1.135:9980/";
   // NSURL *regUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",addr,hexToken]];
    NSURL *regUrl = [NSURL URLWithString:@"http://192.168.1.135:9980/register+notify"];
    
    NSLog(@"regUrl=%@", regUrl);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:regUrl];
    [request appendPostData:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    
    //[request startSynchronous];
    //[request setDelegate:self.registerRequestFinished];
    
    [request startAsynchronous];
    
    NSError *err = [request error];
    if ( !err ) {
        NSString *response = [request responseString];
        self.textView.text = response;
    }
    
}

@end
