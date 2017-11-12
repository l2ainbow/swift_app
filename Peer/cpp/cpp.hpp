//
//  cpp.hpp
//  c++Test
//
//  Created by 外村真吾 on 2017/11/12.
//  Copyright © 2017年 Shingo. All rights reserved.
//

#ifndef cpp_hpp
#define cpp_hpp

#include <stdio.h>
#include <cmath>
#include <opencv2/core/core.hpp>
#include <string>
class CCpp {
    
public:
    std::string detectMan(cv::Mat &img,double oldD,double oldTheta);
    
};
#endif /* cpp_hpp */
