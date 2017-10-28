//
//  CurrentLocator.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol CurrentLocator
{

    func locate() -> Location?
}
