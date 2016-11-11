//
//  ViewController.h
//  NSURLSession连接本地服务器
//
//  Created by debao.com on 2016/11/11.
//  Copyright © 2016年 Debao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate>

@property(nonatomic,copy)UITextView* responseText;
@property(nonatomic,copy)UITextField* username;
@property(nonatomic,copy)UITextField* password;
@property(nonatomic,copy)NSURLSession* session;

@end

