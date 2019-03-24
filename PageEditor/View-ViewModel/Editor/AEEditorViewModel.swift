//
//  AEEditorViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import CoreGraphics
import Alamofire

protocol AEEditorViewModelBinder:class {
    func showCameraRoll(_ completion:@escaping (UIImage) -> Void)
    func reloadCells(at rows:[Int])
    func reloadAllCells()
    func appendCell(at row:Int)
    func removeCell(at row:Int)
}

///管理はCellDataでやってそれを同期するイメージで
class AEEditorViewModel{
    // MARK: - Binder
    private weak var binder:AEEditorViewModelBinder!
    
    // MARK: - AEEditorViewModel Properties
    private var _imageDataBuffer = [String:Data]()
    
    private var _editingArticle:AEEditableArticle! = nil
    
    private var _cellDataBuffer:[_AEEditorCellData]!
    
    // MARK: - AEEditorViewModel API
    func viewDidLoad<T:AEEditorViewModelBinder>(_ binder:T){
        self.binder = binder
        
        self._editingArticle = AEEditorManager.default.getCurrentEditableArticle()!
        self._cellDataBuffer = self._createCellDataBuffer(with: _editingArticle.nodes)
        
        for (i, cellData) in _cellDataBuffer.enumerated(){
            guard let imageData = cellData as? AEEditorImageCellData else {continue}

            self._getImage(for: imageData.src){[weak self] data in
                guard let self = self else {return}
                
                imageData.imageData = data
                self.binder.reloadCells(at: [i])
            }
        }
    }
    
    func cellCount() -> Int{
        return _cellDataBuffer.count
    }
    
    func cellData(for row:Int) -> _AEEditorCellData{
        return _cellDataBuffer[row]
    }
    
    func cellHeight(for row:Int) -> CGFloat{
        let node = self._cellDataBuffer[row]
        switch node.nodeType {
        case .paragraph:
            return AEEditorParagraphCell.height
        case .image:
            return AEEditorImageCell.height
        case .headline:
            return AEEditorHeadlineCell.height
        case .name:
            return AEEditorNameCell.height
        }
    }
    
    func cellIdetifier(for row:Int) -> String{
        let node = self._cellDataBuffer[row]
        
        switch node.nodeType {
        case .paragraph: return AEEditorParagraphCell.identifier
        case .image: return AEEditorImageCell.identifier
        case .headline: return AEEditorHeadlineCell.identifier
        case .name: return AEEditorNameCell.identifier
        }
    }
    
    func addItem(for type:AEEDitorCellNodeType){
        switch type {
        case .paragraph:
            self._appendData(AEEditorParagraphCellData(text: "内容未入力"))
        case .image:
            self._appendData(AEEditorImageCellData(src: "https://snakamichi.com/img/no_image.jpg"))
        case .headline:
            self._appendData(AEEditorHeadlineCellData(text: "見出し未入力", level: .h3))
        case .name:
            self._appendData(AEEditorNameCellData(text: "氏名未入力"))
        }
        
        AEEditorManager.default.updataArticle(to: _editingArticle)
        binder.appendCell(at: self._cellDataBuffer.count-1)
    }

    // MARK: - AEEditorViewModel Private Methods
    private func _getImage(for url:String,_ completion:@escaping (Data)->Void){
        request(url).response{res in
            guard let data = res.data else {return}
            completion(data)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AEEditorCellRemoveButtonPush, object: nil, queue: .main){[weak self] notice in
            guard let cell = notice.object as? AEEditorCell else {return}
            
            self?._didCellRemoveButtonPush(with: cell)
        }
        NotificationCenter.default.addObserver(forName: AEEditorCell.dataChangedNotification, object: nil, queue: .main){[weak self] notice in
            guard let cell = notice.object as? AEEditorCell else {return}
            
            self?._didCellDataChanged(with: cell)
        }
        NotificationCenter.default.addObserver(forName: .AEEditorImageCellChangeButtonPushed, object: nil, queue: .main){[weak self] notice in
            guard let cell = notice.object as? AEEditorImageCell else {return}
            
            self?._didImageCellChageButtonPushed(cell)
        }
    }
    
    private func _didImageCellChageButtonPushed(_ cell:AEEditorImageCell){
        binder.showCameraRoll{image in
            cell.editImage(image)
            
            AENakamichiAPI.default.uploadImage(with: image.pngData()!){url in
                (cell.data as! AEEditorImageCellData).src = url
                self._didCellDataChanged(with: cell)
            }
        }
    }
    
