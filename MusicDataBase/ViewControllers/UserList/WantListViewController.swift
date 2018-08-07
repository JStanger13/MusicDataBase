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
    let imageCache = NSCache<NSString, UIImage>()

    
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
        cell.clearView.layer.cornerRadius = 10
        cell.clearView.layer.masksToBounds = true
        cell.albumCover.layer.cornerRadius = 10
        cell.albumCoverOutsideView.layer.cornerRadius = 10
        cell.albumCoverOutsideView.layer.masksToBounds = true
        
        
        let urlString = currentAlbum.albumCover as! NSString

        if let imageFromCache = imageCache.object(forKey: urlString){
            cell.albumCover.image = imageFromCache
        } else if let imageURL =  URL(string: (urlString as String)){
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        let  imageToCache = image
                        self.imageCache.setObject(image!, forKey: urlString)
                        cell.albumCover.image = imageToCache
                    }
                }else{}
                //do nothing
            }
        }
        
        return cell

    }
    
    

}
