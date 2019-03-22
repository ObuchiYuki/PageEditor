//
//  AEEditorManager.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/*
 Editorの管理クラスです。
 ----通知----
 - AEEditorManagerEditingArticleChanged (object: AEArticle)
 */
class AEEditorManager {
    static let `default` = AEEditorManager()
    
    private var _editingArticle:AEArticle? = nil
    
    func updataArticle(to article:AEEditableArticle){
        let newArticle = article.uneditableArticle
        if _editingArticle == nil{
            _editingArticle = newArticle
        }else{
            _editingArticle?.copy(other: newArticle)
        }
        
        NotificationCenter.default.post(name: .AEEditorManagerArticleEdited, object: _editingArticle)
    }
    func setCurrentEditingArticle(_ article:AEArticle){
        _editingArticle = article
        print(article.title)
        NotificationCenter.default.post(name: .AEEditorManagerEditingArticleChanged, object: article)
    }
    
    func getCurrentEditableArticle() -> AEEditableArticle? {
        return _editingArticle.map{AEEditableArticle(article: $0)}
    }
    
    func getCurrentArticle() -> AEArticle? {
        return _editingArticle
    }
}

extension Notification.Name{
    static let AEEditorManagerEditingArticleChanged = Notification.Name("_AEEditorManagerEditingArticleChanged")
    static let AEEditorManagerArticleEdited = Notification.Name("_AEEditorManagerArticleEdited")
}
