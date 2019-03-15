//
//  AEEditableArticle.swift
//  PageEditor
//
//  Created by yuki on 2019/03/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class AEEditableArticle {
    var title:String
    var createdDate:Date
    var nodes:[AEArticleNode]
    
    init(title:String, createdDate:Date, nodes: [AEArticleNode]) {
        self.title = title
        self.createdDate = createdDate
        self.nodes = nodes
    }
}
