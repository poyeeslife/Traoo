//
//  item.swift
//  Traoo
//
//  Created by PoYee Tam on 1/3/2018.
//  Copyright © 2018年 PoYee Tam. All rights reserved.
//

import Foundation

class Item:Codable {
    
    var title: String = ""
    var done: Bool = false

    
}

//this class needs to mark to conform the Encodable and decodable (=codalble protocol) protocols which means the data is now able to encode itself into a plist or json.
// this class is used to be the objects of any new Items added in the controller and the newItem is then appended in the item Array which is going to encode.
