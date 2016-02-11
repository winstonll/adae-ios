//
//  TransactionTableViewCell.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-30.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var item_image: UIImageView!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var seller_name: UILabel!
    
    @IBOutlet weak var title_text: UILabel!
    
    @IBOutlet weak var cancel_button: UIButton!
    
    @IBOutlet weak var time_frame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
