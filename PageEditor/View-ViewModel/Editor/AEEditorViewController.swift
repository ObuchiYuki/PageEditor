//
//  AEEditorViewController.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import WebKit

class AEEditorViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    let viewModel = AEEditorViewModel()
    
    override func viewDidLoad() {
        viewModel.viewDidLoad(self)
        //self.view = WKWebView(frame: self.view.frame, configuration: .init())
    }
}

extension AEEditorViewController: AEEditorViewModelBinder{
    func setHtml(with html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
}
