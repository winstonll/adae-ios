
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
    
    let headerTitles = ["Current Transactions", "Completed Transactions"]
    
    var section_quantity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        if (section == 0) {
            header.contentView.backgroundColor = UIColor(red: 120/255, green: 205/255, blue: 27/255, alpha: 1.0) //make the background color light blue
            header.textLabel!.textColor = UIColor.whiteColor() //make the text white
            header.alpha = 0.5 //make the header transparent

        } else if (section == 1) {
            header.contentView.backgroundColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0) //make the background color light blue
            header.textLabel!.textColor = UIColor.whiteColor() //make the text white
            header.alpha = 0.5 //make the header transparent

        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            self.section_quantity = jsonObject["ongoing"].count
            return self.section_quantity
        }
        else if section == 1 {
            self.section_quantity = jsonObject["completed"].count
            return self.section_quantity
        }
        else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell", forIndexPath: indexPath) as! TransactionTableViewCell
        
        if indexPath.section == 0 {
            
            cell.title_text.text = String(self.jsonObject["item_og"][indexPath.item]["title"])
            
            cell.seller_name.text = String(self.jsonObject["user_og"][indexPath.item]["name"])
            
            cell.item_image.loadImageFromURLString( "https://adae.co" + String(self.jsonObject["item_og"][indexPath.item]["photo_url"]) )
            
            cell.avatar.loadImageFromURLString( "https://adae.co" + String(self.jsonObject["user_og"][indexPath.item]["photo_url"]) )
            
            if (String(self.jsonObject["item_og"][indexPath.item]["user_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))) {
                
                if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "rent"){
                    cell.title.text = "Renting To:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "sell") {
                    cell.title.text = "Selling To:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "timeoffer") {
                    cell.title.text = "Offering To:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "lease") {
                    cell.title.text = "Services To:"
                }
                
            }else {
                
                if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "rent"){
                    cell.title.text = "Renting From:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "sell") {
                    cell.title.text = "Buying From:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "timeoffer") {
                    cell.title.text = "Receiving From:"
                } else if (String(self.jsonObject["item_og"][indexPath.item]["listing_type"]) == "lease") {
                    cell.title.text = "Services From:"
                }
            }
        } else if indexPath.section == 1 {
            
            cell.title_text.text = String(self.jsonObject["item_co"][indexPath.item]["title"])
            
            cell.seller_name.text = String(self.jsonObject["user_co"][indexPath.item]["name"])
            
            cell.item_image.loadImageFromURLString( "https://adae.co" + String(self.jsonObject["item_co"][indexPath.item]["photo_url"]) )
            
            cell.avatar.loadImageFromURLString( "https://adae.co" + String(self.jsonObject["user_co"][indexPath.item]["photo_url"]) )
            
            if (String(self.jsonObject["item_co"][indexPath.item]["user_id"]) == String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))) {
                
                if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "rent"){
                    cell.title.text = "Renting To:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "sell") {
                    cell.title.text = "Selling To:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "timeoffer") {
                    cell.title.text = "Offering To:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "lease") {
                    cell.title.text = "Services To:"
                }
                
            }else {
                if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "rent"){
                    cell.title.text = "Renting From:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "sell") {
                    cell.title.text = "Buying From:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "timeoffer") {
                    cell.title.text = "Receiving From:"
                } else if (String(self.jsonObject["item_co"][indexPath.item]["listing_type"]) == "lease") {
                    cell.title.text = "Services From:"
                }
            }
        }
        return cell
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
        //pass the item transaction values to the next view, the tab controller
        if (segue.identifier == "transaction_segue") {
            self.tabBarController?.tabBar.hidden = true
            
            let tabBarController = segue.destinationViewController as! TransactionDetailTabBarController
            let svc = tabBarController.viewControllers![0] as! TransactionDetailController
            
            // Check the section that the row was selected in to determine which json to send to next page
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if indexPath.section == 0 {
                    let modified_json: Dictionary = ["item": self.jsonObject["item_og"][indexPath.row], "transaction": self.jsonObject["ongoing"][indexPath.row], "user": self.jsonObject["user_og"][indexPath.row]]
                    
                    svc.toPass = modified_json
                    
                } else if indexPath.section == 1 {
                    let modified_json: Dictionary = ["item": self.jsonObject["item_co"][indexPath.row], "transaction": self.jsonObject["completed"][indexPath.row], "user": self.jsonObject["user_co"][indexPath.row]]
                    
                    svc.toPass = modified_json
                }
            }
        }
    }
    
    func getTransactions(callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv"]
        let urlString = "https://adae.co/api/v2/transaction_detail/" + String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in

            self.jsonObject = JSON(data: data!)
            
            print(self.jsonObject)
                        
            callback?(isOk: true)
        }
        return "returned"
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        self.MyKeychainWrapper.mySetObject("", forKey:kSecValueData)
        self.MyKeychainWrapper.mySetObject("", forKey:kSecAttrAccount)
        
        self.MyKeychainWrapper.writeToKeychain()
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoggedIn")
        
        //let secondViewController:CompanionLoginViewController = CompanionLoginViewController()
        //self.presentViewController(secondViewController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("login") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func transactionRefresh(sender: AnyObject) {
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
}
