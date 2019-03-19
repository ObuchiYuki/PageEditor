//
//  AEMasterTableViewCell.swift
//  PageEditor
//
//  Created by yuki on 2019/03/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEMasterTableViewCell: UITableViewCell {
    
    static let identifier:String = "article_cell"
    
    func setImage(_ image:UIImage?){
        (self.viewWithTag(1) as! UIImageView).image = image
    }
    func setTitle(_ title:String){
        (self.viewWithTag(2) as! UILabel).text = title
    }
    func setSubtitle(_ subtitle:String){
        (self.viewWithTag(3) as! UILabel).text = subtitle
    }
}

extension UINib{
    static let masterArticleCell = UINib(nibName: "AEMasterTableViewCell", bundle: .main)
}
