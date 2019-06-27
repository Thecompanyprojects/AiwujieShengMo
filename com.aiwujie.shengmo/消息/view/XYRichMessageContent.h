//
//  LHRichMessageContent.h
//  RongIMDemo
//
//  Created by Bryan Yuan on 12/13/16.
//  Copyright © 2016 Bryan Yuan. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface XYRichMessageContent : RCMessageContent

@property (copy) NSString *imageName;
@property (copy) NSString *number;
//@property (nonatomic) NSDate *dateSent;
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
