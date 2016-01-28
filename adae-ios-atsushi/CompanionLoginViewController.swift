//
//  CompanionLoginController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-27.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CompanionLoginViewController: UIViewController {
    
    @IBOutlet weak var privacy: UIButton!
    
    @IBOutlet weak var terms: UIButton!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login_button: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Inside of Companion Login Controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPrivacy(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://adae.co/privacy")!)
    }
    
    @IBAction func didTapTerms(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://adae.co/terms")!)
    }
    
    @IBAction func didLogin(sender: AnyObject) {
        print(email.text)
        print(password.text)
        
        let headers = ["ApiToken": "YB4BJGf_sb3dEqbej6LM"]
        let urlString = "https://adae.co/api/v1/sessions"
        
        Alamofire.request(.POST, urlString, headers: headers, parameters: ["sessions": ["email": email.text!, "password": password.text!]]).response { (req, res, data, error) -> Void in
            print(res?.statusCode)
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print(outputString)
            
            if(res?.statusCode == 200) {
                let json = JSON(data: data!)
                
                print(json["auth_token"])
                print("Success")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("transaction_view") as! TransactionViewController
                self.presentViewController(controller, animated: true, completion: nil)

            }else {
                print("Fail")
            }
        }
    }
}