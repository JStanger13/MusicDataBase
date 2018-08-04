//
//  ViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/3/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import RealmSwift
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var artistList = [Results]()
    final var url: URL?
    let token = "AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS"
    var artist:String?
    let imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        url = URL(string: "https://api.discogs.com/database/search?q=\(self.textField.text!)&type=artist&token=\(self.token)")
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
                let downloadedArtists = try decoder.decode(Json4Swift_Base.self, from: data)
                self.artistList = downloadedArtists.results!
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
        return artistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as!
        ArtistCell
        
        let currentArtist = artistList[indexPath.row]
        
        cell.nameLabel.text = currentArtist.title
        cell.artistImage.image = nil
        let urlString = currentArtist.thumb! as! NSString
        
        if let imageFromCache = imageCache.object(forKey: urlString){
            cell.artistImage.image = imageFromCache
        } else if let imageURL =  URL(string: (urlString as String)){
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        let  imageToCache = image
                        self.imageCache.setObject(image!, forKey: urlString)
                        cell.artistImage.image = imageToCache
                    }
                }else{}
            //do nothing
            }
        }
        return cell
    }
}



