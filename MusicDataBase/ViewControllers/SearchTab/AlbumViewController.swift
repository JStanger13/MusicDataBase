//
//  AlbumViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/5/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as!
        AlbumCell
        
        
        return cell
    }
    
    final var url: URL?
    var currentAlbum: Releases?
    var albumImage: [Images]?
    
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var albumCover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveSwitch.isOn = false
        if(currentAlbum?.main_release != nil){
            performAction()
            tableView.bounces = false
        }
    }
    
    func performAction() {
        url = URL(string: "https://api.discogs.com/releases/\(currentAlbum!.main_release!)?token=AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS")
       print(currentAlbum!.id!)
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
                let downloadedAlbum = try decoder.decode(Album_Base.self, from: data)
                if downloadedAlbum.images != nil{
                    self.albumImage = downloadedAlbum.images
                    self.getAlbumArt()
                    print("not nil")
                    
                }else{
                    print("Shit's nil!!!!")
                }
               
                
            } catch {
                print("something wrong after download")
                
            }
            }.resume()
    }
    
    
    func getAlbumArt(){
        let url = URL(string: (albumImage?[0].uri)!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.albumCover.image = UIImage(data: data!)
    }

   
}
