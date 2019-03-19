//
//  Article.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// 記事データを取り回すためのデータクラスです。
struct AEArticle: Codable{
    /// UUID常にサーバー側のUUIDと一致しているわけでわありません。
    /// ロジック用ではなくjsonパース用です。
    let uuid:String
    let thumbUrl:String
    let title:String
    let createdDate:String
    let content:String
}

extension AEArticle: Equatable{
    static func == (left:AEArticle, right:AEArticle) -> Bool{
        return left.uuid == right.uuid
    }
}
