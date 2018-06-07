 //
//  LUVideoPlayerViewController.m
//  LUStudent
//
//  Created by Preeti Patil on 27/01/17.
//  Copyright © 2018 Set Infotech. All rights reserved.
//

#import "LUVideoPlayerViewController.h"

@interface LUVideoPlayerViewController ()

@end

@implementation LUVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_type isEqualToString:@"1"])
    {
        NSDictionary *playerVars = @{
                                     @"controls" : @2,
                                     @"playsinline" : @1,
                                     @"autohide" : @1,
                                     @"showinfo" : @0,
                                     @"modestbranding" : @1
                                     };
        self.playerView.delegate = self;
        [self.playerView loadWithVideoId:_videoID playerVars:playerVars];
    }
    else if ([_type isEqualToString:@"2"])
    {
        [self.navigationController setTitle:_header];
        
        NSURL *websiteUrl = [NSURL URLWithString:_videoID];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60,self.view.bounds.size.width, self.view.bounds.size.height )];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
        [webView loadRequest:urlRequest];
        [self.view addSubview:webView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
