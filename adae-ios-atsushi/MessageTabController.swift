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
    let myarray = ["item1", "item2", "item3"]
    let page_number = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inside of Message Controller")
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
        return myarray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) //as! UITableViewCell
        //cell.textLabel?.text = myarray[indexPath.item]
        return cell
    }
}

