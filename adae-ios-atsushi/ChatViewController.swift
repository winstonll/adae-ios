//
//  ChatViewController.swift
//  adae
//
//  Created by Atsushi Hirata on 2016-03-30.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var toPass = [String: JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.toPass)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
