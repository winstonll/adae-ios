//
//  TransactionDetailController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-02-01.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransactionDetailController: UIViewController {
    
    var toPass = [String: JSON]()
    
    @IBOutlet weak var requestTitle: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let secondTab = self.tabBarController?.viewControllers![1] as! QRCodeViewController
        secondTab.toPass = self.toPass
        
        print("Inside of Transaction Detail Controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    

}
