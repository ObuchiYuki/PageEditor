//
//  AEFetchAPI.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - AEFetchAPI Class Definition

/* サーバーから記事データを取ってくる
 ----通知----
 - AEFetchAPIDidFetchData (object: [AEArticle])
*/
class AEFetchAPI {
    
    // MARK: - Singleton
    static let `default` = AEFetchAPI()
    
    // MARK: - AEFetchAPI Methods
    
    /// 記事取得を開始します。
    /// 完了時に通知 `AEFetchAPIDidFetchData` が送られます。
    func startFetching(){
        request("https://snakamichi.com/cgi-bin/article_api.py?pass=KTY&method=get").response{res in
            guard let data = res.data else {return}
            
            self._didFetch(with: data)
        }
    }
    
    // MARK: - AEFetchAPI Private Methods
    
    private func _didFetch(with data:Data){
        let articles = self._decodeData(with: data)
        NotificationCenter.default.post(name: .AEFetchAPIDidFetchData, object: articles)
    }
    
    private func _decodeData(with data:Data) -> [AEArticle]{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let json = try? decoder.decode(_AEArticles.self, from: data) else {return []}
        return json.articles
    }
}

// MARK: - Notification.Name extension

extension Notification.Name{
    static let AEFetchAPIDidFetchData = Notification.Name(rawValue: "_AEFetchAPIDidFetchData")
}

// MARK: - _AEArticles Class Definition

/// パース用のラッパー
private class _AEArticles: Codable {
    let articles:[AEArticle]
}