    private func _didCellDataChanged(with cell:AEEditorCell){
        let data = cell.data!
        
        let editedIndex = self._cellDataBuffer.firstIndex(of: data)!
        self._editData(to: data, at: editedIndex)
    
        AEEditorManager.default.updataArticle(to: _editingArticle)
    }
    
    private func _didCellRemoveButtonPush(with cell:AEEditorCell){
        let removeIndex = self._cellDataBuffer.firstIndex(of: cell.data)!
        
        self._removeData(at:removeIndex)
        
        binder.removeCell(at: removeIndex)
        AEEditorManager.default.updataArticle(to: _editingArticle)
    }
    
    private func _editData(to cellData:_AEEditorCellData, at index:Int){
        self._removeData(at: index)
        self._insertData(cellData, at: index)
    }
    
    private func _insertData(_ cellData:_AEEditorCellData, at index:Int){
        let node = _convertCellDataToNode(with: cellData)
        
        self._cellDataBuffer.insert(cellData, at: index)
        self._editingArticle.nodes.insert(node, at: index)
    }
    
    private func _appendData(_ cellData:_AEEditorCellData){
        let node = _convertCellDataToNode(with: cellData)
        self._cellDataBuffer.append(cellData)
        self._editingArticle.nodes.append(node)
    }
    
    private func _removeData(at index:Int){
        self._cellDataBuffer.remove(at: index)
        self._editingArticle.nodes.remove(at: index)
    }
    
    private func _createCellDataBuffer(with nodes:[AEArticleNode]) -> [_AEEditorCellData]{
        return nodes.map{_convertNodeToCellData(with: $0)}
    }
    
    private func _convertNodeToCellData(with node:AEArticleNode) -> _AEEditorCellData{
        switch node.nodeType {
        case .paragraph:
            return AEEditorParagraphCellData(node: node as! AEParagraphArticleNode)
        case .headline:
            return AEEditorHeadlineCellData(node: node as! AEHeadlineArticleNode)
        case .name:
            return AEEditorNameCellData(node: node as! AENameArticleNode)
        case .image:
            return AEEditorImageCellData(node: node as! AEImageArticleNode, imageData: nil)
        }
    }
    private func _convertCellDataToNode(with cellData:_AEEditorCellData) -> AEArticleNode{
        switch cellData.nodeType {
        case .paragraph:
            return AEParagraphArticleNode(text: (cellData as! AEEditorParagraphCellData).text)
        case .image:
            return AEImageArticleNode(src: (cellData as! AEEditorImageCellData).src)
        case .headline:
            let data = cellData as! AEEditorHeadlineCellData
            return AEHeadlineArticleNode(text: data.text, level: AEHeadlineArticleNode.HeadLineLevel(rawValue: data.level.rawValue)!)
        case .name:
            return AENameArticleNode(text: (cellData as! AEEditorNameCellData).text)
        }
    }
}

enum AEEDitorCellNodeType {
    case image
    case paragraph
    case headline
    case name
}

class _AEEditorCellData {
    let nodeType:AEEDitorCellNodeType
    private var _identifier = UUID()
    
    init(nodeType:AEEDitorCellNodeType) {
        self.nodeType = nodeType
    }
}
extension _AEEditorCellData:Equatable{
    fileprivate func inherite(from otherCellData:_AEEditorCellData){
        self._identifier = otherCellData._identifier
    }
    static func == (right:_AEEditorCellData, left:_AEEditorCellData) -> Bool{
        return right._identifier == left._identifier
    }
}
class AEEditorImageCellData: _AEEditorCellData {
    var src:String
    var imageData:Data?
    
    init(src:String) {
        self.src = src
        self.imageData = nil
        
        super.init(nodeType: .image)
    }
    init(node: AEImageArticleNode, imageData:Data?) {
        self.src = node.src
        self.imageData = imageData
        super.init(nodeType: .image)
    }
}

class AEEditorParagraphCellData: _AEEditorCellData {
    var text:String
    
    init(text:String) {
        self.text = text
        super.init(nodeType: .paragraph)
    }
    init(node: AEParagraphArticleNode) {
        self.text = node.text.removed(by: .whitespacesAndNewlines)
        
        super.init(nodeType: .paragraph)
    }
}

class AEEditorHeadlineCellData: _AEEditorCellData {
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
    init(node: AEHeadlineArticleNode) {
        self.text = node.text
        self.level = HeadLineLevel(rawValue: node.level.rawValue)!
        
        super.init(nodeType: .headline)
    }
}

class AEEditorNameCellData: _AEEditorCellData {
    var text:String

    init(text:String) {
        self.text = text
        
        super.init(nodeType: .name)
    }
    init(node:AENameArticleNode) {
        self.text = node.text
        
        super.init(nodeType: .name)
    }
}
