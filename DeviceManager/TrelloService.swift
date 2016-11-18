//
//  TrelloService.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import Alamofire

class TrelloService {
    
    static let shared: TrelloService = TrelloService()
    
    let listService: ListServiceType
    
    private let sessionManager: SessionManager
    
    private convenience init() {
        let sessionManager = SessionManager.default
        
        self.init(sessionManager: sessionManager,
                  listService: ListService(sessionManager: sessionManager))
    }
    
    init(sessionManager: SessionManager, listService: ListServiceType) {
        self.sessionManager = sessionManager
        self.listService = listService
    }
}
