//
//  AEEditorHeadlineCell.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEEditorHeadlineCell: AEEditorCell {

    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _segmentControle: UISegmentedControl!
    
    @IBAction func textFieldTextChanged(_ sender: UITextField) {
        let data = self.data as! AEEditorHeadlineCellData
        data.text = sender.text ?? ""
        
        self.sendEditedNotification()
    }
    @IBAction func segmentControleSelectedItemChanged(_ sender: UISegmentedControl) {
        let data = self.data as! AEEditorHeadlineCellData
        data.level = self._convertIndexToLevel(with: sender.selectedSegmentIndex)
        
        self.sendEditedNotification()
    }
    @IBAction func _removeButtonDidPush(_ sender: Any) {
        self.sendRemovedNotification()
    }
    func setTitle(_ title:String){
        self._textField.text = title
    }
    func setLevel(_ level:AEEditorHeadlineCellData.HeadLineLevel){
        self._segmentControle.selectedSegmentIndex = _convertLevelToIndex(with: level)
    }
    private func _convertLevelToIndex(with level:AEEditorHeadlineCellData.HeadLineLevel) -> Int{
        switch level {
        case .h1: return 0
        case .h2: return 1
        case .h3: return 2
        case .h4: return 3
        case .h5: return 4
        case .h6: return 5
        }
    }
    
    private func _convertIndexToLevel(with index:Int) -> AEEditorHeadlineCellData.HeadLineLevel{
        switch index {
        case 0: return .h1
        case 1: return .h2
        case 2: return .h3
        case 3: return .h4
        case 4: return .h5
        case 5: return .h6
            
        default: return .h3
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
extension AEEditorHeadlineCell{
    static let identifier = "AEEditorHeadlineCell"
    static let nib = UINib(nibName: "AEEditorHeadlineCell", bundle: .main)
    static let height:CGFloat = 100
}
