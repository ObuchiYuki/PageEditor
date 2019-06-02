//
//  AEArticleConverter.swift
//  PageEditor
//
//  Created by yuki on 2019/03/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import Ji

private typealias HTMLNode = JiNode
private typealias HTMLPage = Ji

class _AEArticleConverter{
    static let `default` = _AEArticleConverter()
    func parse(_ article:AEArticle) -> (title:String, date:Date, nodes:[AEArticleNode]){
        
        let title = article.title
        let date = self._parseDate(article.createdDate)
        let nodes = self._parseContent(article.content)
        
        return (title, date, nodes)
    }
    
    func unparse(_ article:AEEditableArticle) -> AEArticle{
        let uuid = article.uuid
        let title = article.title
        let thumbUrl = article.thumbUrl
        let createdDate = _unparseDate(article.createdDate)
        let content = _unparseNodes(article.nodes)
        
        return AEArticle.init(uuid: uuid, thumbUrl: thumbUrl, title: title, createdDate: createdDate, content: content)
    }
    
    private func _unparseNodes(_ nodes:[AEArticleNode]) -> String{
        let converter = _AEArticleNodeConverter()
        return nodes.map{converter.convertNode(with: $0)}.joined(separator: "\n")
    }
    
    private var _page:HTMLPage?
    
    private func _unparseDate(_ data:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'年'MM'月'dd'日'"
        
        return dateFormatter.string(from: data)
    }
    private func _parseDate(_ date:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'年'MM'月'dd'日'"
        
        return dateFormatter.date(from: date)!
    }
    
    private func _parseContent(_ content:String) -> [AEArticleNode]{
        self._page = HTMLPage(htmlString: content)
        
        guard let body = self._page?.rootNode?.children[0] else {return []}
        
        let nodes = body.children
        let converter = _AEArticleHTMLNodeConverter()
        let editableNodes = converter.convertNodes(nodes)
        
        self._page = nil
        
        return editableNodes
    }
}

private class _AEArticleHTMLNodeConverter{
    func convertNodes(_ nodes:[JiNode]) -> [AEArticleNode]{
        return nodes.compactMap{
            self._convertNode($0)
        }
    }
    private func _convertNode(_ node:HTMLNode) -> AEArticleNode?{
        let tag = node.tag!
        
        switch tag{
        case "p":
            return AEParagraphArticleNode(text: node.content ?? "")
        case "img":
            return AEImageArticleNode(src: node.attributes["src"] ?? "")
        case "em":
            return AENameArticleNode(text: node.content ?? "")
        case "h1", "h2", "h3", "h4", "h5", "h6":
            return AEHeadlineArticleNode(text: node.content ?? "", level: .fromTag(tag))
        default:
            return nil
        }
    }
}
private class _AEArticleNodeConverter{
    func convertNode(with node:AEArticleNode) -> String{
        switch node.nodeType {
        case .paragraph:
            let node = node as! AEParagraphArticleNode
            return "<p>\(node.text)</p>"
        case .image:
            let node = node as! AEImageArticleNode
            return "<img src=\"\(node.src)\">"
        case .headline:
            let node = node as! AEHeadlineArticleNode
            let tag = node.level.rawValue
            return "<\(tag)>\(node.text)</\(tag)>"
        case .name:
            let node = node as! AENameArticleNode
            return "<em>\(node.text)</em>"
        }
    }
}
