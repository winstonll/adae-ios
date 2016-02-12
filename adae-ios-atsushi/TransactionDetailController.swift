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
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let secondTab = self.tabBarController?.viewControllers![1] as! QRCodeViewController
        secondTab.toPass = self.toPass
        
        if String(self.toPass["transaction"]!["seller_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount)) {
            
            requestTitle.text =  String(self.toPass["user"]!["name"]).capitalizedString + " would like to try"
        }
        if (String(self.toPass["transaction"]!["in_scan_date"]) != "null" && String(self.toPass["item"]!["listing_type"]) == "sell") ||
        (String(self.toPass["transaction"]!["out_scan_date"]) != "null" && String(self.toPass["item"]!["listing_type"]) != "sell"){
            statusLabel.text = "Complete"
        } else if ( String(self.toPass["transaction"]!["in_scan_date"]) != "null" && String(self.toPass["item"]!["listing_type"]) == "rent" &&
            String(self.toPass["transaction"]!["out_scan_date"]) == "null"){
            statusLabel.text = "Item Out"
        }
        
        descriptionLabel.text = String(self.toPass["item"]!["description"])
        
        priceLabel.text = "$" + String(self.toPass["transaction"]!["total_price"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    

}
