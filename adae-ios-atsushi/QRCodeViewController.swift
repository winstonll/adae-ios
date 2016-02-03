//
//  QRCodeViewController.swift
//  adae-ios-atsushi
//
//  Created by Atsushi Hirata on 2016-02-01.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QRCodeViewController: UIViewController {
    
    @IBOutlet var qrView: UIView!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var img_slider: UISlider!
    
    var qrcodeImage: CIImage!
    
    var toPass = [String: JSON]()
    
    let encoder = ["a", "b", "c", "d", "e", "f", "g", "h",
        "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
        "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7",
        "8", "9"]
    
    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount)) == String(toPass["transaction"]!["seller_id"]){
            let uid = String(toPass["user"]!["id"])
            let iid = String(toPass["item"]!["id"])
            let tid = String(toPass["transaction"]!["id"])
            
            let pre_encoded = tid + "-" + iid + "-" + uid
            
            self.displayQRImage(pre_encoded)

        } else {
            while let subview = qrView.subviews.last {
                subview.removeFromSuperview()
            }
        }
        
        print("Inside of QR Code View Controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        
    }
    
    func encodeQRData(data: String) -> String {
        
        var encoded_JSON = ""
        
        for index in data.characters.indices {
            
            if String(data[index]) !=  "-" {
                var position = encoder.indexOf(String(data[index]))! + 8
                
                if position > 35 {
                    position = position - 36
                }
                
                encoded_JSON.append(Character(encoder[position]))
            } else {
                encoded_JSON.append(data[index])
            }
        }
        
        return encoded_JSON
    }
    
    func displayQRImage(data: String) -> Void {
        if self.qrcodeImage == nil {
            let data = self.encodeQRData(data).dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            imgQRCode.image = UIImage(CIImage: qrcodeImage)
        }
    }
    
}