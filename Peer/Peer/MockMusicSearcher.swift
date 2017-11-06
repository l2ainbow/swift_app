//
//  MockMusicSearcher.swift
//  Peer
//
//  Created by Yu Iijima on 2017/11/06.
//  Copyright © 2017年 Shingo. All rights reserved.
//

public class MockMusicSearcher: MusicSearcher{
    /// 楽曲を検索する
    /// - Parameter keyword: 検索キーワード
    /// - Returns: 該当した楽曲
    public func search(keyword: String) -> [Music]{
        var musics = [Music]()
        musics.append(Music(id: "0", title: "虹", artist: "Larcenciel"))
        musics.append(Music(id: "1", title: "Honey", artist: "Larcenciel"))
        return musics
    }
}
