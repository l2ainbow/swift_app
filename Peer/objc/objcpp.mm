//
//  objcpp.m
//  c++Test
//
//  Created by 外村真吾 on 2017/11/12.
//  Copyright © 2017年 Shingo. All rights reserved.
//

/*objcpp.mm*/
#import <Foundation/Foundation.h>

#import "Header.h"
#import "cpp.hpp"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
@implementation ObjCpp {
    CCpp * cpp;
}

+(NSString *) openCVVersionString
{
    return [NSString stringWithFormat: @"openCV Version %s", CV_VERSION];
}

-(NSString *) calcPosition:(UIImage *)image distance:(double)r radian:(double)theta
{
    // transform UIImagge to cv::Mat
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    NSString *str = [NSString stringWithUTF8String:(cpp->detectMan(imageMat,r, theta).c_str())];
    
    return str;
}
-(id)init {
    self = [super init];
    cpp = new CCpp();
    return self;
}



@end
