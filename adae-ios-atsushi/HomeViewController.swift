//
//  ViewController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-01-21.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire


class HomeViewController: UIViewController {
    
    @IBOutlet weak var uoft: UIButton!
    @IBOutlet weak var harbourfront: UIButton!
    @IBOutlet weak var discovery: UIButton!
    @IBOutlet weak var dundas: UIButton!
    @IBOutlet weak var annex: UIButton!
    @IBOutlet weak var yorkville: UIButton!
    @IBOutlet weak var distillery: UIButton!
    @IBOutlet weak var dufferin: UIButton!
    
    var district = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //add image
        //let imageName = "back_arrow.png"
        //let image = UIImage(named: imageName)
        //let imageView = UIImageView(image: image!)
        
        //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        //scrollview1.addSubview(imageView)
        
        
        
        //connecting to adae API
        let headers = ["ApiToken": "H4LvhkAw3vooYosNS98S"]
        let urlString = "https://adae.co/api/v1/users"
        
        Alamofire.request(.GET, urlString, headers: headers).response { (req, res, data, error) -> Void in
            print(res)
            let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            
            //let json = JSON(data: data)
            
            print(outputString)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button_clicked(sender: UIButton) {
        let title = sender.currentTitle!
        
        switch title {
        case "uoft":
            //tabBarController?.selectedIndex = 1
            district = "Listing in UofT"
            print("uoft tapped")
        case "harbourfront":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Harbourfront"
            print("harbourfront tapped")
        case "discovery":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Discovery"
            print("discovery tapped")
        case "dundas":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Dundas"
            print("dundas tapped")
        case "annex":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Annex"
            print("annex tapped")
        case "yorkville":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Yorkville"
            print("yorkville tapped")
        case "distillery":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Distillery"
            print("distillery tapped")
        case "dufferin":
            //tabBarController?.selectedIndex = 1
            district = "Listing in Dufferin"
            print("dufferin tapped")
        default:
            district = "Listing in Toronto"
            print(title)
        }
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        //if (segue.identifier == "segueTest") {
            let svc = segue!.destinationViewController as! ListingViewController
            
            svc.filter = district
            
        //}
    }
}

