//
//  MainDelegateProtocol.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import Foundation

protocol MainDelegateProtocol: AnyObject {
    func showSearchVC(device: Device, delegates: SearchDelegate?)
    func showSettingVC()
    func showPreviousVC()
}
