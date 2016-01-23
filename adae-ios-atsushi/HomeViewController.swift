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
    
    @IBAction func button_clicked(sender: UIButton) {
        // do something
        print("uoft Tapped")
    }

}

