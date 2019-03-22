//
//  Article.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// 記事データを取り回すためのデータクラスです。
class AEArticle: Codable{
    /// UUID常にサーバー側のUUIDと一致しているわけでわありません。
    /// ロジック用ではなくjsonパース用です。
    var uuid:String
    var thumbUrl:String
    var title:String
    var createdDate:String
    var content:String
    
    func copy(other article:AEArticle){
        self.uuid = article.uuid
        self.thumbUrl = article.thumbUrl
        self.title = article.title
        self.createdDate = article.createdDate
        self.content = article.content
    }
    init(uuid:String,thumbUrl:String,title:String,createdDate:String,content:String) {
        self.uuid = uuid
        self.thumbUrl = thumbUrl
        self.title = title
        self.createdDate = createdDate
        self.content = content
    }
}

extension AEArticle: Equatable{
    static func == (left:AEArticle, right:AEArticle) -> Bool{
        return left.uuid == right.uuid
    }
}
