//
//  ChatViewController.swift
//  adae
//
//  Created by Atsushi Hirata on 2016-03-30.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    var messages = [JSQMessage]()

    var toPass = [String: JSON]()
    
    var jsonObject: JSON = [
    ["name": "John", "age": 21]]
    
    let MyKeychainWrapper = KeychainWrapper()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var messageFrame = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.toPass)
        print(self.senderDisplayName)
        
        self.getMessages { (isOk) -> Void in
            if (isOk) {
                self.setup()
                self.addDemoMessages()
                
                self.activityIndicator.stopAnimating()
                print("async success")
                
            }else{
                print("async fail")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width

        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.activityIndicator.color = UIColor.blueColor()
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.activityIndicator.hidden = false
        //self.activityIndicator.center.x = self.view.center.x
        self.activityIndicator.center.x = screenWidth
        self.activityIndicator.center.y = self.view.center.y
        print(self.view.center.x)
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    func getMessages(callback: ((isOk: Bool)->Void)?) -> Void {
        
        let headers = ["ApiToken": "EHHyVTV44xhMfQXySDiv", "Authorization": String(MyKeychainWrapper.myObjectForKey("v_Data")) ]
        let urlString = "https://adae.co/api/v1/messages/"
        
        Alamofire.request(.GET, urlString, headers: headers, parameters: ["messages": ["conversation_id":  String(self.toPass["conversation"]!["id"]) ] ] ).response { (req, res, data, error) -> Void in
            
            self.jsonObject = JSON(data: data!)
            
            print(self.jsonObject)
            
            /**for message in self.jsonObject {
                let jsqMessage = JSQMessage(senderId: message[""] message.senderId, senderDisplayName: message.senderId, date: message.created_at, text: message.text)
                self.messages += [message]
            }
            
            self.messages += [message]**/
            callback?(isOk: true)
        }
    }
    
}

//MARK - Setup
extension ChatViewController {
    func addDemoMessages() {
        for i in 1...10 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
            self.messages += [message]
        }
        self.reloadMessagesView()
    }
    
    func setup() {
        self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
}

//MARK - Data Source
extension ChatViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}

//MARK - Toolbar
extension ChatViewController {
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages += [message]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
}

//MARK - Syncano
extension ChatViewController {
    
    func sendMessageToServer(message: JSQMessage) {
        /**let messageToSend = Message()
        messageToSend.text = message.text
        messageToSend.senderId = self.senderId
        messageToSend.channel = syncanoChannelName
        messageToSend.other_permissions = .Full
        messageToSend.saveWithCompletionBlock { error in
            if (error != nil) {
                //Super cool error handling
            }
        }**/
    }
    
    func downloadNewestMessagesFromServer() {
        /**Message.please().giveMeDataObjectsWithCompletion { objects, error in
            if let messages = objects as? [Message]! {
                self.messages = self.jsqMessagesFromSyncanoMessages(messages)
                self.finishReceivingMessage()
            }
        }**/
    }
    
    func jsqMessageFromServerMessage(message: Message) -> JSQMessage {
        let jsqMessage = JSQMessage(senderId: message.senderId, senderDisplayName: message.senderDisplayName, date: message.created_at, text: message.text)
        return jsqMessage
    }
    
    func jsqMessagesFromServerMessages(messages: [Message]) -> [JSQMessage] {
        var jsqMessages : [JSQMessage] = []
        for message in messages {
            jsqMessages.append(self.jsqMessageFromServerMessage(message))
        }
        return jsqMessages
    }
}
