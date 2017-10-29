//
//  MockCurrentLocator.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockCurrentLocator: CurrentLocator
{
    public func locate() -> Location
    {
        let loc = Location(latitude: 36.407107, longitude: 140.446383)
        return loc
    }
}
