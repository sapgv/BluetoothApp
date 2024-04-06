//
//  MainViewModel.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import Foundation
import CoreBluetooth
import RealmSwift

final class MainViewModel: NSObject {
    
    let text = "You Have Not Given Permission to use Bluetooth Go to Settings and Turn On Bluetooth"

    var didUpdateStateCompletion: ((Bool) -> Void)?
    
    var didDiscoverCompletion: (() -> Void)?
    
    var didChangeFavourites: (() -> Void)?
    
    var isScanning: Bool {
        self.centralManager.isScanning
    }
    
    var devicesFavourites: Results<Device> {
        self.devices.filter("isFavourite == true")
    }
    
    private(set) lazy var devices: Results<Device> = self.realm.objects(Device.self)
    
    private let centralManager: CBCentralManager
    
    private let realm: Realm = try! Realm()
    
    var dataSource: [Results<Device>] {
        if devicesFavourites.isEmpty {
            return [self.devices]
        }
        return [self.devicesFavourites, self.devices]
    }
    
    init(centralManager: CBCentralManager = CBCentralManager()) {
        self.centralManager = centralManager
        super.init()
        self.centralManager.delegate = self
    }
    
    func startScanning() {
        guard self.centralManager.isScanning else { return }
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        print("Scanning...")
    }
    
    func addToFavourite(device: Device) {
        try! realm.write {
            defer {
                didChangeFavourites?()
            }
            device.isFavourite = true
        }
    }
    
    func removeFromFavourite(device: Device) {
        try! realm.write {
            defer {
                didChangeFavourites?()
            }
            device.isFavourite = false
        }
    }
    
    
}

extension MainViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
            self.didUpdateStateCompletion?(false)
        case .poweredOn:
            print("Is Powered On.")
            self.didUpdateStateCompletion?(true)
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let max = 80.0
        let min = 40.0
        
        let absoluteRSSI = abs(RSSI.doubleValue)
        let normalizedRSSI = (absoluteRSSI - min) / (max - min)
        let progress = Double(1 - round(normalizedRSSI * 10.0) / 10.0)
        
        let device = Device(peripheral: peripheral, distance: progress)
        
        guard !self.devices.contains(where: { $0.identifier == device.identifier }) else { return }
        
        try! self.realm.write {
            realm.add(device, update: .all)
            self.didDiscoverCompletion?()
        }
        
//        peripheralArray.append(peripheral)
//        
//        let max = 80.0
//        let min = 40.0
//        
//        let absoluteRSSI = abs(RSSI.doubleValue)
//        let normalizedRSSI = (absoluteRSSI - min) / (max - min)
//        let progress = Double(1 - round(normalizedRSSI * 10.0) / 10.0)
//        
//        debugPrint("progress: ",progress)
//                
//        let dev = Device(peripheral: peripheral, distance: progress)
//        
//        if self.devices.isEmpty {
//            self.devices.append(dev)
//        } else {
//            if let currentDevice = devices.firstIndex(where: {$0.peripheral?.identifier == peripheral.identifier}) {
//                self.devices[currentDevice] = dev
//            } else {
//                self.devices.append(dev)
//            }
//        }
        
        
    }
    
}

