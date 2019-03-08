//
//  AEMasterViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

// MARK: - AEMasterViewModelBinder Definition
protocol AEMasterViewModelBinder:class {
    func reloadAllData()
    func reloadData(at indexes:[Int])
}

// MARK: - AEMasterViewModel Class Definition

/// AEMasterViewのViewModel
class AEMasterViewModel {
    
    // MARK: - AEMasterViewModel Properties
    var binder:AEMasterViewModelBinder?
    
    // MARK: - AEMasterViewModel Private Properties
    private var _articles = [AEArticle]()
    
    // MARK: - AEMasterViewModel API
    
    // MARK: - Common
    /// View側のviewDidLoadから呼び出してください。
    func viewDidLoad<Binder: AEMasterViewModelBinder>(_ binder:Binder){
        self.binder = binder
        
        AEFetchAPI.default.startFetching()
    }
    
    // MARK: - View Showing Methods
    
    /// TableViewに表示するセル数を返します。
    func cellCount() -> Int{
        return self._articles.count
    }
    
    /// TableViewに表示するセルのデータを返します。
    func cellData(for index:Int) -> AEMasterViewArticleCellData{
        let article = self._articles[index]
        
        return AEMasterViewArticleCellData(title: article.title, subTitle: article.createdDate)
    }
    
    // MARK: - View Editing Methods
    
    /// 引数`index`で指定した行の記事を削除します。 (サーバーから)
    func removeArticle(at index:Int){
        
    }
    
    /// 新たな記事を追加します。(サーバーに)
    func addNewArticle(){
        
    }
    
    private func _didFetchArticles(_ articles:[AEArticle]){
        self._articles = articles
        binder?.reloadAllData()
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AEFetchAPIDidFetchData, object: nil, queue: .main){[weak self] notice in
            guard let articles = notice.object as? [AEArticle] else {return}
            self?._didFetchArticles(articles)
        }
    }
}

struct AEMasterViewArticleCellData {
    let title:String
    let subTitle:String
}


