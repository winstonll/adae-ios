//
//  Message.swift
//  adae
//
//  Created by Atsushi Hirata on 2016-04-18.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit

class Message {
    // MARK: Properties
    
    var text: String
    var senderId: String
    var senderDisplayName: String
    var created_at: NSDate
    
    init(text: String, senderId: String, senderDisplayName: String, created_at: NSDate) {
        self.text = text
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.created_at = created_at
    }
}
