//
//  AEEditorImageCell.swift
//  PageEditor
//
//  Created by yuki on 2019/03/19.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEEditorImageCell: AEEditorCell {
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _changeButton: UIButton!
    
    @IBAction func changeButtonPushed(_ sender: UIButton) {
        
    }
    @IBAction func _removeButtonDidPush(_ sender: UIButton) {
        self.sendRemovedNotification()
    }
    
    func setImage(_ image:UIImage?){
        self._imageView.image = image
    }
}
extension AEEditorImageCell{
    static let identifier = "AEEditorImageCell"
    static let nib = UINib(nibName: "AEEditorImageCell", bundle: .main)
    static let height:CGFloat = 200
}
