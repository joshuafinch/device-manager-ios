//
//  DeviceListViewController.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

class DeviceListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var devicesByFamily: [Device.Family: [Device]] = [:] {
        didSet {
            devicesBySection = Array(devicesByFamily.values)
        }
    }
    
    fileprivate var devicesBySection: [[Device]] = [] {
        didSet {
            refreshView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshView()
    }
    
    func refreshView() {
        tableView?.reloadData()
    }
    
    fileprivate func device(at indexPath: IndexPath) -> Device {
        return devicesBySection[indexPath.section][indexPath.row]
    }
}

// MARK: UITableViewDataSource

extension DeviceListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return devicesBySection.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesBySection[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(devicesByFamily.keys)[section].presentableName()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let device = self.device(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        
        cell.selectionStyle = .none
        
        cell.deviceName.text = device.name
        cell.deviceDesc.text = device.desc
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension DeviceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let device = self.device(at: indexPath)
        
        let actionSheet = UIAlertController(title: "", message: "What would you like to do with \(device.name)?", preferredStyle: .actionSheet)
        
        let claimAction = UIAlertAction(title: "Claim Device", style: .default, handler: { _ in
            // TODO: Claim device
        })
        
        let releaseAction = UIAlertAction(title: "Release Device", style: .destructive, handler: { _ in
            // TODO: Release device
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(claimAction)
        actionSheet.addAction(releaseAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        return view
    }
}
