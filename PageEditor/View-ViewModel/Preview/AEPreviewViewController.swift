//
//  AEPreviewViewController.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit
import WebKit

class AEPreviewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    let viewModel = AEPreviewViewModel()
    
    override func viewDidLoad() {
        viewModel.viewDidLoad(self)
    }
}

extension AEPreviewViewController: AEPreviewViewModelBinder{
    func setHtml(with html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
}
