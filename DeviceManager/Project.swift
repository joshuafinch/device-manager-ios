//
//  Project.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation

struct Project {

    let id: String
    let name: String
    
    let devices: [Device]
    
    init(id: String, name: String, devices: [Device]) {
        self.id = id
        self.name = name
        self.devices = devices
    }
    
    func getDevicesByFamily() -> [Device.Family: [Device]] {
        
        let allFamilies: [Device.Family] = [.ipad, .iphone, .android, .other]
        
        var dict: [Device.Family: [Device]] = [:]
        
        for family in allFamilies {
            
            let devices = self.devices.filter({ $0.family == family })
            if devices.count > 0 {
                dict[family] = devices
            }
        }
        
        return dict
    }
    
    func textForDevicesByFamily() -> String {
        let devicesByFamilies = getDevicesByFamily()
        
        var text: String = ""
        
        for family in devicesByFamilies.keys {
            if let deviceCount = devicesByFamilies[family]?.count, deviceCount > 0 {
                text = text + family.presentableName() + ": " + String(deviceCount) + "\n"
            }
        }
        
        return text
    }
}

extension Project {
    
    init(list: List) {
        let devices = list.cards.flatMap(Device.init)
        self.init(id: list.id, name: list.name, devices: devices)
    }
}
