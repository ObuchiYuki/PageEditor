//
//  AEEditorCell.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEEditorCell: UITableViewCell {
    var data:_AEEditorCellData!
    
    func setDefaultData(_ data:_AEEditorCellData){
        self.data = data
    }
    
    func sendRemovedNotification(){
        NotificationCenter.default.post(name: .AEEditorCellRemoveButtonPush, object: self)
    }
    
    func sendEditedNotification(){
        NotificationCenter.default.post(name: AEEditorCell.dataChangedNotification, object: self)
    }
}

extension AEEditorCell{
    /// (object=self)
    static let dataChangedNotification = Notification.Name(rawValue: "_AEEditorCellDataChangedNotification")
}
extension Notification.Name{
    /// (object=self)
    static let AEEditorCellRemoveButtonPush = Notification.Name(rawValue: "_AEEditorCellRemoveButtonPush")
}
