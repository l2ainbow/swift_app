// ShirtsDetection.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>    // coreモジュールのヘッダーをインクルード
#include <opencv2/highgui.hpp> // highguiモジュールのヘッダーをインクルード
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
#include <cmath>
#include <string>
#include <fstream>
#include "cpp.hpp"
using namespace cv;
using namespace std;

//polar coordinate
//struct Pol{
//	double d;
//	double theta;
//};

static void rgb2hsv(Mat &img, Mat &hsv) {
    hsv = img.clone();
    
    for (int i = 0; i < img.cols; i++) {
        for (int j = 0; j < img.rows; j++) {
            double r = img.at<Vec3b>(j, i)[0];
            double g = img.at<Vec3b>(j, i)[1];
            double b = img.at<Vec3b>(j, i)[2];
            
            double MAX = max(max(r, g), b) / 255;
            double MIN = min(min(r, g), b) / 255;
            
            double h, s, v;
            if (MIN == b) {
                h = 60 * (g - r) / (MAX - MIN) + 60;
            }
            else if (MIN == r) {
                h = 60 * (b - g) / (MAX - MIN) + 180;
            }
            else {
                h = 60 * (r - b) / (MAX - MIN) + 300;
            }
            h = h * 255 / 359;
            s = (MAX - MIN) / MAX * 255;
            v = MAX * 255;
            
            hsv.at<Vec3b>(j, i)[0] = (int)h % 256;
            hsv.at<Vec3b>(j, i)[1] = (int)s;
            hsv.at<Vec3b>(j, i)[2] = (int)v;
        }
    }
}

static void mask(Mat &gray, Mat &img) {
    Mat hsv;
    rgb2hsv(img, hsv);
    
    //cvCvtColor(&img, &hsv, CV_RGB2HSV_FULL);
    for (int i = 0; i < gray.cols; i++) {
        for (int j = 0; j < gray.rows; j++) {
            bool b = hsv.at<Vec3b>(j, i)[0] > 10;
            b = b && hsv.at<Vec3b>(j, i)[0] < 100;
            b = b && hsv.at<Vec3b>(j, i)[1] > 50;
            gray.at<uchar>(j, i) = b ? 255 : 0;
        }
    }
    
    hsv.release();
}

static void detectShirt(Mat &img, vector<Rect> &rects) {
    Mat gray = Mat::zeros(img.rows, img.cols, CV_8U);
    
    CvMemStorage *storage = cvCreateMemStorage(0);
    CvSeq *contours = 0;
    
    mask(gray, img);
    IplImage iplImage = gray;
    cvFindContours(&iplImage, storage, &contours, sizeof(CvContour));
    
    //gray.release();
    
    //for (int i = 0; i < contours->total; i++) {
    for (; contours != 0; contours = contours->h_next) {
        //Mat *approx = 0;
        //bug, CvSeq cannot convert to CvArr
        //cvConvexHull2(&contours[i], approx);
        Rect rect = cvBoundingRect(contours, 1);
        auto x = rect;
        if (!(x.width / x.height < 2) || !(x.height / x.width > 0.5)) {
            rects.push_back(rect);
        }
    }
    
    /*for (auto it = rects.end(); it != rects.begin(); it--) {
     auto x = *it;
     if ((x.width / x.height < 2)&(x.height / x.width > 0.5)) {
     rects.erase(it);
     }
     }*/
    
    cvReleaseMemStorage(&storage);
    
}

double calcDist(double r, double rmax) {
    double f = rmax / (43.2 / 2 / 32);
    double theta = r / f;
    
    //height = 1m is assumed
    return tan(theta);
}

string CCpp::detectMan(Mat &img, double oldD, double oldTheta) {
    
    vector<Rect> rects;
    detectShirt(img, rects);
    
    double w = img.cols;
    double h = img.rows;
    
    double r, theta;
    if (rects.size() > 0) {
        Rect rect;
        double max = 0;
        for (auto it = rects.begin(); it != rects.end(); it++) {
            double area = (*it).width * (*it).height;
            if (area > max) {
                max = area;
                rect = *it;
            }
        }
        double x = rect.x + rect.width / 2 - w / 2;
        double y = rect.y + rect.height / 2 - h / 2;
        
        r = pow(x, 2) + pow(y, 2);
        theta = atan2(x, y);
    }
    img.release();
    
    int d = calcDist(r, w);
    
    ostringstream ss, ss1;
    ss << d;
    ss1 << theta;
    
    string str = ss.str() + "," + ss1.str();
    
    return str;
}
