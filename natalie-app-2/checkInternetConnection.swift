//
//  checkInternetConnection.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-09-13.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import SystemConfiguration

public class CheckInternetConnection {
    
    func isConnected() -> Bool {
        var address = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteConnection = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { socketAddress in
                SCNetworkReachabilityCreateWithAddress(nil, socketAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteConnection!, &flags) == false {
            return false
        }
        
        let isConnected = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isConnected && !needsConnection)
    }
}
