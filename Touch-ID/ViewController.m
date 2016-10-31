//
//  ViewController.m
//  Touch-ID
//
//  Created by 孙云飞 on 2016/10/28.
//  Copyright © 2016年 孙云飞. All rights reserved.
//
/**
 
 typedef NS_ENUM(NSInteger, LAError)
 {
 失败授权(3次机会失败 --身份验证失败)
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 
 用户取消touchid授权(用户点击取消按钮)
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 用户选择输入密码,用户点击回退按钮(输入密码)
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 系统取消授权，系统跳转app之类的(比如另一个应用程序去前台,切换到其他 APP)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 设置touchid不可用，因为触摸ID在设备上不可用
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 身份验证无法启动,因为没有登记的手指触摸ID。 没有设置指纹密码时。
 LAErrorTouchIDNotEnrolled = kLAErrorTouchIDNotEnrolled,
 
 这个错误出现，源自用户多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁，这个错误的交互LocalAuthentication.framework已经封装好了，不需要开发者关心
 LAErrorTouchIDLockout   NS_ENUM_AVAILABLE(10_11, 9_0) __WATCHOS_AVAILABLE(3.0) __TVOS_AVAILABLE(10.0) = kLAErrorTouchIDLockout,
 
 LAErrorAppCancel和LAErrorSystemCancel相似，都是当前软件被挂起取消了授权，但是前者是用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。后者是用户自己切到了别的应用，例如按home键挂起
 LAErrorAppCancel        NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorAppCancel,
 
 就是授权过程中,LAContext对象被释放掉了，造成的授权失败
 LAErrorInvalidContext   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorInvalidContext
 }
 **/
#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <sys/utsname.h>
#import "ShowViewController.h"
@interface ViewController ()
@property(nonatomic,strong)UILabel *errorLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指纹解锁啦";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 50);
    [btn setTitle:@"解锁" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 20)];
    self.errorLabel.font = [UIFont systemFontOfSize:20];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.errorLabel];
}


//按钮事件
- (void)clickBtn{
    
    //初始上下文对象
    LAContext *context = [[LAContext alloc]init];
    //错误对象
    NSError *error = nil;
    //判断设置的各种状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        
        //指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证指纹啦，亲" reply:^(BOOL success, NSError * _Nullable error) {
            
            //各种状态判断
            __block typeof(self)weakSelf = self;
            if (success) {
                NSLog(@"指纹验证成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    ShowViewController *show = [[ShowViewController alloc]init];
                    [weakSelf.navigationController pushViewController:show animated:YES];
                });
            }else{
                
                switch (error.code) {
                    case LAErrorUserCancel:{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.errorLabel.text = @"取消了指纹验证";
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.errorLabel.text = @"选择手动输入密码";
                        });
                    }
                        break;
                    default:{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.errorLabel.text = @"详细错误，查对应的项";
                        });
                    }
                        break;
                }
            }
        }];
    }else{
        
        //不支持指纹识别
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.errorLabel.text = @"Touch ID不可用";
                });
            }
                break;
            case LAErrorPasscodeNotSet:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.errorLabel.text = @"系统未设置密码";
                });
            }
                break;
            default:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.errorLabel.text = @"详细错误，查对应的项";
                });
            }
                break;
        }
    }
    
}


@end
