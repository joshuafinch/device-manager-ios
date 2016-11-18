//
//  ProjectListViewController.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit

class ProjectListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataStorageManager: DataStorageManager? = nil {
        didSet {
            
            NotificationCenter.default.removeObserver(self,
                                                      name: .updatedLists,
                                                      object: oldValue)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(refreshView),
                                                   name: .updatedLists,
                                                   object: dataStorageManager)
            
            refreshView()
        }
    }
    
    fileprivate var projects: [Project] = []
    fileprivate var selectedProject: Project? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshView()
        
        collectionView.contentInset = UIEdgeInsetsMake(100.0, 0,
                                                       100.0, 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshView() {
        let lists: [List] = dataStorageManager?.lists ?? []
        self.projects = lists.map(Project.init)
        
        collectionView?.reloadData()
    }
    
    // MARK: Helpers
    
    fileprivate func project(at indexPath: IndexPath) -> Project {
        return projects[indexPath.item]
    }
    
    fileprivate func sizeOfDeviceFamiliesLabel(text: String, width: CGFloat) -> CGSize {
        
        let initialSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let exampleLabel = UILabel(frame: CGRect(origin: .zero, size: initialSize))
        exampleLabel.numberOfLines = 0
        exampleLabel.text = text
        exampleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return exampleLabel.sizeThatFits(initialSize)
    }
    
    // MARK:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDeviceListForProject",
            let deviceListViewController = segue.destination as? DeviceListViewController,
            let project = selectedProject
        {
            deviceListViewController.devices = project.devices
        }
    }
}

// MARK: UICollectionViewDataSource

extension ProjectListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let project = self.project(at: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        cell.projectName.text = project.name
        cell.projectDevicesByFamily.text = project.textForDevicesByFamily()
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ProjectListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProject = project(at: indexPath)
        performSegue(withIdentifier: "ShowDeviceListForProject", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let project = self.project(at: indexPath)
        
        let width = (UIScreen.main.bounds.width * 0.9) - 40
        let initialSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let exampleLabel = UILabel(frame: CGRect(origin: .zero, size: initialSize))
        exampleLabel.text = project.name
        exampleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        let height = sizeOfDeviceFamiliesLabel(text: project.textForDevicesByFamily(), width: width).height + exampleLabel.sizeThatFits(initialSize).height + 30.0
        
        return CGSize(width: width, height: height)
    }
}
