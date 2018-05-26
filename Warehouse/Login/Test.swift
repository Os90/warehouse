//
//  Test.swift
//  Warehouse
//
//  Created by Osman Ashraf on 01.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import Foundation
//func updateMyModel(){
//
//    var myProodutct  = [Product]()
//
//    ref = Database.database().reference()
//
//    var i  = 0
//
//    //
//    //            refArtists = FIRDatabase.database().reference().child("artists");
//
//    //observing the data changes
//    ref.observe(.value, with: { (snapshot) in
//
//        //if the reference have some values
//        if snapshot.childrenCount > 0 {
//
//            //clearing the list
//            //self.artistList.removeAll()
//
//            //iterating through all the values
//            for artists in snapshot.children.allObjects as! [DataSnapshot] {
//                //getting values
//                i = i + 1
//                guard let artistObject = artists.value as? [String: AnyObject] else {return}
//                //                    let gender  = artistObject["gender"]
//                //                    let namer  = artistObject["name"]
//                //                    let total_stock = artistObject["total_stock"]
//                let b = [Varianten]()
//                // let varianten = b
//                //creating artist object with model and fetched values
//                var a = Product.init()
//                a.gender = (artistObject["gender"] as? String)!
//                a.name = (artistObject["name"] as? String)!
//                a.total_stock = (artistObject["total_stock"] as! Int)
//                //var b = [Varianten]()
//
//
//                //                    if (artistObject!["varianten"] != nil){
//                //
//                //                        for (index, element) in artists.children.allObjects.enumerated() {
//                //                            print("Item \(index): \(element)")
//                //                            let a = Varianten.init(snapshot: element as! DataSnapshot)
//                //                             b.append(a)
//                //                        }
//                //
//                //
//                ////                        for i in artists.children{
//                ////                            let a = Varianten.init(snapshot: i as! DataSnapshot)
//                ////                            b.append(a)
//                ////                        }
//                //
//                //                        print("Varoianten",b)
//                //                    }
//
//
//                //  a.varianten = varianten as! [Varianten]
//
//                //let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
//
//                //appending it to list
//                myProodutct.append(a)
//            }
//            print("array",myProodutct)
//            print("i",i)
//            //reloading the tableview
//            //self.tableViewArtists.reloadData()
//        }
//    })
//}
//
//
//func fetchAllProducts(){
//    ref = Database.database().reference()
//
//}
//
//
//func updateValue(){
//    ref = Database.database().reference()
//    let a = ref.child("Warehouse Jeans")
//
//    a.observe(.value, with:
//        { snapshot in
//
//            if ( snapshot.value is NSNull ) {
//                print("not found")
//            } else {
//
//
//
//                if let a = snapshot.value as? [String: AnyObject]{
//                    print(a)
//                }
//
//                var myarray = [Varianten]()
//
//                //                    for (index, element) in snapshot.children.allObjects.enumerated() {
//                //                        print("Item \(index): \(element)")
//                //                        if index == 5{
//                //                            print(element)
//                //                            snapshot.childSnapshot(forPath:)
//                //                            let a = Varianten.init(snapshot: element as! DataSnapshot)
//                //                            myarray.append(a)
//                //                        }
//
//
//                for child in snapshot.children {
//                    let snap = child as! DataSnapshot
//                    let key = snap.key
//                    let value = snap.value
//
//                    if key == "varianten"{
//                        let b = snapshot.childSnapshot(forPath: key)
//                        for i in b.children.allObjects{
//                            let a = Varianten.init(snapshot: i as! DataSnapshot)
//                            myarray.append(a)
//                        }
//                    }else{
//
//                    }
//
//                }
//                print("VARIANTEN:",myarray)
//                //FUNKTIONIERT
//                var newItems: [Product] = []
//                //
//                //                    for artists in snapshot.children.allObjects as! [DataSnapshot] {
//                //                        //getting values
//                //                        let artistObject = artists.value as? [String: AnyObject]
//                //                        let planesItem = Product(snapshot: artistObject)
//                //                        print(planesItem)
//                ////                        let artistName  = artistObject?["artistName"]
//                ////                        let artistId  = artistObject?["id"]
//                ////                        let artistGenre = artistObject?["artistGenre"]
//                //
//                //                        //creating artist object with model and fetched values
//                //                        //let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
//                //
//                //                        //appending it to list
//                //                        //self.artistList.append(artist)
//                //                    }
//                //
//                //                    let planesItem = Product(snapshot: snapshot)
//                //                    print(planesItem)
//                //
//
//
//
//
//
//                //                    for item in (snapshot.value as! [String:AnyObject]) {
//                //
//                //                        print(item)
//                //
//                //                        let planesItem = Product(snapshot: item as! DataSnapshot)
//                //                        //newItems.append(planesItem)
//                //                    }
//                // print(newItems)
//                // self.planes = newItems
//                //  print(self.planes)
//
//            }
//    })
//
//
//    //            (snapshot) in
//    //
//    //            //Convert the info of the data into a string variable
//    //            if let getData = snapshot.children{
//    //                    let mynewVarian = Product(snapshot: getData as! DataSnapshot)
//    //                    print(mynewVarian)
//    //
//
//
//    //
//    //                let json = try? JSONEncoder().encode(wins),
//    //                let userlist = try? JSONDecoder().decode([Varianten].self, from: json) {
//    //
//    //                }
//
//    //  print(getData)
//
//    //                var wins = getData["varianten"] as! [String]
//    //
//    //               // let a : [String] = wins as! [String]
//    //
//    //                print("winsssss:\(wins)")
//    //
//    //                var c = Varianten.init()
//    //
//    //                c.color = "NUE"
//    //                c.size = "NUE SIW"
//    //
//    //                wins.append(c)
//    //
//    //                let tt = wins.getDictionary()
//    //
//    //
//    //                a.updateChildValues(["varianten":[tt]])
//
//
//
//
//
//    //  a.child("varianten").setValue(["color":"blau","size":"DD"])
//
//
//    //       a.updateChildValues(["varianten":["gender":"female"]])
//    //        print(a)
//
//
//
//}
