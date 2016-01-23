//
//  ListingViewController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-22.
//  Copyright © 2016 adae. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ListingViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scrollview1: UIScrollView!
    @IBOutlet weak var navigationbar1: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //connecting to adae API
        let headers = ["ApiToken": "YB4BJGf_sb3dEqbej6LM"]
        let urlString = "https://adae.co/api/v1/users"
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            print(res)
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
