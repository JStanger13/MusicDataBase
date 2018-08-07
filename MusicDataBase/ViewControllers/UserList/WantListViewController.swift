//
//  WantListViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/6/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import RealmSwift

class WantListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    var albumList : Results<AlbumObject>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFromRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func loadFromRealm(){
        let realm = RealmService.shared.realm
      
        self.albumList = realm.objects(AlbumObject.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAlbumCell", for: indexPath) as! SavedAlbumCell
        let currentAlbum = albumList[indexPath.row]
        cell.albumArtist.text = currentAlbum.artistTitle
        cell.albumTitle.text = currentAlbum.albumTitle
        cell.albumCover.layer.cornerRadius = 10
        
        return cell

    }
    
    

}
