//
//  ProductDetailViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 29.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var mytbl: UITableView!
    
    var selectedName = ""
    
    var mylist = [CustomProdutct]()
    
    var total = 0
    
    var selectedNamesFromView = [String]()
    
    var names = ""
    
    @IBOutlet weak var upload: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in selectedNamesFromView{
            let a = customObjects.listOfProducts.filter({$0.name.lowercased().components(separatedBy: "/").first == i.lowercased()})
            mylist  = mylist + a
//            if i = selectedNamesFromView.count{
//                 names.append("\(i)")
//            }else{
//                 names.append("\(i)&")
//            }
           names.append("\(i)  ")
        }
        
        for x in mylist{
            total = total + x.menge
        }

        self.navigationItem.title = names

        
        mytbl.isEditing = true
        mytbl.allowsMultipleSelectionDuringEditing = true

    }
    
    override func viewWillAppear(_ animated: Bool) {

//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
//
//        navigationItem.title = "This is multiline title for navigation bar"
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [
//            NSAttributedStringKey.foregroundColor: UIColor.black,
//            NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .largeTitle)
//        ]
        //navigationItem.title = "This is multiline title for navigation bar"
//        for navItem in(self.navigationController?.navigationBar.subviews)! {
//            for itemSubView in navItem.subviews {
//                if let largeLabel = itemSubView as? UILabel {
//                    largeLabel.text = navigationItem.title
//                    largeLabel.numberOfLines = 0
//                    largeLabel.lineBreakMode = .byWordWrapping
//                }
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        
        var mySelectedArray  = [CustomProdutct]()
        
        if let selected_indexPaths = mytbl.indexPathsForSelectedRows{
            for indexPath in selected_indexPaths {
                print(indexPath.row)
               let a = mylist[indexPath.row]
                mySelectedArray.append(a)
            }
        }
        if saveCSV(names, mySelectedArray, customObjects.url_csv!) {
            let spezialFileKunde =  customObjects.url_csv?.appendingPathComponent("\(names)-Bestand.csv")
            let spezialFileBestand =  customObjects.url_csv?.appendingPathComponent("\(names)-Kunde.csv")
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [spezialFileKunde,spezialFileBestand], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        

    }
    func saveCSV(_ name : String, _ array : [CustomProdutct], _ customUrl : URL) -> Bool {

        var fileName = "\(name)-Bestand.csv"
        // path = customUrl
        var b = customUrl.appendingPathComponent(fileName)

        var csvText = ""
            csvText = "ID,Color,Datum,EAN,Karton,Menge,Name,Position,Größe,SKU\n"
            for task in array {
                let newLine = "\(task.id),\(task.color),\(task.date),\(task.ean),\(task.karton),\(task.menge),\(task.name),\(task.position),\(task.size),\(task.sku)\n"
                csvText.append(newLine)
            }

        do {
            try csvText.write(to: b, atomically: true, encoding: String.Encoding.utf8)
            
            fileName = "\(name)-Kunde.csv"
            // path = customUrl
            b = customUrl.appendingPathComponent(fileName)
            csvText = ""
            csvText = "EAN,Menge,Name\n"
                for task in array {
                    let newLine = "\(task.ean),\(task.menge),\(task.name)\n"
                    csvText.append(newLine)
                }
            do {
                try csvText.write(to: b, atomically: true, encoding: String.Encoding.utf8)
                return true
            } catch {
                print("Failed to create file")
                print("\(error)")
                return false
            }
        } catch {
            print("Failed to create file")
            print("\(error)")
           return false
        }
    }
    
}
extension ProductDetailViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mylist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = mylist[indexPath.row].name
        cell.detailTextLabel?.text = String(mylist[indexPath.row].menge)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingesamt \(total)"
    }

}
