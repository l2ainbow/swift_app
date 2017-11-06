//
//  ColorDisplayImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit
import CoreBluetooth

public class ColorDisplayImpl: ColorDisplay
{
    private var view: UIView
    private var peripheral: CBPeripheral?
    private var ledCharacteristic: CBCharacteristic?
    
    init(view: UIView, peripheral: CBPeripheral?, characteristic: CBCharacteristic?){
        self.view = view
        self.peripheral = peripheral
        self.ledCharacteristic = characteristic
    }
    
    /// 色を表示する
    /// - Parameters:
    ///   - R: 表示色のR(0-255)
    ///   - G: 表示色のG(0-255)
    ///   - B: 表示色のB(0-255)
    public func display(R: UInt8, G: UInt8, B: UInt8)
    {
        if (Thread.isMainThread){
            displayColorChange(red: R, green: G, blue: B)
        }
        else{
            DispatchQueue.main.async {
                self.displayColorChange(red: R, green: G, blue: B)
            }
        }
        ledColorChange(red: R, green: G, blue: B)
    }
    
    /// 色を表示する
    /// - Parameter color: 表示色
    public func display(color: Color)
    {
        var rgb : [UInt8]
        switch color {
        case Color.White:
            rgb = [255, 255, 255]
        case Color.Black:
            rgb = [0, 0, 0]
        case Color.Orange:
            rgb = [255, 165, 0]
        case Color.Blue:
            rgb = [0, 0, 255]
        case Color.Green:
            rgb = [0, 255, 0]
        case Color.Red:
            rgb = [255, 0, 0]
        case Color.LightBlue:
            rgb = [173, 216, 230]
        case Color.Yellow:
            rgb = [255, 255, 0]
        case Color.Gray:
            rgb = [128, 128, 128]
        case Color.LightGray:
            rgb = [200, 200, 200]
        case Color.Purple:
            rgb = [255, 0, 255]
        default:
            rgb = [0, 0, 0]
        }
        display(R: rgb[0], G: rgb[1], B: rgb[2])
    }
    
    public func illuminate(interval: Int, colors: [Color], isRepeat: Bool) {
        // -TODO: いずれ実装する
    }
    
    /// ディスプレイの色を変更する
    /// - Parameters:
    ///   - r: RGBのR(0-255)
    ///   - g: RGBのG(0-255)
    ///   - b: RGBのB(0-255)
    private func displayColorChange(red r: UInt8, green g: UInt8, blue b: UInt8) {
        self.view.backgroundColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }

    /// LEDの色を変更する
    /// - Parameters:
    ///   - r: RGBのR(0-255)
    ///   - g: RGBのG(0-255)
    ///   - b: RGBのB(0-255)
    private func ledColorChange(red r: UInt8, green g: UInt8, blue b: UInt8){
        if(self.peripheral != nil && self.ledCharacteristic != nil){
            var bytes : [UInt8] = [r, g, b]
            let data = NSData(bytes: &bytes, length: 3)
            self.peripheral?.writeValue(data as Data, for: self.ledCharacteristic!, type:
                CBCharacteristicWriteType.withResponse)
            
        }
    }
}
