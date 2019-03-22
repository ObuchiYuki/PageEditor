//
//  AEEditableArticle.swift
//  PageEditor
//
//  Created by yuki on 2019/03/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

struct AEEditableArticle {
    var title:String
    var uuid:String
    var thumbUrl:String
    var createdDate:Date
    var nodes:[AEArticleNode]
    
    var uneditableArticle:AEArticle{
        return _AEArticleConverter.default.unparse(self)
    }
    
    init(title:String,uuid:String,thumbUrl:String, createdDate:Date, nodes: [AEArticleNode]) {
        self.title = title
        self.uuid = uuid
        self.thumbUrl = thumbUrl
        self.createdDate = createdDate
        self.nodes = nodes
    }
    
    init(article:AEArticle) {
        let (title, date, nodes) = _AEArticleConverter.default.parse(article)
        
        self.init(title: title,uuid:article.uuid,thumbUrl:article.thumbUrl, createdDate: date, nodes: nodes)
    }
}
