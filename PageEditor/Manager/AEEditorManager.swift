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
    private var _editingArticleIndex:Int? = nil
    
    func updataArticle(to article:AEEditableArticle?=nil){
        if let newArticle = article?.uneditableArticle{
            if _editingArticle == nil{
                _editingArticle = newArticle
            }else{
                _editingArticle?.copy(other: newArticle)
            }
        }
        
        NotificationCenter.default.post(name: .AEEditorManagerArticleEdited, object: _editingArticle)
    }
    func uploadCurrentArticle(){
        guard
            let editingArticle = _editingArticle,
            let editingArticleIndex = _editingArticleIndex
            else {return}
            
        AENakamichiAPI.default.edit(editingArticle, at: editingArticleIndex) {}
    }
    
    func setCurrentEditingArticle(_ article:AEArticle, with index:Int){
        _editingArticle = article
        _editingArticleIndex = index
        NotificationCenter.default.post(name: .AEEditorManagerEditingArticleChanged, object: article)
    }
    
    func getCurrentEditableArticle() -> AEEditableArticle? {
        return _editingArticle.map{AEEditableArticle(article: $0)}
    }
    
    func getCurrentArticle() -> AEArticle? {
        return _editingArticle
    }
    
    func getCurrentEditingIndex() -> Int{
        return self._editingArticleIndex ?? 0
    }
}

extension Notification.Name{
    static let AEEditorManagerEditingArticleChanged = Notification.Name("_AEEditorManagerEditingArticleChanged")
    static let AEEditorManagerArticleEdited = Notification.Name("_AEEditorManagerArticleEdited")
}
