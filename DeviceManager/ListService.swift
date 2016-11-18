//
//  ListService.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

protocol ListServiceType {
 
    func getLists(completionHandler: @escaping (GetListResponse) -> Void)
}

enum GetListResponse {
    
    struct GetListError: Error {
        let title: String
        let message: String
    }
 
    case success(lists: [List])
    case failure(error: GetListError)
}

class ListService: ListServiceType {
    
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func getLists(completionHandler: @escaping (GetListResponse) -> Void) {
        
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: configPath) as? [String: AnyObject] else
        {
            fatalError("Couldn't get configuration")
        }
 
        guard let baseUrlString = config["base-url"] as? String,
            let devicesBoardId = config["devices-board-id"] as? String,
            let authToken = config["auth-token"] as? String,
            let appKey = config["app-key"] as? String,
            let secret = config["secret"] as? String else {
            fatalError("Couldn't get configuration values")
        }
        
        let urlString = baseUrlString + "/boards/" + devicesBoardId + "/lists" + "?key=" + appKey + "&token=" + authToken + "&cards=open&card_fields=labels,name,id,desc&fields=cards,name,id"
        
        sessionManager.request(urlString).validate().responseJSON { (response) in
            
            guard let data = response.data, let json = try? JSON(data: data) else {
                let error = GetListResponse.GetListError(title: "Error", message: "Bad response!")
                completionHandler(.failure(error: error))
                return
            }
            
            guard response.result.isSuccess else {
                let error = GetListResponse.GetListError(title: "Error", message: "Get lists failed")
                completionHandler(.failure(error: error))
                return
            }

            guard let lists = try? json.getArray().map(List.init) else {
                let error = GetListResponse.GetListError(title: "Error", message: "We couldn't map the lists!")
                completionHandler(.failure(error: error))
                return
            }
            
            completionHandler(.success(lists: lists))
        }
    }
}
