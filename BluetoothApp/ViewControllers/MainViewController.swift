//
//  MainViewController.swift
//  BluetoothApp
//
//  Created by Grigory Sapogov on 06.04.2024.
//

import UIKit
import SnapKit
import CoreBluetooth
import SwipeCellKit
import RealmSwift

extension MainViewController {
    
    func showSearchVC(device: Device, delegates: SearchDelegate?) {
        
    }
     
    func showSettingVC() {
        
    }
    
    func showPreviousVC() {
        
    }
    
}

final class MainViewController: UIViewController {

    var viewModel: MainViewModel!
    
    private let headerMainView: HeaderMainView = HeaderMainView.instanceFromNib()
    
    private let permissionLabel = MainViewPermissionLabel()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.permissionLabel.text = self.viewModel.text
        self.setupViewModel()
        self.setupHeaderView()
        self.setupTableView()
        self.layoutView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.startScanning()
    }
    
    private func setupHeaderView() {
        headerMainView.state = .main
        headerMainView.settingAction = { [weak self] in
            self?.showSettingVC()
        }
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MainPageCell.ReuseID, bundle: nil), forCellReuseIdentifier: MainPageCell.ReuseID)
        tableView.backgroundColor = .clear
        
    }
    
    private func layoutView() {
        
        view.addSubview(headerMainView)
        
        headerMainView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(96)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(permissionLabel)
        permissionLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(85)
            $0.trailing.equalToSuperview().inset(85)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerMainView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func setupViewModel() {
        
        self.viewModel.didUpdateStateCompletion = { [weak self] bluetoothOn in
            
            if bluetoothOn {
                self?.viewModel.startScanning()
            }
            else {
                self?.showAlert()
            }
            
            self?.permissionLabel.isHidden = bluetoothOn
            self?.tableView.isHidden = !bluetoothOn
            
        }
        
        self.viewModel.didDiscoverCompletion = { [weak self] in
            
            self?.tableView.reloadData()
            
        }
        
        self.viewModel.didChangeFavourites = { [weak self] in
            
            self?.tableView.reloadData()
            
        }
        
    }
    
    private func showAlert() {

        let alertVC = UIAlertController(title: "Bluetooth Required", message: "Check your Bluetooth Settings", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertVC.addAction(action)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        headerView.customView.isHidden = viewModel.isScanning
        headerView.backgroundColor = .white //Я добавил, этого не было
        
        let devices = self.viewModel.dataSource[section]
        
        headerView.titleLabel.text = "All Devices: \(devices.count)"
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.dataSource[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        self.viewModel.dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPageCell.ReuseID, for: indexPath) as? MainPageCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        cell.device = self.viewModel.dataSource[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let device = self.viewModel.dataSource[indexPath.section][indexPath.row]
        
        self.showSearchVC(device: device, delegates: self)
        
    }
}

// MARK: - SwipeTableViewCellDelegate

extension MainViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeCellKit.SwipeActionsOrientation
    ) -> [SwipeCellKit.SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                
                guard let self = self else { return }
                      
                let device = self.viewModel.dataSource[indexPath.section][indexPath.row]
                
                if device.isFavourite {
                    self.viewModel.removeFromFavourite(device: device)
                }
                else {
                    self.viewModel.addToFavourite(device: device)
                }
                
            }
            
            deleteAction.backgroundColor = .white
            deleteAction.highlightedBackgroundColor = .white
            deleteAction.image = configure(image: .normal, at: indexPath)
            deleteAction.highlightedImage = configure(image: .highlighted, at: indexPath)
            
            return [deleteAction]
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.maximumButtonWidth = 72
        options.minimumButtonWidth = 72
        options.backgroundColor = .white
        
        return options
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        print(orientation.rawValue)
        if orientation.rawValue == 1 {
            let cell = tableView.cellForRow(at: indexPath) as? MainPageCell
            cell?.changspecialContainer(alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        let cell = tableView.cellForRow(at: indexPath ?? IndexPath())as? MainPageCell
        cell?.changspecialContainer(alpha: 0)
        
    }
    
    private enum ImageState {
        case normal, highlighted
    }
    
    private func configure(image: ImageState, at indexPath: IndexPath) -> UIImage {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 60))
        view.roundCorners(corners: [.bottomRight, .topRight], radius: 10)
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "617DFF")
        
        let device = self.viewModel.dataSource[indexPath.section][indexPath.row]
        
        let imageName: ImageState
        if image == .normal {
            imageName = device.isFavourite ? .highlighted : .normal
        } else {
            imageName = .highlighted
        }
        
        let img = UIImageView(image: UIImage(resource: imageName == .normal ? .unselectedHeart! : .selectedHeart!))
        img.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        view.addSubview(img)
        
        return view.asImage()
        
    }
    
}

extension MainViewController: SearchDelegate {
    
    func addDeviceToFavorites(_ device: Device) {
        self.viewModel.addToFavourite(device: device)
    }

    func removeDeviceFromFavorites(_ device: Device) {
        self.viewModel.removeFromFavourite(device: device)
    }
    
}
