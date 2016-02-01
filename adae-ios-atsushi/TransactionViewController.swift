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

class TransactionViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let myarray = ["item1", "item2", "item3"]
    
    /**var images = [JSON]()
    
    var items = [JSON]()
    
    var users = [JSON]()**/
    
    var jsonObject: JSON = [
        ["name": "John", "age": 21],
        ["name": "Bob", "age": 35],
    ]

    
    let page_number = 1
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getTransactions { (isOk) -> Void in
            if (isOk) {
                
                self.tableview.reloadData()

                print("async success")

            }else{
                print("async fail")
            }
        }
        
        print("Inside of Transaction Controller")
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
        
        cell.description_text.text = String(self.jsonObject["item"][indexPath.item]["description"])
        
        cell.seller_name.text = String(self.jsonObject["user"][indexPath.item]["name"])
        
        if (String(self.jsonObject["item"][indexPath.item]["user_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))) {
            cell.title.text = "Renting To:"
        }else {
            cell.title.text = "Leasing From:"
        }
        
        return cell
    }
    
    func getTransactions(callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "H4LvhkAw3vooYosNS98S"]
        let urlString = "https://adae.co/api/v1/transactions/" + String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            //let json = JSON(data: data!)
            
            self.jsonObject = JSON(data: data!)
            
            print("JSONNN!!!!!!!!!!!")
            print(self.jsonObject)
            
            callback?(isOk: true)
        }
        return "returned"
    }
}
