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
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let secondTab = self.tabBarController?.viewControllers![1] as! QRCodeViewController
        secondTab.toPass = self.toPass
        
        if String(self.toPass["transaction"]!["seller_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount)) {
            
            if String(self.toPass["item"]!["listing_type"]) == "sell" {
                requestTitle.text =  String(self.toPass["user"]!["name"]).capitalizedString + " would like to buy"
                instructionLabel.text = "Make sure to have the unique QR code scanned by the other party when they pick up your item, you will be paid upon QR code scanning."
            } else if ["rent", "lease"].contains(String(self.toPass["item"]!["listing_type"])) {
                requestTitle.text =  String(self.toPass["user"]!["name"]).capitalizedString + " would like to try"
                instructionLabel.text = "Only one QR code scan is needed. Payment will be sent whenever this scan occurs."
            } else if String(self.toPass["item"]!["listing_type"]) == "timeoffer" {
                requestTitle.text =  String(self.toPass["user"]!["name"]).capitalizedString + " would like to try"
                instructionLabel.text = "Make sure to have the unique QR code scanned by the other party at the beginning of your service, they must scan it again at the end of your service."
            }
        } else {
            if String(self.toPass["item"]!["listing_type"]) == "sell" {
                requestTitle.text = "You requested to buy"
                instructionLabel.text = "Make sure to have the in-app QR Scanner open when you meet. Scan the QR code on their phone to confirm your transaction."
            } else if ["rent", "lease"].contains(String(self.toPass["item"]!["listing_type"])) {
                requestTitle.text = "You requested to try"
                instructionLabel.text = "Only one QR code scan is needed. Payment will be sent whenever this scan occurs."
            } else if String(self.toPass["item"]!["listing_type"]) == "timeoffer" {
                requestTitle.text = "You requested to try"
                instructionLabel.text = "Make sure to have the in-app QR Scanner open when you meet. Scan the QR code on their phone at the start & end of the service."
            }
        }
        
        statusLabel.text = String(self.toPass["transaction"]!["status"])
        
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
