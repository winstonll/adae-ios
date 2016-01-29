//
//  ListingViewController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-22.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListingViewController: UIViewController {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!

    
    var filter = "Listings in Toronto"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Inside of Listing View")
        
        navigationTitle.title = filter
        
        //connecting to adae API
        
        /**
        let headers = ["ApiToken": "H4LvhkAw3vooYosNS98S"]
        let urlString = "https://adae.co/api/v1/users"
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            print(res)
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
        }
        **/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
