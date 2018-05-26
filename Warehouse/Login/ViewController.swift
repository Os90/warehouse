//
//  ViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 29.04.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
//import CodableFirebase

class ViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet weak var filter: UISearchBar!

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mytbl: UITableView!
    var db: DatabaseReference!
    
    var storageRef: StorageReference!
    
    
    var allProduct  = [Product]()
    var keyBySelect : String?
    var productSelect : Product?
    var filterProducrt = [Product]()
    
    var productMen  = [Product?]()
    var productWomen   =  [Product?]()
    
    var imageSelect =  UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Database.database().reference()
        storageRef = Storage.storage().reference()
        registerCell(tableName: mytbl, nibname: "MainCell", cell: "Cell")
        
       // create()
        getAllMyData()
       
        
        //updateByID()
        
        //deleteByID()
        
       // setupUI()
        
        filter.showsCancelButton = true
        segment.selectedSegmentIndex = 0
        filter.delegate = self
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        
        segmentCtrl(segment as AnyObject)
    }
    
    @IBAction func addNewProduct(_ sender: Any) {
        
       // create()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filter.text = ""
        segmentCtrl(segment as AnyObject)
        filter.endEditing(true)
    }
    
    @IBAction func segmentCtrl(_ sender: Any) {
        
        self.filterProducrt.removeAll()
        switch segment.selectedSegmentIndex
        {
        case 0:
            //filterData("Frauen")
            filterProducrt = productWomen as! [Product]
        case 1:
            //filterData("Männer")
            filterProducrt = productMen  as! [Product]
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.mytbl.reloadData()
        }
    }
    func filterSearch(_ filterString: String){
        if filterString == ""{
             segmentCtrl(segment as AnyObject)
        }else{
            filterProducrt = filterProducrt.filter{ $0.name.lowercased().contains(filterString.lowercased()) }
        }
        mytbl.reloadData()
    }
    
    func filterData(_ filterString: String){

        self.filterProducrt.removeAll()
        self.filterProducrt = self.allProduct.filter({$0.gender == filterString})
        mytbl.reloadData()
    }
    func filterArrayInCat(_ instanz : [Product]){
        productMen.removeAll()
        productWomen.removeAll()
        self.productMen = instanz.filter({$0.gender == "Männer"})
        self.productWomen = instanz.filter({$0.gender == "Frauen"})
        
        self.setupUI()
        
        
        //mytbl.reloadData()
    }
    
    
    
    func getAllMyData(){
        self.indicator.alpha = 1.0
        self.indicator.startAnimating()
        
        db.observe(.value, with: {(snapshot) in
            
            
            self.indicator.stopAnimating()
            self.indicator.alpha = 0.0
            if snapshot.childrenCount > 0 {
                self.allProduct.removeAll()
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let artistObject = artists.value as? [String: AnyObject] else {return}
                    var a = Product.init()
                    a.gender = (artistObject["gender"] as? String)!
                    a.name = (artistObject["name"] as? String)!
                    a.total_stock = (artistObject["total_stock"] as! Int)
                    a.key = (artistObject["key"] as! String)
                    a.imageUrl = (artistObject["imageUrl"] as! [String])
                    
                    print(artistObject["imageUrl"] as! [String])
                    
                    
                    
                    // Create a storage reference from the URL
//                    let storageRef = storage.reference("name/of/my/object/to/download.jpg")
//                    // Download the data, assuming a max size of 1MB (you can change this as necessary)
//                    storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//                        // Create a UIImage, add it to the array
//                        let pic = UIImage(data: data)
//                        FeedImage.image = pic
//                    })
                    
                    
                    self.allProduct.append(a)
                }
                self.filterArrayInCat(self.allProduct)
               
            }
            
            
            
            }, withCancel: {
                error in
                print(error)
        })
        
