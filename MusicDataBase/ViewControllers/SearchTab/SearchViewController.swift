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
    var artistList = [ArtistResults]()
    final var url: URL?
    let token = "AXZYPRfjIYVkEiErSyebiLrREQwtLfKbAkfEpOiS"
    var artist:String?
    let imageCache = NSCache<NSString, UIImage>()
    var type: String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var navItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        selectSearchMethod()
        print(segmentedController.selectedSegmentIndex)

        textField.clearButtonMode = .always
        
        self.textField.layer.cornerRadius = 15
        self.textField.layer.masksToBounds = true
        
        //self.navigationController?.navigationItem.layer.cornerRadius = 50
        //textField.clearButtonMode = .whileEditing

    }
    
    @IBAction func segmentedControllerChange(_ sender: Any) {
        print(self.segmentedController.selectedSegmentIndex)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            if segue.destination is ReleasesViewController {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                let indexPath = self.tableView.indexPathForSelectedRow
                
                let currentArtist = self.artistList[(indexPath?.row)!]
                
                let destinationVC = segue.destination as! ReleasesViewController
                destinationVC.currentArtist = currentArtist
            }
        }
    }
    
    func selectSearchMethod() {
        if segmentedController.selectedSegmentIndex == 0 {
            type = "artist"
        }else{
            type = "release"
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        let str = self.textField.text!
        let replaced = str.replacingOccurrences(of: " ", with: "%20")

        url = URL(string: "https://api.discogs.com/database/search?q=\(replaced)&type=\(type!)&token=\(self.token)")
        
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
                let downloadedArtists = try decoder.decode(Artist_Base.self, from: data)
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
        cell.outsideView.layer.cornerRadius = 10
        cell.outsideView.layer.masksToBounds = true
        cell.artistImage.layer.cornerRadius = 5
        cell.stringView.layer.cornerRadius = 10
        
        cell.cellBackView.layer.cornerRadius = 10
        cell.cellBackView.layer.masksToBounds = true

        
        cell.selectionStyle = .none

        cell.nameLabel.text = currentArtist.title

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



