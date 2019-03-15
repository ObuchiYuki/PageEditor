//
//  AEEditableArticleNode.swift
//  PageEditor
//
//  Created by yuki on 2019/03/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class AEArticleNode {
    enum NodeType {
        case image
        case paragraph
        case headline
        case name
    }
    let nodeType:NodeType
    
    init(nodeType:NodeType) {
        self.nodeType = nodeType
    }
}

class AEImageArticleNode: AEArticleNode {
    var src:String
    
    init(src:String) {
        self.src = src
        super.init(nodeType: .image)
    }
}

class AEParagraphArticleNode: AEArticleNode {
    var text:String
    
    init(text:String) {
        self.text = text
        super.init(nodeType: .paragraph)
    }
}

class AEHeadlineArticleNode: AEArticleNode {
    var text:String
    var level:HeadLineLevel
    
    enum HeadLineLevel:String {
        case h1, h2, h3, h4, h5, h6
        
        static func fromTag(_ tag:String) -> HeadLineLevel{
            return HeadLineLevel(rawValue: tag)!
        }
    }
    
    init(text:String, level:HeadLineLevel) {
        self.text = text
        self.level = level
        
        super.init(nodeType: .headline)
    }
}

class AENameArticleNode: AEArticleNode {
    var text:String
    
    init(text:String) {
        self.text = text
        
        super.init(nodeType: .name)
    }
}
