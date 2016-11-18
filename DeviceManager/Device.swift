//
//  Device.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation

struct Device {
    
    enum Family: String {
        case iphone = "iphone"
        case ipad = "ipad"
        case android = "android"
        case other = "other"
    }
    
    let id: String
    let name: String
    let desc: String
    let family: Family
    
    init(id: String, name: String, desc: String, family: Family) {
        self.id = id
        self.name = name
        self.desc = desc
        self.family = family
    }
}

extension Device {

    init?(card: Card) {
        
        let labelnames = card.labels.map { label in label.name }
        
        let potentialFamilies = labelnames.flatMap { (labelName) -> Device.Family? in
            let normalized = labelName.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return Device.Family(rawValue: normalized)
        }
        
        let family = potentialFamilies.first ?? .other
        
        self.init(id: card.id, name: card.name, desc: card.desc, family: family)
    }
}
