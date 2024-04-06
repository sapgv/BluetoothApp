//
//  MainPageCell.swift
//  FindMy
//
//  Created by Евгений Черников on 17.01.2024.
//

import UIKit
import SwipeCellKit
import CoreBluetooth

class MainPageCell: SwipeTableViewCell {
    
    static let ReuseID = "MainPageCell"
    
    @IBOutlet weak var leadingViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trillingViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deviceIcon: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var signalIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var specialContainerView: UIView!
	
	private var initialPosition: CGPoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
		containerView.clipsToBounds = true
		containerView.layer.cornerRadius = 10
    }
	
	func changspecialContainer(alpha: CGFloat ){
		UIView.animate(withDuration: alpha == 0 ? 0.05 : 0.2) {
			self.specialContainerView.alpha = alpha
		}
	}
	
	var device: Device? {
		didSet{
			guard let device  else{ return }
			deviceNameLabel.text = device.name ?? "unnamed name"
            
            if UserDefaults.standard.value(forKey: "selectedSegmentIndex") as? Int == 1 {
                distanceLabel.text = "\(device.distance) m"
            } else {
                distanceLabel.text = "\(device.distance * 0.3) inc"
            }
            			
			switch device.distance {
			case 0 ... 1:
				signalIcon.image = UIImage(resource: .greatSignal)
			case 1.1 ... 1.5:
				signalIcon.image = UIImage(resource: .goodSignal)
			case 1.6 ... 2:
				signalIcon.image = UIImage(resource: .normalSignal)
			case 2.1 ... 2.5:
				signalIcon.image = UIImage(resource: .averageSignal)
			case 2.6 ... 4:
				signalIcon.image = UIImage(resource: .badSignal)
			case 4.1 ... 100:
				signalIcon.image = UIImage(resource: .veryBad)
			default:
				break
			}
		}
	}
}
