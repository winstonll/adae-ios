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
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class CompanionLoginViewController: UIViewController {
    
    @IBOutlet weak var privacy: UIButton!
    
    @IBOutlet weak var terms: UIButton!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login_button: UIButton!
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompanionLoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        /**
        user authentication key
        
        print(MyKeychainWrapper.myObjectForKey("v_Data"))
        **/

        /**
        user id
        
        print(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
        **/
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // If user has previously logged in, skip the login process and move onto transaction.
        if (NSUserDefaults.standardUserDefaults().boolForKey("hasLoggedIn")) {
            self.performSegueWithIdentifier("successfulLogin", sender: nil)

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
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv"]
        let urlString = "https://adae.co/api/v1/omniauth"
        
        Alamofire.request(.GET, urlString, headers: headers ).response { (req, res, data, error) -> Void in
            
            print("inside")
            let json = JSON(data: data!)
            print(json)
            
            /**
            
            if(res?.statusCode == 200) {
                let json = JSON(data: data!)
                
                // save user authentication token in keychain
                self.MyKeychainWrapper.mySetObject(String(json["auth_token"]), forKey:kSecValueData)
                self.MyKeychainWrapper.mySetObject(String(json["id"]), forKey:kSecAttrAccount)
                
                self.MyKeychainWrapper.writeToKeychain()
                
                // save the fact that user has logged in so we don't need to show the login screen
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoggedIn")
                
                self.performSegueWithIdentifier("successfulLogin", sender: nil)
                
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let controller = storyboard.instantiateViewControllerWithIdentifier("transaction_view") as! TransactionNavigationController
                //self.presentViewController(controller, animated: true, completion: nil)
                
            }else {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoggedIn")
                
                let alertView = UIAlertController(title: "Login Problem",
                    message: "Wrong username or password." as String, preferredStyle:.Alert)
                
                let okAction = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                alertView.addAction(okAction)
                
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }**/
        }

    }
    
    @IBAction func didLogin(sender: AnyObject) {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv"]
        let urlString = "https://adae.co/api/v1/sessions"
        
        Alamofire.request(.POST, urlString, headers: headers, parameters: ["sessions": ["email": email.text!, "password": password.text!]]).response { (req, res, data, error) -> Void in
            
            if(res?.statusCode == 200) {
                let json = JSON(data: data!)
                                
                // save user authentication token in keychain
                self.MyKeychainWrapper.mySetObject(String(json["auth_token"]), forKey:kSecValueData)
                self.MyKeychainWrapper.mySetObject(String(json["id"]), forKey:kSecAttrAccount)
                
                self.MyKeychainWrapper.writeToKeychain()
                
                // save the fact that user has logged in so we don't need to show the login screen
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoggedIn")
                
                self.performSegueWithIdentifier("successfulLogin", sender: nil)
                
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let controller = storyboard.instantiateViewControllerWithIdentifier("transaction_view") as! TransactionNavigationController
                //self.presentViewController(controller, animated: true, completion: nil)

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
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}