//
//  KeywordSearcher.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import Foundation

public class KeywordSearcher{
    static func search(string: String, keyword: String) -> Bool{
        return string.contains(keyword)
    }
    
    static func search(string: String, keywords: [String]) -> Bool{
        var isSearched: Bool = false
        for keyword in keywords{
            if self.search(string: string, keyword: keyword){
                isSearched = true
                break
            }
        }
        return isSearched
    }
}
