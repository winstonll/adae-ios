//
//  MessageTableViewcell.swift
//  adae
//
//  Created by Atsushi Hirata on 2016-03-31.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var user_avatar: UIImageView!
    
    @IBOutlet weak var conversation_title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
