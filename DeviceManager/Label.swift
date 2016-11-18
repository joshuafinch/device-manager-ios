//
//  Label.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import Freddy

struct Label: JSONDecodable {
    
    let id: String
    let name: String
    let color: String?
    
    init(json value: JSON) throws {
        id = try value.getString(at: "id")
        name = try value.getString(at: "name")
        color = try? value.getString(at: "color")
    }
}
