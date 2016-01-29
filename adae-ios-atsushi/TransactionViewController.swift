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
    
    var images = [String]()
    
    var items = [String]()
    
    let page_number = 1
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTransactions { (isOk) -> Void in
            if (isOk) {
                print("async success")
            }else{
                print("async fail")
            }

        }
        
        print("Inside of Transaction Controller")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell", forIndexPath: indexPath) //as! UITableViewCell
        //cell.textLabel?.text = myarray[indexPath.item]
        print("!!!!!!!!!!!!!!!!!!!!!!")
        print(self.images)
        print(indexPath.item)
        
        
        /**cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        let url = NSURL(string: self.images[indexPath.item])
        let data = NSData(contentsOfURL: url!)
        cell.imageView?.image = UIImage(data: data!)**/
        
        //cell.imageView?.image = UIImageView(self.images[indexPath.item])
        return cell
    }
    
    func getTransactions(callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "H4LvhkAw3vooYosNS98S"]
        let urlString = "https://adae.co/api/v1/transactions/" + String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            let json = JSON(data: data!)
            
            for (_, object) in json {
                self.items.append(String(object["item_id"]))
                print(self.items)
            }
            
            for item in self.items {
                let urlItem = "https://adae.co/api/v1/items/" + item
                Alamofire.request(.GET, urlItem, headers: headers).response { (req, res, data, error) -> Void in
                    let json = JSON(data: data!)
                    
                    self.images.append("https://adae.co/system/uploads/" + String(json["image"]))
                    print(json)
                    print(self.images)
                    
                    callback?(isOk: true)
                    print("returned")
                }
                
            }
        }
        return "returned"
    }

}
