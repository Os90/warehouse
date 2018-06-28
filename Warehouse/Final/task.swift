//
//  task.swift
//  Warehouse
//
//  Created by Osman Ashraf on 12.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import Foundation

class Task: NSObject {
    var id : Int = 0
    var color: String = "kein Color"
    var date: String = "kein datum"
    var ean: String = "kein ean"
    var imageUrl: String = "kein bild"
    
    var karton: String = "kein karton"
    var key: String = "kein key"
    var menge: Int = 0
    var name: String = "kein name"
    
    var position: String = "kein position"
    var size: String = "kein size"
    
    var sku: String = "kein sku"
    var vID: Int = 0
 
}
struct customObjects {
    static var url_csv: URL?
    static var listOfProducts = [CustomProdutct]()
    static var kundeCount : Int?
    static var bestandCount : Int?
}
