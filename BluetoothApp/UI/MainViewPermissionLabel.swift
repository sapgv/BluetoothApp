//
//  MainViewPermissionLabel.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import UIKit

final class MainViewPermissionLabel: UILabel {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.font = UIFont.systemFont(ofSize: 18)
        self.textColor = .lightGray
        self.numberOfLines = 0
        self.textAlignment = .center
    }
    
    
}
    
