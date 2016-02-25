//
//  CMTTTAttributedLabel.m
//  CMPhoneDataDetector
//
//  Created by lijianjie on 16/2/24.
//  Copyright © 2016年 lijianjie. All rights reserved.
//

#import "CMTTTAttributedLabel.h"

@interface CMTTTAttributedLabel ()

@property (readwrite, atomic, strong) NSRegularExpression *dataDetector;

@end

@implementation CMTTTAttributedLabel

- (void)setDataDetectorTypes:(NSTextCheckingTypes)dataDetectorTypes {
    self.enabledTextCheckingTypes = dataDetectorTypes;
}

- (void)setEnabledTextCheckingTypes:(NSTextCheckingTypes)enabledTextCheckingTypes {
    
    if (enabledTextCheckingTypes & NSTextCheckingTypePhoneNumber) {
        
        [super setEnabledTextCheckingTypes:NSTextCheckingTypePhoneNumber];
        self.dataDetector = [NSRegularExpression regularExpressionWithPattern:kCMTTTPhoneNumberRegex options:0 error:NULL];
    }
}

@end
