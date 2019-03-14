//
//  AEEditorViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol AEEditorViewModelBinder:class {
    func setHtml(with html:String)
}

class AEEditorViewModel {
    weak var binder:AEEditorViewModelBinder?
    
    func viewDidLoad<Binder:AEEditorViewModelBinder >(_ binder:Binder){
        self.binder = binder
    }
    
    private func _didUpdateArticle(_ article:AEArticle){
        let html = """
        <!DOCTYPE html>
        <html>
        <head><meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://snakamichi.com/css/main-max.css"></head>
        <body>
        <main class="p-home_container">
        <div class="p-home_main">
        <div class="p-main_title_container">
        <h4 class="p-main_update_date">\(article.createdDate)</h4>
        </div>
        <div class="a-article">
        <h2>\(article.title)</h2>
        \(article.content)
        </div>
        </div>
        </main>
        </body>
        </html>
        """

        binder?.setHtml(with: html)
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AEEditorManagerDidSetEditingConfig, object: nil, queue: .main){notice in
            guard let article = notice.object as? AEArticle else {return}
            
            self._didUpdateArticle(article)
        }
    }
}
