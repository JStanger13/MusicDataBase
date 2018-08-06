//
//  WantListViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/6/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import RealmSwift

class WantListViewController: UIViewController {
   
    var albumList : Results<Object>!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadFromRealm(){
        let realm = RealmService.shared.realm
      
        self.albumList = RealmService.shared.getObjetcs(type: AlbumObject.self)
    }
    

}
