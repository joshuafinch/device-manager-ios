//
//  Card.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import Freddy

struct Card: JSONDecodable {
    
    let id: String
    let name: String
    let desc: String
    let labels: [Label]
    
    init(json value: JSON) throws {
        id = try value.getString(at: "id")
        name = try value.getString(at: "name")
        desc = try value.getString(at: "desc")
        labels = try value.getArray(at: "labels").map(Label.init)
    }
}
