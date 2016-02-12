
//
//  TransactionViewController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-28.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KFSwiftImageLoader

class TransactionViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
        
    var jsonObject: JSON = [
        ["name": "John", "age": 21],
        ["name": "Bob", "age": 35],
    ]
    
    let page_number = 1
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call back to see if we properly got the transactions from API
        self.getTransactions { (isOk) -> Void in
            if (isOk) {
                self.tableview.reloadData()
                print("async success")

            }else{
                print("async fail")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getTransactions { (isOk) -> Void in
            if (isOk) {
                self.tableview.reloadData()
                print("async success")
                
            }else{
                print("async fail")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonObject["transaction"].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell", forIndexPath: indexPath) as! TransactionTableViewCell
        
        cell.title_text.text = String(self.jsonObject["item"][indexPath.item]["title"])
        
        cell.seller_name.text = String(self.jsonObject["user"][indexPath.item]["name"])
        
        cell.item_image.loadImageFromURLString( "https://adae.co" + String(self.jsonObject["item"][indexPath.item]["photo_url"]) )
        
        if (String(self.jsonObject["item"][indexPath.item]["user_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))) {
            
            if (String(self.jsonObject["item"][indexPath.item]["listing_type"]) == "rent"){
                cell.title.text = "Renting To:"
            } else if (String(self.jsonObject["item"][indexPath.item]["listing_type"]) == "sell") {
                cell.title.text = "Selling To:"
            }
            
        }else {
            
            if (String(self.jsonObject["item"][indexPath.item]["listing_type"]) == "rent"){
                cell.title.text = "Renting From:"
            } else if (String(self.jsonObject["item"][indexPath.item]["listing_type"]) == "sell") {
                cell.title.text = "Buying From:"
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
        //pass the item transaction values to the next view, the tab controller
        if (segue.identifier == "transaction_segue") {
            
            let tabBarController = segue.destinationViewController as! TransactionDetailTabBarController
            let svc = tabBarController.viewControllers![0] as! TransactionDetailController
            
            let selectedRow = tableView.indexPathForSelectedRow!.row
                        
            let modified_json: Dictionary = ["item": self.jsonObject["item"][selectedRow], "transaction": self.jsonObject["transaction"][selectedRow], "user": self.jsonObject["user"][selectedRow]]
            
            svc.toPass = modified_json
            
        }
    }
    
    func getTransactions(callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv"]
        let urlString = "https://adae.co/api/v1/transaction_detail/" + String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in

            self.jsonObject = JSON(data: data!)
                        
            callback?(isOk: true)
        }
        return "returned"
    }
}