//
//        db.observe(.value, with: { (snapshot) in
//            self.indicator.stopAnimasting()
//            self.indicator.alpha = 0.0
//            if snapshot.childrenCount > 0 {
//                self.allProduct.removeAll()
//                for artists in snapshot.children.allObjects as! [DataSnapshot] {
//                    guard let artistObject = artists.value as? [String: AnyObject] else {return}
//                    var a = Product.init()
//                    a.gender = (artistObject["gender"] as? String)!
//                    a.name = (artistObject["name"] as? String)!
//                    a.total_stock = (artistObject["total_stock"] as! Int)
//                    a.key = (artistObject["key"] as! String)
//                    a.imageUrl = (artistObject["imageUrl"] as! [String])
//                    self.allProduct.append(a)
//                }
//
//                self.setupUI()
//            }
//        })
    }
    
    
    func create(){
        //
        //        var products = Product.init()
        //        products.gender = "XX"
        //        products.kategorie = "XX"
        //        products.name = "BESTE XXX FRESCH"
        //        products.key = db.childByAutoId().key
        //        let imageUrl = "String"
        //        products.imageUrl.append(imageUrl)
        //        var varianten1 = Varianten.init()
        //        varianten1.color = "XX"
        //        varianten1.size = "XL"
        //        var varianten2 = Varianten.init()
        //        varianten2.color = "WExxIS"
        //        varianten2.size = "Xs"
        //        products.varianten.append(varianten1)
        //        products.varianten.append(varianten2)
        ////
        //        let a = products.getDictionary()
        //
        //        db.child(products.key).setValue(a)
        
        
        
        var products = Product.init()
        products.gender = "Männer"
        products.kategorie = "XX"
        products.name = "NEU XXX FRESCH"
        products.key = db.childByAutoId().key
        let imageUrl = "String"
        products.imageUrl.append(imageUrl)
        var varianten1 = Variante.init()
        varianten1.size = "XL"
        var varianten2 = Variante.init()
        varianten2.size = "Xs"
        //        products.varianten.append(varianten1)
        //        products.varianten.append(varianten2)
        
        var myVarianten  = [Variante]()
        
        myVarianten.append(varianten1)
        myVarianten.append(varianten2)
        
        var colorGelb = VarianteColor.init(mystring: .gelb)
        colorGelb.varianten  = myVarianten
        colorGelb.imageUrlColor = "hahaha.com"
        
        var colorRot = VarianteColor.init(mystring: .rot)
        colorRot.varianten  = myVarianten
        
        products.colorVariante = [colorRot,colorGelb]
        
        //
        let a = products.getDictionary()
        
        db.child(products.key).setValue(a)
    }
    func updateByID(_ id : String = ""){
        db.child("-LBQmAoKKVGs7fQFZ44H").updateChildValues(["gender" : "asdfasd"])
    }
    
    func deleteByID(){
        db.child("-LBQmAoKKVGs7fQFZ44H").removeValue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "add"{
            
        }
//        else if segue.identifier == "next"{
//            let destinationVC = segue.destination as! DetailViewController
//            guard let key = keyBySelect,let p = productSelect else{return}
//            destinationVC.myimage = imageSelect
//            destinationVC.DetailKey = keyBySelect
//            destinationVC.DetailProduct = p
//        }
        

    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterProducrt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.nameCell.text = filterProducrt[indexPath.row].name
        cell.totalStockCell.text = String(describing:filterProducrt[indexPath.row].total_stock)
        let photoUrl = filterProducrt[indexPath.row].imageUrl[0]!
        getImage(url: photoUrl) { photo in
            if photo != nil {
                    DispatchQueue.main.async {
                         cell.imageUrlCell.image = photo
                    }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filterProducrt.count > 0{
            keyBySelect = filterProducrt[indexPath.row].key
            productSelect = filterProducrt[indexPath.row]
//            guard let data = UIImage(data:filterProducrt[indexPath.row].imageData) else {
//                return
//            }
//            imageSelect = data
            self.performSegue(withIdentifier: "next", sender: self)
        }
        

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}


extension UIViewController{
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
            }.resume()
    }
}

extension UIImageView {
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(activityView)
        activityView.frame = self.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            }.resume()
    }
}

