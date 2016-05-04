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
    
    let socket = SocketIOClient(socketURL: NSURL(string: "https://adae.co:40091")!,
                                options: [.Secure(true), .Log(true), .ForceWebsockets(true)])
    
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
