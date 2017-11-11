//
//  ColorDisplayImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation

public class ColorDisplayImpl: ColorDisplay
{
    private var view: UIView
    private var peripheral: CBPeripheral?
    private var ledCharacteristic: CBCharacteristic?
    
    /// イルミネーションの繰り返し中か
    private var isRepeatIllumination = false
    /// イルミネーションを終了予定か
    private var willFinishIllumination = true
    
    private let semaphore = DispatchSemaphore(value: 1)
    
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
    ///   - brightness: LEDの明るさ
    public func display(R: UInt8, G: UInt8, B: UInt8, brightness: UInt8)
    {
        self.willFinishIllumination = true
        self.isRepeatIllumination = false
        self.displayColorChange(red: R, green: G, blue: B)
        self.ledColorChange(red: R, green: G, blue: B, brightness: brightness)
    }
    
    /// 色を表示する
    /// - Parameter color: 表示色
    public func display(color: Color)
    {
        let rgb = convertColorToRGB(color: color)
        display(R: rgb[0], G: rgb[1], B: rgb[2])
    }
    
    /// 色を表示する
    /// - Parameters:
    ///   - R: 表示色のR(0-255)
    ///   - G: 表示色のG(0-255)
    ///   - B: 表示色のB(0-255)
    public func display(R: UInt8, G: UInt8, B: UInt8){
        display(R: R, G: G, B: B, brightness: 255)
    }
    
    /// イルミネーションのように色を変化させながらゆっくり点滅を繰り返す
    /// - Parameter
    ///   - interval: 色を変える間隔 [s]
    ///   - colors: 表示色（複数指定可能；要素順で表示）
    ///   - isRepeat: 最後の色まで到達したら先頭の色に戻って繰り返すか（true: 繰り返す、false: 繰り返さない）
    public func illuminate(interval: Double, colors: [Color], isRepeat: Bool) {
        let queue = DispatchQueue(label: "colordisplayimpl.illuminate")
        queue.async{
            self.willFinishIllumination = true
            self.isRepeatIllumination = false
            self.semaphore.wait()
            self.willFinishIllumination = false
            self.isRepeatIllumination = isRepeat
            repeat{
                for color in colors {
                    let rgb = self.convertColorToRGB(color: color)
                    self.displayColorChange(red: rgb[0], green: rgb[1], blue: rgb[2])
                    // - TODO: LEDの点滅を繰り返すように修正する（Arduino側の修正も必要）
                    for i in 1...10 {
                        let br = (Double((5 - abs(5 - i))) / 5 * 255.0)
                        self.ledColorChange(red: rgb[0], green: rgb[1], blue: rgb[2], brightness: UInt8(br))
                        Thread.sleep(forTimeInterval: interval/10.0)
                    }
                    if self.willFinishIllumination {
                        break
                    }
                }
            }while(self.isRepeatIllumination)
            self.semaphore.signal()
        }
    }
    
    /// ディスプレイの色を変更する
    /// - Parameters:
    ///   - r: RGBのR(0-255)
    ///   - g: RGBのG(0-255)
    ///   - b: RGBのB(0-255)
    private func displayColorChange(red r: UInt8, green g: UInt8, blue b: UInt8) {
        if (Thread.isMainThread){
            self.view.backgroundColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        }
        else {
            DispatchQueue.main.async{
                self.view.backgroundColor = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
            }
        }
    }

    /// LEDの色を変更する
    /// - Parameters:
    ///   - r: RGBのR(0-255)
    ///   - g: RGBのG(0-255)
    ///   - b: RGBのB(0-255)
    ///.  - brightness: 明るさ(0-255)
    private func ledColorChange(red r: UInt8, green g: UInt8, blue b: UInt8, brightness: UInt8){
        if(self.peripheral != nil && self.ledCharacteristic != nil){
            var bytes : [UInt8] = [r, g, b, brightness]
            let data = NSData(bytes: &bytes, length: 4)
            self.peripheral?.writeValue(data as Data, for: self.ledCharacteristic!, type:
                CBCharacteristicWriteType.withResponse)
            
        }
    }
    
    /// 色をRGBに変換する
    /// - Parameters:
    ///   - color: 色
    /// - Returns: RGB(0-255)の配列
    private func convertColorToRGB(color: Color) -> [UInt8]{
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
        return rgb
    }
}
