//
//  SearchDelegate.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import Foundation

protocol SearchDelegate: AnyObject {
    func addDeviceToFavorites(_ device: Device)
    func removeDeviceFromFavorites(_ device: Device)
}
