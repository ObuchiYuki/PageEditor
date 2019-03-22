//
//  AEEditorNameCell.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEEditorNameCell: AEEditorCell {

    @IBOutlet private weak var _textField: UITextField!
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        (self.data as! AEEditorNameCellData).text = sender.text ?? ""
        self.sendEditedNotification()
    }
    @IBAction func _removeButtonDidPush(_ sender: UIButton) {
        self.sendRemovedNotification()
    }
    
    func setName(_ name:String){
        self._textField.text = name
    }
}

extension AEEditorNameCell{
    static let identifier = "AEEditorNameCell"
    static let nib = UINib(nibName: "AEEditorNameCell", bundle: .main)
    static let height:CGFloat = 54
}

