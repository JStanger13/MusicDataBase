//
//  ArtistObject.swift
//  MusicDataBase
//
//  Created by Justin Stanger on 8/4/18.
//  Copyright © 2018 Justin Stanger. All rights reserved.
//

import Foundation
import UIKit

class ArtistObject: NSObject {
    var name : String?
    var url: String?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
