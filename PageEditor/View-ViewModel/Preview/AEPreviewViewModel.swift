//
//  AEPreviewViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol AEPreviewViewModelBinder:class {
    func setHtml(with html:String)
}

class AEPreviewViewModel {
    weak var binder:AEPreviewViewModelBinder?
    
    func viewDidLoad<Binder:AEPreviewViewModelBinder>(_ binder:Binder){
        self.binder = binder
        
        if let article = AEEditorManager.default.getCurrentArticle(){
            self._didUpdateArticle(article)
        }
    }
    
    private func _didUpdateArticle(_ article:AEArticle){
        let htmlString = _createHTMLString(for: article)
        
        binder?.setHtml(with: htmlString ?? "ERROR")
    }
    
    private func _createHTMLString(for article:AEArticle) -> String?{
        guard
            let templateFilePath = Bundle.main.path(forResource: "preview_html_template", ofType: "tpl") ,
            let templateFileContent = FileManager.default.contents(atPath: templateFilePath) ,
            var templateFileString = String(bytes: templateFileContent, encoding: .utf8) else {return nil}
        
        let content = article.content.isEmpty ? "<p>内容がまだありません。</p>" : article.content
        [
            "title": article.title,
            "content": content,
            "created_date": article.createdDate
        ].forEach{
            templateFileString = templateFileString.replacingOccurrences(of: "%{\($0)}%", with: $1)
        }
        
        return templateFileString
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AEEditorManagerDidSetEditingConfig, object: nil, queue: .main){notice in
            guard let article = notice.object as? AEArticle else {return}
            
            self._didUpdateArticle(article)
        }
    }
}
