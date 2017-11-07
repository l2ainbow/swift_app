//
//  MusicSearcherImpl.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import MediaPlayer

public class MusicSearcherImpl: MusicSearcher{
    /// 楽曲を検索する
    /// - Parameter keyword: 検索キーワード
    /// - Returns: 該当した楽曲
    public func search(keyword: String) -> [Music]{
        var musics = [Music]()
        
        for target in [MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyComposer, MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyAlbumArtist] {
            let property = MPMediaPropertyPredicate(value: keyword, forProperty: target, comparisonType: MPMediaPredicateComparison.contains)
            let query = MPMediaQuery()
            query.addFilterPredicate(property)
            let sTitle = query.items!
            for single in sTitle {
                musics.append(Music(id: String(single.persistentID), title: single.title!, artist: single.artist!))
            }
        }
        
        return musics
    }
}
