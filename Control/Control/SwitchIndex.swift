//
//  SwitchIndex.swift
//  Control
//
//  Created by 外村真吾 on 2017/08/26.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation
import UIKit

class SwitchIndex{
    
    private var switchIndex : Int!
    private var switchName : UISwitch!
    
    func setSwitchName(switchName: UISwitch) {
        
        self.switchName = switchName
        
    }
    
    func getSwitchName() -> UISwitch {
        
        return self.switchName
    
    }
    
    func setSwitchIndex(switchIndex: Int) {
        
        self.switchIndex = switchIndex
        
    }
    
    func getSwitchIndex() -> Int {
        
        return self.switchIndex
        
    }
    
}
