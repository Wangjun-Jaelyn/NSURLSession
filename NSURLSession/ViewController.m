//
//  ViewController.m
//  NSURLSession
//
//  Created by debao.com on 2016/11/11.
//  Copyright © 2016年 Debao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat bgWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat bgHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect responseTextRect = CGRectMake(10, 64, bgWidth-20, bgHeight/2-64);
    _responseText = [[UITextView alloc] initWithFrame:responseTextRect];
    _responseText.textColor = [UIColor blueColor];
    _responseText.text = @"请输入用户名和密码后提交到服务器";
    [self.view addSubview:_responseText];
    _responseText.backgroundColor = [UIColor grayColor];
    
    CGRect usernameRect = CGRectMake(10, bgHeight/2+10, bgWidth-20, 40);
    CGRect passwordRect = CGRectMake(10, usernameRect.origin.y+10+usernameRect.size.height, bgWidth-20, 40);
    _username = [[UITextField alloc] initWithFrame:usernameRect];
    _username.textAlignment = NSTextAlignmentCenter;
    _username.placeholder = @"您的用户名";
    _username.textColor = [UIColor blackColor];
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_username];
    
    _password = [[UITextField alloc] initWithFrame:passwordRect];
    _password.textAlignment = NSTextAlignmentCenter;
    _password.placeholder = @"您的密码";
    _password.textColor = [UIColor blackColor];
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_password];
    
    CGFloat submitWidth = 100;
    CGFloat submitHeight = 40;
    UIButton* submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    submit.frame = CGRectMake(bgWidth/2-submitWidth/2, _password.frame.origin.y+_password.frame.size.height+10, submitWidth, submitHeight);
    [self.view addSubview:submit];
    submit.backgroundColor = [UIColor yellowColor];
    [submit addTarget:self action:@selector(pressSubmit) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"REFRESH" object:nil];
}

- (void)refresh:(NSNotification *)notification{
    //    _responseText.text = (NSString*)notification.object;
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"main");
    } else {
        NSLog(@"not main");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //do your UI
        _responseText.text = (NSString*)notification.object;
    });
}

- (void)pressSubmit{
    NSLog(@"用户名：%@", _username.text);
    NSLog(@"密码：%@", _password.text);
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/SimpleServer/SimpleServerLogin?username=%@&password=%@", _username.text, _password.text]];
    //    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask* task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@ dsfds", result);
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(defaultQueue, ^{
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"REFRESH" object:result];
        });
        //        [[NSNotificationCenter defaultCenter]  postNotificationName:@"REFRESH" object:result];
    }];
    [task resume];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}
@end
