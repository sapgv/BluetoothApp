//
//  HeaderTableView.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import UIKit

class HeaderTableView: UIView {
    
    let titleLabel = UILabel()
    let customView = UIView()
    var backgroundLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitle()
        addCustomView()
        addBackgroundLayer()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startAnimating(backgroundLayer)
        } else {
            backgroundLayer.removeAllAnimations()
        }
    }
    
    private func addTitle() {
        titleLabel.text = "Favorite device"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .black
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(0)
        }
    }
    
    private func addCustomView() {
        addSubview(customView)
        customView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addBackgroundLayer() {
        backgroundLayer = configureBackgroundLayer()
        backgroundLayer.frame = CGRect(x: 0, y: 5, width: 10, height: 10)
        customView.layer.addSublayer(backgroundLayer)
    }

    private func configureBackgroundLayer() -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureProgressBarPath()
        backgroundLayer.strokeColor = UIColor.black.cgColor
        backgroundLayer.lineWidth = 1.5
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        
        return backgroundLayer
    }
    
    private func configureProgressBarPath() -> CGPath {
        UIBezierPath(
            arcCenter: customView.center,
            radius: 8,
            startAngle: 3 * CGFloat.pi / 3,
            endAngle: 3 * CGFloat.pi,
            clockwise: true
        ).cgPath
    }
    
    private func startAnimating(_ layer: CAShapeLayer) {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = 2
        strokeEndAnimation.repeatCount = .infinity
        
        layer.add(strokeEndAnimation, forKey: "drawLineAnimation")
    }
}
