//
//  ReleasesViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/4/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit

class ReleasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var releaseList = [Releases]()
    let imageCache = NSCache<NSString, UIImage>()
    var currentArtist: ArtistResults?
    @IBOutlet weak var tableView: UITableView!
    final var url: URL?
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = currentArtist?.title
        textField.placeholder = "Search Albums by \(currentArtist?.title)"
        performAction()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumSegue" {
            if segue.destination is AlbumViewController {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let indexPath = self.tableView.indexPathForSelectedRow
                
                let currentAlbum = self.releaseList[(indexPath?.row)!]
                
                let destinationVC = segue.destination as! AlbumViewController
                destinationVC.currentAlbum = currentAlbum
            }
        }
    }
  
    func performAction() {
        url = URL(string: "http://api.discogs.com/artists/\(currentArtist!.id!)/releases?token=AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS")

        print(url!)
        
        downloadJson()
    }
    
    func downloadJson(){
        
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do{
                let decoder = JSONDecoder()
                let downloadedReleases = try decoder.decode(Json4Swift_Base.self, from: data)
                if downloadedReleases.releases != nil{
                    print("not nil")
                self.releaseList = downloadedReleases.releases!

                }else{
                    print("Shit's nil!!!!")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("something wrong after download")
                
            }
            }.resume()
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.releaseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReleasesCell", for: indexPath) as!
        ReleasesCell
        
        let currentRelease = releaseList[indexPath.row]
        cell.releaseTitleLabel.text = "\(currentRelease.title!)     "
        cell.releaseArtistNameLabel.text = "\(currentRelease.artist!)     "
        
       
        cell.outsideView.layer.cornerRadius = 10
        cell.outsideView.layer.masksToBounds = true
        cell.releaseCover.layer.cornerRadius = 5

        
        cell.cellBackView.layer.cornerRadius = 10
        cell.cellBackView.layer.masksToBounds = true
        
        cell.selectionStyle = .none

        
        if (currentRelease.year != nil) {
            cell.releaseYearLabel.text = String(currentRelease.year!)
        }

        let urlString = currentRelease.thumb! as! NSString
        
        if let imageFromCache = imageCache.object(forKey: urlString){
            cell.releaseCover.image = imageFromCache
        } else if let imageURL =  URL(string: (urlString as String)){
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        let  imageToCache = image
                        self.imageCache.setObject(image!, forKey: urlString)
                        cell.releaseCover.image = imageToCache
                    }
                }else{}
                //do nothing
            }
        }
        return cell
    }
}

