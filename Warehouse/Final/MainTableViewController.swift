//
//  MainTableViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 10.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var filter: UISearchBar!
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var scanBtn: UIBarButtonItem!
    
    var db: DatabaseReference!
    
    var dataProducts = [CustomProdutct]()
    var realDataProducts = [CustomProdutct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(tableName: mytbl, nibname: "MainCell", cell: "Cell")
        db = Database.database().reference()
        dataFromServer()
        filter.placeholder = "name"
        filter.showsCancelButton = true
        filter.keyboardType = .default
        filter.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func scanBtnAct(_ sender: Any) {
        self.performSegue(withIdentifier: "scan", sender: self)
    }
    
    func dataFromServer(){
        db.child("bestand").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.dataProducts.removeAll()
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let a = CustomProdutct.init(snapshot: artists)
                    self.dataProducts.append(a)
                }
                self.realDataProducts = self.dataProducts
                self.mytbl.reloadData()
            }
        }, withCancel: {
            error in
            print(error)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.key = dataProducts[sender as! Int].key
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = mytbl.indexPathForSelectedRow {
            mytbl.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch(searchText)
    }
    func filterSearch(_ filterString: String){
        
        dataProducts = realDataProducts.filter{ $0.name.lowercased().contains(filterString.lowercased()) }
        
        mytbl.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataProducts = self.realDataProducts
        filter.text = ""
        
        filter.endEditing(true)
        mytbl.reloadData()
    }
    
}
extension MainTableViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.positionCell.text = "Position:\(dataProducts[indexPath.row].position)"
        if dataProducts[indexPath.row].name == "" {
            cell.nameCell.text = "EAN:\(dataProducts[indexPath.row].ean)"
        }else{
            cell.nameCell.text = dataProducts[indexPath.row].name
        }
        cell.totalStockCell.text = String(describing:dataProducts[indexPath.row].menge)
        if let first = dataProducts[indexPath.row].date.components(separatedBy: " ").first {
            cell.dateCell.text = first
        }
        cell.eanCell.text = "Ean :\(dataProducts[indexPath.row].ean)"
        
        let photoUrl = dataProducts[indexPath.row].imageUrl
        if photoUrl != "" && photoUrl != "kein Bild"{
            getImage(url: photoUrl) { photo in
                if photo != nil {
                    DispatchQueue.main.async {
                        cell.imageUrlCell.image = photo
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alle Produkte (\(dataProducts.count))"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "edit", sender: indexPath.row)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let menge = dataProducts[indexPath.row].menge
            let ean  = dataProducts[indexPath.row].ean
            let key = dataProducts[indexPath.row].key
            db.child("bestand").child(dataProducts[indexPath.row].key).removeValue { error,success  in
                if error != nil {
                    print("error \(error)")
                }
                else{
                    self.saveProcess("löschen",menge,ean,key)
                    self.dataFromServer()
                }
            }        }
    }
    func saveProcess(_ text : String,_ realStock : Int,_ realEan : String,_ realKey : String){
        let dict = ["vorgang":text,"ean":realEan,"menge":realStock,"view": "DetailView","datum": getDate(),"key": realKey] as [String : Any]
        self.db.child("prozesse").child(text).childByAutoId().setValue(dict, withCompletionBlock: {error ,ref in
            if error != nil{
            }else{
            }
        })
    }
}
