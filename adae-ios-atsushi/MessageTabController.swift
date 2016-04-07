//
//  MessageTabController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-26.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageTabController: UITableViewController {
    

    @IBOutlet var tableview: UITableView!
    var jsonObject: JSON = [
    ["name": "John", "age": 21],
    ["name": "Bob", "age": 35],
    ]
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inside of Message Controller")
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = false
        
        self.getConversations { (isOk) -> Void in
            if (isOk) {
                self.tableview.reloadData()
                print(self.jsonObject)
                print("async success")
                
            }else{
                print("async fail")
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jsonObject.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        cell.conversation_title.text = String(self.jsonObject["user"][indexPath.item]["name"])
        
        cell.user_avatar.loadImageFromURLString(String(self.jsonObject["user"][indexPath.item]["photo_url"]))
        
        return cell
    }
    
    func getConversations(callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv", "Authorization": String(MyKeychainWrapper.myObjectForKey("v_Data"))]
        let urlString = "https://adae.co/api/v1/conversations"
            Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            
            self.jsonObject = JSON(data: data!)
            
            callback?(isOk: true)
        }
        return "returned"
    }

}

