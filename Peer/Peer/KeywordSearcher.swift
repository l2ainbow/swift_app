//
//  KeywordSearcher.swift
//  Peer
//
//  Created by Yu Iijima on 2017/10/22.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class KeywordSearcher{
    /// キーワードを検索する
    /// - Parameters:
    ///   - string: 検索対象の文字列
    ///   - keyword: キーワード
    /// - Returns: 検索結果(true: 該当あり、false: 該当なし)
    static func search(string: String, keyword: String) -> Bool{
        return string.contains(keyword)
    }
    
    /// キーワードを検索する
    /// - Parameters:
    ///   - string: 検索対象の文字列
    ///   - keywords: キーワード（複数選択可）
    /// - Returns: 検索結果(true: 該当あり、false: 該当なし)
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
