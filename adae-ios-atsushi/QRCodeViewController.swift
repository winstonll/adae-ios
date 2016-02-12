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
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var qrView: UIView!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var img_slider: UISlider!
    
    var qrcodeImage: CIImage!
    
    var toPass = [String: JSON]()
    
    var jsonObject: JSON = [
        ["name": "John", "age": 21],
        ["name": "Bob", "age": 35],
    ]
    
    let encoder = ["a", "b", "c", "d", "e", "f", "g", "h",
        "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
        "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7",
        "8", "9"]
    
    let MyKeychainWrapper = KeychainWrapper()
    
    var captureSession:AVCaptureSession?
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // If User is a seller then generate a QR code, if not start video capture process for QR reader
        if String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount)) == String(toPass["transaction"]!["seller_id"]){
            let iid = String(toPass["item"]!["id"])
            let tid = String(toPass["transaction"]!["id"])
            let qr_provider = String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount))
            var pre_encoded = tid + "-" + iid + "-" +  qr_provider
            
            if(String(toPass["transaction"]!["in_scan_date"]) == "null"){
                pre_encoded += "-inscan"
            } else {
                pre_encoded += "-outscan"
            }
            
            self.displayQRImage(pre_encoded)
            
            self.scaledNonBlurryQR()

        } else {
            while let subview = qrView.subviews.last {
                subview.removeFromSuperview()
            }
            if (String(toPass["item"]!["listing_type"]) != "sell" && String(toPass["transaction"]!["out_scan_date"]) == "null") || (String(toPass["item"]!["listing_type"]) == "sell" && String(toPass["transaction"]!["in_scan_date"]) == "null"){
                // Transaction hasn't been completed yet
                
                self.startVideoCapture()
                
                // Initialize QR Code Frame to highlight the QR code
                qrCodeFrameView = UIView()
                qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView?.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView!)
                view.bringSubviewToFront(qrCodeFrameView!)
            } else {
                // Transaction has already been completed
                let alertController = UIAlertController(title: "Scan Successful!", message:
                    "You’ve already completed this transaction, this page cannot be accessed for that reason.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        self.imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(img_slider.value), CGFloat(img_slider.value))
    }
    
    // Encode the String data that we are going to store in the QR code
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
    
    // Placing QR image in the image view
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
    
    // Scaling the QR image so it is not blurry
    func scaledNonBlurryQR() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
        
    }
    
    func startVideoCapture() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input as AVCaptureInput)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()

        } catch let error as NSError {
            print(error)
            
            // Error alert for when the video capture has an error
            let alertController = UIAlertController(title: "Please Try Again!", message:
                "There was an error on our end, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Verifying the process of scanning QR code and updating the balance of the seller.
    func updateUserBalance(encoded_string: String, callback: ((isOk: Bool)->Void)?) -> String {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv", "Authorization": String(MyKeychainWrapper.myObjectForKey("v_Data"))]
        let urlString = "https://adae.co/api/v1/verify_scan"
        
        Alamofire.request(.GET, urlString, headers: headers, parameters: ["transactions": ["balance":  String(self.toPass["transaction"]!["total_price"]), "inscan": encoded_string]]).response { (req, res, data, error) -> Void in
            
            if res?.statusCode == 204 {
                
                let alertController = UIAlertController(title: "Scan Successful!", message:
                    "Please go ahead and exchange the item.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                callback?(isOk: true)
            } else {
                
                let alertController = UIAlertController(title: "Something went wrong!", message:
                    "Invalid QR code was scanned.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)

                callback?(isOk: false)
            }
            
        }
        
        return "returned"
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero

            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            self.captureSession?.stopRunning()
            
            if metadataObj.stringValue != nil {
                
                self.updateUserBalance(metadataObj.stringValue) { (isOk) -> Void in
                    if (isOk) {
                        print("async success")
                    }else{
                        
                        self.captureSession?.startRunning()
                        print("async fail")
                    }
                }
                
            }
        }
    }
}