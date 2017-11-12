//
//  Header.h
//  c++Test
//
//  Created by 外村真吾 on 2017/11/12.
//  Copyright © 2017年 Shingo. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ObjCpp : NSObject
+(NSString *) openCVVersionString;
-(NSString *) calcPosition:(UIImage *)image distance:(double)r radian:(double)theta;
@end

#endif /* Header_h */
