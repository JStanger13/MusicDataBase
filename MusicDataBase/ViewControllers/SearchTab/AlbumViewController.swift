//
//  AlbumViewController.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/5/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import UIKit
import Toast_Swift

class AlbumViewController: UIViewController{
    
    @IBOutlet weak var outsideAlbumView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var saveSwitch: UISwitch!
    
    final var url: URL?
    final var year: Int?
    final var yearString: String?
    
    final var albumIsSaved  = false

    
    var currentAlbum: Releases?
    var albumImage: [Images]?
    var albumInfoList:[String]?
    
    @IBOutlet weak var albumInfoView: UIView!
    @IBOutlet weak var albumCover: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRealm()
        
        albumInfoView.layer.cornerRadius = 10
        albumInfoView.layer.masksToBounds = true
        insideView.layer.cornerRadius = 5
        insideView.layer.masksToBounds = true
                

        
        outsideAlbumView.layer.cornerRadius = 10
        outsideAlbumView.layer.masksToBounds = true
        albumCover.layer.cornerRadius = 5
        
        if(currentAlbum?.main_release != nil){
            performAction()
            
            titleLabel.text = "\(currentAlbum!.title!)     "
            artistLabel.text = "\(currentAlbum!.artist!)     "
            self.year = currentAlbum?.year
            self.yearString = String(year!)
            
            yearLabel.text = "\(String(describing: yearString!))"
        }
    }
    func loadRealm(){
        if (RealmService.shared.getFilteredObjetcs(type: AlbumObject.self, key: currentAlbum!.id!) != nil){
            
            albumIsSaved = true
            saveSwitch.isOn = true
        }else{
            albumIsSaved = false
            saveSwitch.isOn = false
        }
    }
    func performAction() {
        url = URL(string: "https://api.discogs.com/releases/\(currentAlbum!.main_release!)?token=AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS")
        print(currentAlbum!.id!)
        print(url!)
        albumInfoList?.append((currentAlbum?.title)!)
        albumInfoList?.append((currentAlbum?.artist)!)
        let year = currentAlbum!.year!
        let yearString = String(year)
        albumInfoList?.append(yearString)

        
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
    //RealmService.shared.saveObjects(obj: [currentAlbum])

    func saveAlbum(){
        let savedAlbum = AlbumObject(albumTitle: currentAlbum!.title!, artistTitle: currentAlbum!.artist!, albumYear: String(currentAlbum!.year!), albumCover: currentAlbum!.thumb!, albumID: currentAlbum!.id!)
        print(currentAlbum!.thumb!)
        print(savedAlbum.albumTitle)
        print(savedAlbum.artistTitle)
        print(savedAlbum.albumYear)
        
        if saveSwitch.isOn{
            self.view.makeToast("This Album Has Been Saved")
            RealmService.shared.saveObjects(obj: [savedAlbum])
        }else{
            self.view.makeToast("This Album Has Been Removed")
            RealmService.shared.deleteObjects(obj: [savedAlbum])
        }
    
        
        RealmService.shared.saveObjects(obj: [savedAlbum])

    }
   
    @IBAction func saveSwitchAction(_ sender: Any) {
        saveAlbum()
    }
    
}
