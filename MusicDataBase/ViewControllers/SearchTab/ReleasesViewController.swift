//
//  ReleasesViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/4/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit

class ReleasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var releaseList = [ReleaseResults]()
    let imageCache = NSCache<NSString, UIImage>()
    var currentArtist: ArtistResults?
    @IBOutlet weak var tableView: UITableView!
    final var url: URL?

    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = currentArtist?.title
        performAction()
    }
   
    func performAction() {
        url = URL(string: "https://api.discogs.com/database/\(currentArtist!.id!)/releases")
        //url = URL(string: "https://api.discogs.com/database/search?q=Nirvana&type=release&token=AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS")
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
                let downloadedReleases = try decoder.decode(Release_Base.self, from: data)
                self.releaseList = downloadedReleases.results!
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
        cell.releaseTitleLabel.text = currentRelease.title
        //cell.releaseArtistNameLabel.text = currentRelease.
        cell.releaseYearLabel.text = currentRelease.year
        //cell.releaseLabel.text = currentRelease.label[]
        cell.releaseCover.image = nil
       
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

