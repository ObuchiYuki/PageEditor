//
//  AENakamichiAPI.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import Alamofire


private let API_SEVER_URL = "https://snakamichi.com/cgi-bin/article_api.py"
// MARK: - AENakamichiAPI Class Definition

/** サーバーから記事データを取ってくる
*/
class AENakamichiAPI {
    
    // MARK: - Singleton
    static let `default` = AENakamichiAPI()
    
    // MARK: - AENakamichiAPI Methods
    
    /// 記事取得を開始します。
    /// 完了時に通知 `AENakamichiAPIDidFetchData` が送られます。
    func fetch(_ completion: @escaping ([AEArticle]) -> Void ){
        _postRequest(form: ["method":"get"]){data in
            let articles = self._decodeData(with: data)
            
            completion(articles)
        }
    }
    
    /// 記事を削除します。
    /// 完了後 `completion`を呼びます。
    func remove(at index:Int, _ completion: @escaping () -> Void ){
        _postRequest(form: ["method": "remove"]){_ in
            completion()
        }
    }
    
    /// 引数`article`に設定した記事をサーバーに追加します。
    /// 完了後`completion`を呼びます。
    func add(_ article:AEArticle, _ completion: @escaping () -> Void){
        let form =  [
            "method":"add",
            "title": article.title,
            "thumb_url": article.thumbUrl,
            "content": article.content,
            "created_date": article.createdDate
        ]
        _postRequest(form: form){_ in
            completion()
        }
    }
    
    /// 引数`index`に指定した番号の記事を編集します。
    /// 完了後`completion`呼びだします。
    func edit(_ article:AEArticle, at index:Int, _ completion: @escaping ()->Void){
        let form = [
            "method": "edit",
            "title": article.title,
            "thumb_url": article.thumbUrl,
            "content": article.content,
            "created_date": article.createdDate
        ]
        _postRequest(form: form){_ in
            completion()
        }
    }
    
    // MARK: - AENakamichiAPI Private Methods
    private func _postRequest(form:[String:String] ,_ completion: @escaping (Data)-> Void){
        Alamofire.upload(multipartFormData: {multipartFormData in
            form.forEach{ multipartFormData.append($1.data(using: .utf8)!, withName: $0) }
            
        }, to: API_SEVER_URL){result in
            switch result{
            case .success(let upload, _, _):
                upload.response{res in
                    
                    guard let data = res.data else {return}
                    completion(data)
                }
            case .failure(let e):
                print(e)
            }
        }
    }
    
    private func _decodeData(with data:Data) -> [AEArticle]{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let json = try? decoder.decode(_AEArticles.self, from: data) else {return []}
        return json.articles
    }
}
// MARK: - _AEArticles Class Definition

/// パース用のラッパー
private class _AEArticles: Codable {
    let articles:[AEArticle]
}
