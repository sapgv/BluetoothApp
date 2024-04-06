//
//  Device.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import Foundation
import CoreBluetooth
import RealmSwift

class Device: Object {
    
    @Persisted var identifier: UUID
    @Persisted var name: String?
    @Persisted var rssi: Int = 0
    @Persisted var lastSeen: Date = Date()
    @Persisted var distance: Double = 0.0
    @Persisted var isFavourite: Bool = false

    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    var peripheral: CBPeripheral?
    
    convenience init(peripheral: CBPeripheral, distance: Double = 0.0) {
        self.init()
        self.peripheral = peripheral
        self.identifier = peripheral.identifier
        self.name = peripheral.name
        self.rssi = peripheral.rssi as? Int ?? 0
        self.lastSeen = Date()
        self.distance = distance
    }
}
