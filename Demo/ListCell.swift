//
//  ListCell.swift
//  Demo
//
//  Created by Rea Won Kim on 3/24/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
        
    }

    override func draw(_ rect: CGRect) {
        iconImage.clipsToBounds = true
        iconImage.layer.masksToBounds = true
        iconImage.layer.cornerRadius = iconImage.layer.frame.size.width / 2
    }

}
