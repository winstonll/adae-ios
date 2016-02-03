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
        
        if String(MyKeychainWrapper.myObjectForKey(kSecAttrAccount)) == String(toPass["transaction"]!["seller_id"]){
            let uid = String(toPass["user"]!["id"])
            let iid = String(toPass["item"]!["id"])
            let tid = String(toPass["transaction"]!["id"])
            
            let pre_encoded = tid + "-" + iid + "-" + uid
            
            self.displayQRImage(pre_encoded)
            
            self.scaledNonBlurryQR()

        } else {
            while let subview = qrView.subviews.last {
                subview.removeFromSuperview()
            }
            
            self.startVideoCapture()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView?.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView!)
            view.bringSubviewToFront(qrCodeFrameView!)
            
            
        }
        
        print("Inside of QR Code View Controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        self.imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(img_slider.value), CGFloat(img_slider.value))
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
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No QR code is detected"
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                //messageLabel.text = metadataObj.stringValue
                print(metadataObj.stringValue)
            }
        }
    }
}