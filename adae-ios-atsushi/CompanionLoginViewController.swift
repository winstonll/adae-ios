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
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(MyKeychainWrapper.myObjectForKey("v_Data"))
        
        print("Inside of Companion Login Controller")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLoggedIn") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("transaction_view") as! TransactionNavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
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
        
        let headers = ["ApiToken": "YB4BJGf_sb3dEqbej6LM"]
        let urlString = "https://adae.co/api/v1/sessions"
        
        Alamofire.request(.POST, urlString, headers: headers, parameters: ["sessions": ["email": email.text!, "password": password.text!]]).response { (req, res, data, error) -> Void in
            
            //let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            //print(outputString)
            
            if(res?.statusCode == 200) {
                let json = JSON(data: data!)
                
                //save user authentication token in keychain
                self.MyKeychainWrapper.mySetObject(String(json["auth_token"]), forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                
                //save the fact that user has logged in so we don't need to show the login screen
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoggedIn")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("transaction_view") as! TransactionNavigationController
                self.presentViewController(controller, animated: true, completion: nil)

            }else {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoggedIn")
                
                let alertView = UIAlertController(title: "Login Problem",
                    message: "Wrong username or password." as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }
        }
    }
}