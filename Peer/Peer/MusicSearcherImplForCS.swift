//
//  MusicSearcherImplForCS.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/13.
//  Copyright © 2017年 Shingo. All rights reserved.
//

import MediaPlayer

// チャンピオンシップ大会用にMusicSearcherImplを修正
public class MusicSearcherImplForCS: MusicSearcher{
    let PERFORMANCE_KEYWORD = "CS大会用"
    let KEYWORD_PROPERTY = MPMediaItemPropertyAlbumTitle

    /// 楽曲を検索する
    /// - Parameter keyword: 検索キーワード
    /// - Returns: 該当した楽曲
    public func search(keyword: String) -> [Music]{
        var musics = [Music]()
        
        let performanceProperty = MPMediaPropertyPredicate(value: PERFORMANCE_KEYWORD, forProperty: KEYWORD_PROPERTY, comparisonType: MPMediaPredicateComparison.contains)
        
        for target in [MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyComposer, MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyAlbumArtist] {
            let property = MPMediaPropertyPredicate(value: keyword, forProperty: target, comparisonType: MPMediaPredicateComparison.contains)
            let query = MPMediaQuery()
            query.addFilterPredicate(performanceProperty)
            query.addFilterPredicate(property)
            if query.items != nil {
                let sTitle = query.items!
                for single in sTitle {
                    musics.append(Music(id: String(single.persistentID), title: single.title!, artist: single.artist!))
                }
            }
        }
        
        return musics
    }
}
