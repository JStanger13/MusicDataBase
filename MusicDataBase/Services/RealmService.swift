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
    
    func saveObjects(obj: [Object]){
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

    
    
    func djb2Hash(_ string: String) -> Int {
        let unicodeScalars = string.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    
    
    func deleteObjects(obj: [Object]){
        try! realm.write {
            realm.delete(obj)
        }
    }
}
