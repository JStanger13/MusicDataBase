//
//  RealmService.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/6/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService{
    private init() {}
    static let shared = RealmService()
    var realm = try! Realm()
    
    func saveObjects(obj: AlbumObject){
        try! realm.write {
            realm.add(obj, update: true)
        }
    }
    
    func getObjetcs(type: Object.Type) -> Results<Object>?{
        return realm.objects(type)
    }
    //mainQuestID
    func getFilteredObjetcs(type: Object.Type, key: Int) -> Results<Object>? {
                return realm.objects(type).filter("albumID == %@", key)
    }

    
    

    func deleteObjects(obj: AlbumObject){
        try! realm.write {

        let predicate = NSPredicate(format: "albumID == %@", argumentArray: [obj.albumID])
        if let productToDelete = realm.objects(AlbumObject.self).filter(predicate).first{
           
            realm.delete(productToDelete)
        
                realm.delete(obj)
            }
        }
    }
}
