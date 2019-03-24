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
    
    func uploadImage(with pngImageData:Data, _ completion: @escaping (String)->Void){
        let form = [
            FormData(name: "method", value: "post_image"),
            FormData(name: "data", data: pngImageData, filename: "POST_IMAGE", mimeType: "image/png")
        ]
        self._postRequest(formData: form){data in
            guard let url = String(bytes: data, encoding: .utf8) else {return}
            
            completion(url)
        }
    }
    
    /// 記事を削除します。
    /// 完了後 `completion`を呼びます。
    func remove(at index:Int, _ completion: @escaping () -> Void ){
        _postRequest(form: ["method": "remove", "index": String(index)]){_ in
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
            "index": String(index),
            "title": article.title,
            "thumb_url": article.thumbUrl,
            "content": article.content,
            "created_date": article.createdDate
        ]
        _postRequest(form: form){data in
            completion()
        }
    }
    
    // MARK: - AENakamichiAPI Private Methods
    struct FormData{
        let name:String
        let data:Data
        let filename:String?
        let mimeType:String?
        
        init(name:String, value:String){
            self.init(name: name, data: value.data(using: .utf8)!)
            
        }
        init(name:String, data:Data,filename:String?=nil, mimeType:String?=nil) {
            self.name = name
            self.data = data
            self.filename = filename
            self.mimeType = mimeType
        }
    }
    private func _postRequest(form:[String:String] ,_ completion: @escaping (Data)-> Void){
        self._postRequest(formData: form.map{key, value in FormData(name: key, value: value)}, completion)
    }
    private func _postRequest(formData:[FormData],_ completion: @escaping (Data)-> Void){
        Alamofire.upload(multipartFormData: {multipartFormData in
            formData.forEach{
                switch ($0.filename, $0.mimeType){
                case (nil, nil):
                    multipartFormData.append($0.data, withName: $0.name)
                case let (nil, mimeType?):
                    multipartFormData.append($0.data, withName: $0.name, mimeType:mimeType)
                case let (filneme?, mimeType?):
                    multipartFormData.append($0.data, withName: $0.name, fileName: filneme, mimeType: mimeType)
                default: break
                }
            }
            
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
