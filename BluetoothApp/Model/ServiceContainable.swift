//
//  ServiceContainable.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import Foundation

// Service Container protocol
protocol ServiceContainable {
    
    /// User service
    var userService: UserServiceable { get set }
    
}


/// Service Container struct
struct ServiceContainer: ServiceContainable {
    var userService: UserServiceable
}
