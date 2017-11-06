//
//  MusicSearcher.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public protocol MusicSearcher
{
    /// 楽曲を検索する
    /// - Parameter keyword: 検索キーワード
    /// - Returns: 該当した楽曲
    func search(keyword: String) -> [Music]
}
