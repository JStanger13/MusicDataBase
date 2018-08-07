//
//  AlbumObject.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/6/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import Foundation
import RealmSwift
class AlbumObject: Object {

    @objc dynamic var albumTitle = ""
    @objc dynamic var artistTitle = ""
    @objc dynamic var albumYear = ""
    @objc dynamic var albumCover = ""

    var albumID = RealmOptional<Int>()


    @objc dynamic var objectID = UUID().uuidString

    override static func primaryKey() -> String? {
        return "objectID"
    }

    convenience init(albumTitle: String, artistTitle: String, albumYear: String, albumCover: String, albumID: Int) {
        self.init()
        self.albumTitle = albumTitle
        self.artistTitle = artistTitle
        self.albumYear = albumYear
        self.albumCover = albumCover
        self.albumID.value = albumID
    }
}
