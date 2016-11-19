//
//  LoginViewController.swift
//  DeviceManager
//
//  Created by Joshua Finch on 19/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainAccess

class LoginViewController: UIViewController {
    
    var oauthswift: OAuthSwift? = nil
    
    let dismissCompletion: () -> Void
    
    init(dismissCompletion: @escaping () -> Void) {
        self.dismissCompletion = dismissCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.white
    }
    
    func authWithTrello() {
        let oauthswift = OAuth1Swift(
            consumerKey:    "7d80fa7f06c3f8482600a7d6ae587b84",
            consumerSecret: "b6d90f6d23edbb00fb82f6bad9e35375d3b9945bd84048c7f26b9201cf4b8a42",
            requestTokenUrl:    "https://trello.com/1/OAuthGetRequestToken",
            authorizeUrl:       "https://trello.com/1/OAuthAuthorizeToken?expiration=never&name=Chelsea%20Apps%20Factory",
            accessTokenUrl:     "https://trello.com/1/OAuthGetAccessToken"
        )
        
        self.oauthswift = oauthswift
        
        oauthswift.authorizeURLHandler = getURLHandler()
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "codes.joshua.devices://oauth-callback/trello")!,
            success: { credential, response, parameters in
                print("credential: \(credential)")
                
                SessionManager.default.adapter = OAuthSwiftRequestAdapter(credential)
                let data = NSKeyedArchiver.archivedData(withRootObject: credential)
                
                try? Keychain(service: "codes.joshua.devices.trello").set(data, key: "credential")
                
                DataStorageManager.shared.updateLists()
        },
            failure: { error in
                print(error.localizedDescription, terminator: "")
        })
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
        handler.presentCompletion = {
            print("Safari presented")
        }
        
        handler.dismissCompletion = self.dismissCompletion
        
        return handler
    }
}

class OAuthSwiftRequestAdapter: RequestAdapter {
    
    fileprivate let credential: OAuthSwiftCredential
    
    public init(_ credential: OAuthSwiftCredential) {
        self.credential = credential
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var config = OAuthSwiftHTTPRequest.Config(
            urlRequest: urlRequest,
            paramsLocation: .authorizationHeader,
            dataEncoding: .utf8
        )
        config.updateRequest(credential: credential)
        
        return try OAuthSwiftHTTPRequest.makeRequest(config: config)
    }
    
}
