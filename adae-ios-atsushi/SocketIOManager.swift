//
//  SocketIOManager.swift
//  adae
//
//  Created by Atsushi Hirata on 2016-05-04.
//  Copyright © 2016 adae. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socket = SocketIOClient(socketURL: NSURL(string: "https://adae.co:40525")!,
                                options: [.Secure(true), .ForceWebsockets(true)]) //.Log(true),
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
