//
//  checkInternetConnection.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-09-13.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import SystemConfiguration

public class checkInternetConnection {
    
    func isConnected() -> Bool {
        var address = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        
        let defaultRoute = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: <#T##T.Type#>, capacity: <#T##Int#>, <#T##body: (UnsafePointer<T>) throws -> Result##(UnsafePointer<T>) throws -> Result#>)
        }
        
    }
}
