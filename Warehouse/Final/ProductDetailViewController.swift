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
    
    
    var kundeTaskArr = [Task]()
    
    var total = 0
    
    var selectedNamesFromView = [String]()
    
    var names = ""
    
    @IBOutlet weak var upload: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in selectedNamesFromView{
            let a = customObjects.listOfProducts.filter({$0.name.lowercased().components(separatedBy: "/").first == i.lowercased()})
            mylist  = mylist + a
            names.append("\(i)")
        }
        
        for x in mylist{
            total = total + x.menge
        }

        self.navigationItem.title = names
        
        mytbl.isEditing = true
        mytbl.allowsMultipleSelectionDuringEditing = true

    }

    
    func selectAllRows() {
        for section in 0 ..< mytbl.numberOfSections {
            for row in 0 ..< mytbl.numberOfRows(inSection: section) {
                mytbl.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
    }
    
    func deselectAllRows(){
        for section in 0 ..< mytbl.numberOfSections {
            for row in 0 ..< mytbl.numberOfRows(inSection: section) {
                mytbl.deselectRow(at: IndexPath(row: row, section: section), animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createCustomerArray(myarray : [CustomProdutct])->[Task]{

        var ii = 0
        for i in myarray{
            ii = ii + 1
            let task = Task()
            task.id = ii
            task.color = i.color
            task.date = i.date
            task.ean = i.ean
            task.imageUrl = i.imageUrl
            
            let karton = i.karton.replacingOccurrences(of: "und", with: "/")
            let karton2 = karton.replacingOccurrences(of: ",", with: "/")
            let karton3 = karton2.replacingOccurrences(of: " ", with: "")
            task.karton = karton3
            
            task.key = i.key
            task.menge = i.menge
            task.name = i.name
            task.position = i.position
            task.size = i.size
            task.sku = i.sku
            task.vID = i.vID
            
            if let local = kundeTaskArr.first(where: {$0.ean == i.ean}) {
                local.menge += i.menge
                if let index = kundeTaskArr.index(where: {$0.ean == i.ean}) {
                    kundeTaskArr.remove(at: index)
                    kundeTaskArr.append(local)
                }
            }else{
                kundeTaskArr.append(task)
            }
        }
        return kundeTaskArr
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
        
        let a = createCustomerArray(myarray: mySelectedArray)
        
        
        if saveCSV(names, a, customObjects.url_csv!) {
            let spezialFileKunde =  customObjects.url_csv?.appendingPathComponent("\(names)-für_Bestand.csv")
            let spezialFileBestand =  customObjects.url_csv?.appendingPathComponent("\(names)-für_Kunde.csv")
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [spezialFileKunde,spezialFileBestand], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        

    }
    func saveCSV(_ name : String, _ array : [Task], _ customUrl : URL) -> Bool {

        var fileName = "\(name)-für_Bestand.csv"
        // path = customUrl
        var b = customUrl.appendingPathComponent(fileName)

        var csvText = ""
            csvText = "ID,EAN,Name,Karton,Menge,Position,Größe\n"
            for task in array {
                let newLine = "\(task.id),\(task.ean),\(task.name),\(task.karton),\(task.menge),\(task.position),\(task.size)\n"
                csvText.append(newLine)
            }

        do {
            try csvText.write(to: b, atomically: true, encoding: String.Encoding.utf8)
            
            fileName = "\(name)-für_Kunde.csv"
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
          return mylist.count
        }
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0{
            cell.textLabel?.text = "Alle auswählen"
            cell.detailTextLabel?.text = "Ingesamt \(total)"
            //cell.textLabel?.textColor = UIColor.init(red: 55.0, green: 122.0, blue: 246.0, alpha: 1.0)
        }else{
            
            cell.textLabel?.text = mylist[indexPath.row].name
            cell.detailTextLabel?.text = String(mylist[indexPath.row].menge)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return " "
        }else{
              return "Ingesamt \(total)"
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            selectAllRows()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            deselectAllRows()
        }
    }

}
