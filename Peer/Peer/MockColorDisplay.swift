//
//  MockColorDisplay.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockColorDisplay: ColorDisplay
{
    public func display(R: UInt8, G: UInt8, B: UInt8)
    {
        print("R: \(R), G: \(G), B: \(B)")
    }
    public func display(color: Color)
    {
        print("Color: \(color)")
    }
    public func illuminate(interval: Int, colors: [Color], isRepeat: Bool) {
        print("Illuminate: interval=\(interval), isRepeat=\(isRepeat)")
        for color in colors {
            print("\(color)")
        }
    }
}
