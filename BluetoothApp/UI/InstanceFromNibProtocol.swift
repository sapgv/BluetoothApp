//
//  InstanceFromNibProtocol.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import UIKit

/// Protocol for initiating UIViews from NIB
protocol InstanceFromNibProtocol {
    
    // MARK: - Assissiated type
    associatedtype InstanceFromNibType: UIView
    
    /// Get UIView instanc from Nib
    ///
    /// - Returns: UIView instance
    static func instanceFromNib() -> InstanceFromNibType
}

// MARK: - Default implementation
extension InstanceFromNibProtocol {
    static func instanceFromNib() -> InstanceFromNibType {
        let nibName = InstanceFromNibType.className
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InstanceFromNibType
    }
}

