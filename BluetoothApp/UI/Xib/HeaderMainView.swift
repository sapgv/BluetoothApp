//
//  HeaderMainView.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import UIKit

final class HeaderMainView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = HeaderMainView
    
    
    @IBOutlet weak var iconDevice: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var gearButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    enum HeaderState {
       case main, settings, search, map
    }
    
    var settingAction: (() -> ())?
    var backAction: (() -> ())?
    
    var state: HeaderState = .main {
        didSet{
            switch state {
            case .main:
                titleLabel?.text = "Find Device"
                backwardButton?.isHidden = true
                iconDevice?.isHidden = true
            case .settings:
                gearButton.isHidden = true
                iconDevice?.isHidden = true
                titleLabel.text = "Settings"
            case .search:
                gearButton.isHidden = true
                favoriteButton.isHidden = false
                //iconDevice.image = UIImage(named: "airpods")
                //titleLabel.text = "Airpods - Egor"
            case .map:
                gearButton.isHidden = true
                shareButton.isHidden = false
                iconDevice.image = UIImage(named: "macbook")
                titleLabel.text = "Microsoft"
            }
        }
    }
    
    @IBAction func gearButtonAction(_ sender: UIButton) {
        settingAction?()
    }
    @IBAction func backButton(_ sender: UIButton) {
        backAction?()
    }
}
