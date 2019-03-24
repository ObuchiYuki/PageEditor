//
//  AEMasterViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - AEMasterViewModelBinder Definition
protocol AEMasterViewModelBinder:class {
    func reloadAllData()
    func reloadData(at indexes:[Int])
    func removeItem(at index:Int)
    func changeEditMode(on: Bool)
    func showAlert(with message:String)
    func endRefreshing()
}

// MARK: - AEMasterViewModel Class Definition

/// AEMasterViewのViewModel
class AEMasterViewModel<Binder:AEMasterViewModelBinder> {
    
    // MARK: - AEMasterViewModel Properties
    var binder:Binder!
    
    // MARK: - AEMasterViewModel Private Properties
    private var _articles = [AEArticle]()
    private var _articleImageDataBuffer = [Int: Data]()
    
    // MARK: - AEMasterViewModel API
    
    /// View側のviewDidLoadから呼び出してください。
    func viewDidLoad(){
        reloadArticles()
    }
    
    func didEditModeButtonPush(){
        binder?.changeEditMode(on: true)
    }
    
    func reloadArticles(){
        AENakamichiAPI.default.fetch{articles in
            self._didFetchArticles(articles)
        }
    }
    
    func createNewArticle(for title:String){
        let newArticle = AEArticle(uuid: "", thumbUrl: "", title: title, createdDate: _createCurrentDateString(), content: "")
        self._articles.insert(newArticle, at: 0)
        
        binder?.reloadAllData()
        
        AENakamichiAPI.default.add(newArticle) {}
    }
    
    func removeArticle(at index:Int){
        let removedArticle = self._articles.remove(at: index)
        binder?.removeItem(at: index)
        binder?.showAlert(with: "記事「\(removedArticle.title)」を削除しました。")
        
        AENakamichiAPI.default.remove(at: _reverceIndex(from: index)) {}
    }
    
    /// TableViewに表示するセル数を返します。
    func cellCount() -> Int{
        return self._articles.count
    }
    
    /// TableViewに表示するセルのデータを返します。
    func cellData(for index:Int) -> AEMasterViewArticleCellData{
        let article = self._articles[index]
        let imageData = _articleImageDataBuffer[index]
        
        return AEMasterViewArticleCellData(title: article.title, subTitle: article.createdDate, imageData: imageData)
    }
    
    /// セルが選択された時に呼び出してください。
    func didSelectRow(at index:Int){
        let article = self._articles[index]
        AEEditorManager.default.setCurrentEditingArticle(article, with: _reverceIndex(from: index)-1)
    }
    
    
    init(_ binder:Binder) {
        self.binder = binder
        NotificationCenter.default.addObserver(forName: .AEEditorManagerArticleEdited){object in
            self.binder.reloadData(at: [AEEditorManager.default.getCurrentArticle()])
        }
    }
    private func _startImageLoading(){
        for (i, article) in _articles.enumerated(){
            
            Alamofire.request(article.thumbUrl).response{res in
                guard let data = res.data else {return}
                
                self._articleImageDataBuffer[i] = data
                self.binder?.reloadData(at: [i])
            }
        }
    }
    
    private func _createCurrentDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'年'MM'月'dd'日'"
        
        return formatter.string(from: Date())
    }
    
    private func _reverceIndex(from index:Int) -> Int{
        return _articles.count - index
    }
    
    private func _didFetchArticles(_ articles:[AEArticle]){
        self._articles = articles.reversed()
        
        binder?.reloadAllData()
        
        self._startImageLoading()
    }
}

struct AEMasterViewArticleCellData {
    let title:String
    let subTitle:String
    
    let imageData:Data?
}


