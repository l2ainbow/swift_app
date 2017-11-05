//
//  CurrentLocatorImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import CoreLocation

public class CurrentLocatorImpl: NSObject, CurrentLocator
{
    /// デファルトの緯度[度]
    static let DEFAULT_LATITUDE = 36.407107
    /// デファルトの経度[度]
    static let DEFAULT_LONGITUDE = 140.446383
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location : Location = Location(latitude: DEFAULT_LATITUDE, longitude: DEFAULT_LONGITUDE)
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    /// 現在位置を検出する
    /// - Returns: 現在位置
    public func locate() -> Location
    {
        // - TODO: 現在位置の検出を実現する
        print("lat=\(self.location.latitude), lon=\(self.location.longitude)")
        return self.location
    }
}
    
extension CurrentLocatorImpl: CLLocationManagerDelegate{
    
    /// 認証状態が変化した時の処理
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - status: 認証状態
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    /// 位置情報が更新された時の処理
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                return
        }
        self.location.latitude = newLocation.coordinate.latitude
        self.location.longitude = newLocation.coordinate.longitude
        print("lat=\(self.location.latitude), lon=\(self.location.longitude)")
        self.locationManager.stopUpdatingLocation()
    }
}
