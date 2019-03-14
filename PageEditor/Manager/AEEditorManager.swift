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
 - AEEditorManagerDidSetEditingConfig (object: AEArticle)
 */
class AEEditorManager {
    static let `default` = AEEditorManager()
    
    private var _editingArticle:AEArticle? = nil
    
    func setCurrentEditingArticle(_ article:AEArticle){
        _editingArticle = article
        NotificationCenter.default.post(name: .AEEditorManagerDidSetEditingConfig, object: article)
    }
    func getCurrentEditingArticle() -> AEArticle?{
        return _editingArticle
    }
}

extension Notification.Name{
    static let AEEditorManagerDidSetEditingConfig = Notification.Name("_AEEditorManagerDidSetEditingConfig")
}
