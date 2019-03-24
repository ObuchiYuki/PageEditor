//
//  AEMetadataEditoViewController.swift
//  PageEditor
//
//  Created by yuki on 2019/03/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEMetadataEditoViewController: UIViewController {
    lazy var viewModel = AEMetadataEditoViewModel(binder: self)
    
    @IBOutlet var thumbnailImageView:UIImageView!
    @IBOutlet var titleTextField:UITextField!
    
    @IBAction func changeImageButtonPushed(_ sender: UIButton) {
        viewModel.changeImageButtonPushed()
    }
    
    @IBAction func doneButtonPushed(_ sender: UIButton) {
        self.dismiss()
    }
    
    override func dismiss() {
        super.dismiss()
        
        viewModel.viewWillDismiss()
    }
}

extension AEMetadataEditoViewController:AEMetadataEditoViewModelBinder{
    func changeThumbnailImage(to image: UIImage) {
        self.thumbnailImageView.image = image
    }
    
    func changeTextFieldTitle(to title: String) {
        self.titleTextField.text = title
    }
    
    func showCameraRoll(_ completion: @escaping (UIImage) -> Void) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.accessibilityElements = [completion]
            self.present(picker, animated: true, completion: nil)
        }
    }
}

extension AEMetadataEditoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        (picker.accessibilityElements![0] as! (UIImage) -> Void)(image)
        
        picker.dismiss()
    }
}
