//
//  DataStorageManager.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let updatedLists = NSNotification.Name("codes.joshua.devices.updatedLists")
}

class DataStorageManager {
    
    static let shared = DataStorageManager()
    
    var lists: [List] = [] {
        didSet {
            NotificationCenter.default.post(name: .updatedLists, object: self)
        }
    }
    
    private let listService: ListServiceType
    
    private convenience init() {
        self.init(listService: TrelloService.shared.listService)
    }
    
    init(listService: ListServiceType) {
        self.listService = listService
    }
    
    func updateLists() {
        
        TrelloService.shared.listService.getLists { [weak self] (response) in
            switch response {
            case .success(lists: let lists):
                self?.lists = lists
            case .failure(error: let error):
                print("Error: \(error)")
            }
        }
    }
}
