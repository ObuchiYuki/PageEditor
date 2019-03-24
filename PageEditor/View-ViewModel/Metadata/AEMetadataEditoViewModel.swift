//
//  AEMetadataEditoViewModel.swift
//  PageEditor
//
//  Created by yuki on 2019/03/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit


protocol AEMetadataEditoViewModelBinder:class {
    func changeThumbnailImage(to image:UIImage)
    func changeTextFieldTitle(to title:String)
    func showCameraRoll(_ completion:@escaping (UIImage)->Void)
}
class AEMetadataEditoViewModel<Binder:AEMetadataEditoViewModelBinder> {
    private weak var binder:Binder!
    
    private var _editingArtilce = AEEditorManager.default.getCurrentArticle()
    
    func changeImageButtonPushed(){
        binder.showCameraRoll{image in
            self.binder.changeThumbnailImage(to: image)
            
            AENakamichiAPI.default.uploadImage(with: image.pngData()!){url in
                self._editingArtilce?.thumbUrl = url
                
                AEEditorManager.default.uploadCurrentArticle()
            }
        }
    }
    func viewWillDismiss(){
        
    }
    
    init(binder:Binder){
        self.binder = binder
    }
}
