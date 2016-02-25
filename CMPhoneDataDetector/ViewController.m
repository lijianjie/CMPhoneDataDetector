//
//  ViewController.m
//  CMPhoneDataDetector
//
//  Created by lijianjie on 16/2/24.
//  Copyright © 2016年 lijianjie. All rights reserved.
//

#import "ViewController.h"
#import "CMTTTAttributedLabel.h"

NSString * const kCMTTTPhoneNumberRegex = @"(?<![\\.|\\d])(\\+{0,1})((\\d{2,5}(( ){0,1}-{0,1}( ){0,1})\\d{7,8})\
|(\\d{1,3}(( ){0,1}-{0,1}( ){0,1})\\d{1,4}(( ){0,1}-{0,1}( ){0,1})\\d{3,8}(( ){0,1}-{0,1}( ){0,1})\\d{3,8})\
|(\\d{1,7}(( ){0,1}-{0,1}( ){0,1})\\d{3,8}(( ){0,1}-{0,1}( ){0,1})\\d{3,8})|(1[35]\\d{9,9})|(\\d{5,18}))(?![\\.|\\d])";

@interface ViewController ()

@property (nonatomic, strong) CMTTTAttributedLabel *phoneLabel;
@property (nonatomic, strong) NSString *phoneString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.phoneString = @"a nib a15650717630a";
    
    CMTTTAttributedLabel *phoneLabel = [[CMTTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber;
    phoneLabel.text = self.phoneString;
    phoneLabel.numberOfLines = 0;
    phoneLabel.center = self.view.center;
    self.phoneLabel = phoneLabel;
    [self.view addSubview:phoneLabel];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.phoneLabel addGestureRecognizer:tapGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [self.phoneLabel addGestureRecognizer:longPressGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapHandle:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self.phoneLabel];
    TTTAttributedLabelLink *link = [self.phoneLabel linkAtPoint:touchPoint];
    
    if (link) {
        NSTextCheckingResult *result = link.result;
        
        if (!result) {
            return;
        }
        
        if ([result.regularExpression.pattern isEqualToString:kCMTTTPhoneNumberRegex])
        {
            NSString *phoneNumber = [self.phoneString substringWithRange:result.range];
            [self callPhone:phoneNumber];
        }
    }
}

- (void)longPressHandle:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        UIMenuItem *copyLink = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyCN:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyLink]];
        [[UIMenuController sharedMenuController] setTargetRect:self.phoneLabel.frame inView:self.view];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (void)callPhone:(NSString *)aPhoneNumber
{
    NSString *call = [NSString stringWithFormat:@"telprompt://%@", aPhoneNumber];
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyCN:))
    {
        return YES;
    }
    return NO;
}

- (void)copyCN:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.phoneLabel.text;
}

@end
