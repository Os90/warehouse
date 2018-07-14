//
//  ProductClass.swift
//  Warehouse
//
//  Created by Osman Ashraf on 30.04.18.
//  Copyright © 2018 osman. All rights reserved.
//

import Foundation
import Firebase


struct CustomProdutct : Codable{
    var name  = String()
    var menge = Int()
    var ean  = String()
    var sku  = String()
    var vID = Int()
    var imageUrl  = String()
    var position  = String()
    var size  = String()
    var color  = String()
    var key  = String()
    var date = String()
    var karton = String()
    var id = Int()
    
    init(){
        self.name = String()
        self.menge = Int()
        self.ean = String()
        self.sku = String()
        self.imageUrl = String()
        self.position = String()
        self.size = String()
        self.key = String()
        self.color = String()
        self.date = String()
        self.karton = String()
        self.id = Int()
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        name = (snapshotValue["name"] as? String) ?? "kein namen"
        menge = (snapshotValue["menge"] as? Int) ?? 0
        ean = (snapshotValue["ean"] as? String) ?? "keine Ean"
        sku = (snapshotValue["sku"] as? String) ?? "keine Sku"
        imageUrl = (snapshotValue["imageUrl"] as? String) ?? "kein Bild"
        position = (snapshotValue["position"] as? String) ?? "keine Position"
        size = (snapshotValue["size"] as? String)  ?? "keine größe"
        key = (snapshotValue["key"] as? String) ?? "kein key"
        color = (snapshotValue["color"] as? String) ?? "keine Farbe"
        date = (snapshotValue["date"] as? String) ?? "no date"
        karton = (snapshotValue["karton"] as? String) ?? "no karton"
        id = (snapshotValue["id"] as? Int) ?? 0
    }
    
}

struct SessionStruct{
    static var updated : Bool?
    static var filter : String?
}


struct Product : Codable{
    
    var kategorie  = String()
    var gender  = String()
    var total_stock =  Int ()
    var name  = String()
    var imageUrl  = [String?]()
    var colorVariante  = [VarianteColor]()
    var imageData: Data = Data()
    var key  = String()
    //let image: UIImage?
    
    
    init(){
        self.kategorie = String()
        self.gender = String()
        self.total_stock = Int()
        self.name = String()
        self.imageUrl = [String?]()
        colorVariante = [VarianteColor]()
        self.key = String()
        self.imageData = Data()
        //self.image = UIImage()
    }
}

struct VarianteColor : Codable{
    var color : ColorForProduct
    var varianten =  [Variante]()
    var imageUrlColor  = String()
    
    
    init(mystring : ColorForProduct){
        self.color = mystring
        self.varianten = [Variante]()
        self.imageUrlColor = String()
        
    }
    
    //FIRDataSnapshot
    init(snapshot: DataSnapshot) {
        var allVarianten  = [Variante]()
        let snapshotValue = snapshot.value as! [String:AnyObject]
        var imageUrl : String?
        var myColor : ColorForProduct?
        for (_, element) in snapshot.children.allObjects.enumerated() {
            let a = element as! DataSnapshot
            if a.childrenCount > 0{
                for (_, element) in a.children.allObjects.enumerated() {
                    let a = Variante.init(snapshot: element as! DataSnapshot)
                    allVarianten.append(a)
                }
            }else{
                myColor = ColorForProduct(rawValue: (snapshotValue["color"] as? String)!)
                
                imageUrl = (snapshotValue["imageUrlColor"] as? String)
            }
        }
        guard let Icolor = myColor else {
            color = ColorForProduct.gelb
            return
        }
        guard let imageurl = imageUrl else {
            imageUrlColor = String()
            color = Icolor
            varianten = allVarianten
            return
        }
        color = Icolor
        imageUrlColor = imageurl
        varianten = allVarianten
    }
}
enum ColorForProduct : String,Codable {
    case rot = "ROT"
    case gelb = "GELB"
    case weis = "WEIS"
}

struct Variante : Codable{
    var size = String()
    // var color = String()
    var stock = Int()
    var ean = String()
    var selected = Bool()
    var position = String()
    
    init(){
        self.size = String()
        // self.color = String()
        self.stock = Int()
        self.ean = String()
        self.selected = false
        self.position = String()
    }
    //FIRDataSnapshot
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String:AnyObject]
        guard let sizeValue = (snapshotValue["size"] as? String),let eanValue = (snapshotValue["ean"] as? String), let positionValue = (snapshotValue["position"] as? String), let stockValue = (snapshotValue["stock"] as? Int) else {
            return
        }
        position = positionValue
        size = sizeValue
        stock = stockValue
        ean = eanValue
    }
}
extension Encodable {
    /// Returns a JSON dictionary, with choice of minimal information
    func getDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
        }
    }
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
struct gps : Codable{
    var id = Int()
    var longitude  : String?
    var latitude : String?
    var created_at = String()
    var updated_at = String()
    var url = String()
    
    init(){
        self.id = Int()
        self.longitude = String()
        self.latitude  = String()
        self.created_at = String()
        self.updated_at = String()
        self.url = String()
    }
}
