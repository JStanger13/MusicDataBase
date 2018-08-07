//
//  LogInViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/7/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import OAuthSwift

class LogInViewController: UIViewController {

//    let oauthSwift = OAuth2Swift(
//        consumerKey: "foo",
//        consumerSecret: "bar",
//        //requestTokenUrl: "https://api.discogs.com/oauth/request_token",
//        authorizeUrl: "https://www.discogs.com/oauth/authorize",
//        //accessTokenUrl: "https://api.discogs.com/oauth/access_token"
//        responseType:   "token"
//    )
   
    let oauthSwift = OAuth1Swift(
        consumerKey: "lJKbkQeHZEwdVlyopiQQ",
        consumerSecret: "DRlAsYCpMxEhwOCmFYKPkEQaNEEdSSCJ",
        requestTokenUrl: "https://api.discogs.com/oauth/request_token",
        authorizeUrl: "https://www.discogs.com/oauth/authorize",
        accessTokenUrl: "https://api.discogs.com/oauth/access_token"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kickOffAuthFlow()
    }
 
    fileprivate func kickOffAuthFlow() {
        
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthSwift)
        
        guard let callbackURL = URL(string: "foo.bar.boobaz:/oauth_callback") else { return }
        
        oauthSwift.authorize(withCallbackURL: callbackURL, success: { (credential, response, parameters) in
            _ = self.oauthSwift.client.get("https://api.discogs.com/oauth/identity", success: { (response) in
                guard let dataString = response.string else { return }
                print(dataString)
            }, failure: { (error) in
                print("error")
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
