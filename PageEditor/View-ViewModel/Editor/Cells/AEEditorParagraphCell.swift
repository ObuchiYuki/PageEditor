//
//  _AEEditorCells.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit


class AEEditorParagraphCell: AEEditorCell {
    @IBOutlet weak var _textView: UITextView!
    @IBOutlet weak var _removeButton: UIButton!
    
    @IBAction private func didRemoveButtonPush(_ sender:UIButton){
        self.sendRemovedNotification()
    }
    
    func setText(_ text:String){
        self._textView.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self._textView.delegate = self
        self._textView.layer.borderWidth = 0.5
        self._textView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension AEEditorParagraphCell:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let data = self.data as! AEEditorParagraphCellData
        data.text = textView.text
        sendEditedNotification()
    }
}

extension AEEditorParagraphCell{
    static let identifier = "AEEditorParagraphCell"
    static let nib = UINib(nibName: "AEEditorParagraphCell", bundle: .main)
    static let height:CGFloat = 200
}
