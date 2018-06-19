//
//  ListViewController.swift
//  Warehouse
//
//  Created by Osman A on 17.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    let myliste =  [NSURL]()
    
    var filesInFolder = [Any]()
    
    var listArray = ["Kunde","Bestand"]
    
     var pdfArray = [String]()
    
    @IBOutlet weak var exportBtn: UIButton!
    
    
    @IBOutlet weak var mytbl: UITableView!
    
    var kundeTaskArr = [Task]()
    var bestandTaskArr = [Task]()
    
     var taskArr = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         exportBtn.alpha = 0.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func listFilesFromDocumentsFolder(_ myUrl : URL?) -> [Any]?
    {
        if let url = myUrl{
            //var filesInFolder = [Any]()
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let myFilesPath = documentDirectoryPath.appending("/CSV")
            let files = FileManager.default.enumerator(atPath: myFilesPath)
            
            while let file = files?.nextObject() {
                filesInFolder.append(file)
            }
            return filesInFolder
        }else{
            return nil
        }
        

    }
    func createBestandArray()->[Task]{
        
        var ii = 0
        for i in customObjects.listOfProducts{
            ii = ii + 1
            var task = Task()
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
           // total = total + i.menge
            task.name = i.name
            task.position = i.position
            task.size = i.size
            task.sku = i.sku
            task.vID = i.vID
            bestandTaskArr.append(task)
        }
        
        return bestandTaskArr
    }
    func createCustomerArray()->[Task]{
        
       // var vorhandenArray  = createBestandArray()
        
        var ii = 0
        for i in customObjects.listOfProducts{
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
                print("-----------")
                print("ID von local",local.id)
                print("ean von i",i.ean)
                print("ean von local",local.ean)
                print("menge von local",local.menge)
                print("menge von i",i.menge)
                local.menge += i.menge
                print("after menge von local",local.menge)
                if let index = kundeTaskArr.index(where: {$0.ean == i.ean}) {
                    print("index",index)
                    kundeTaskArr.remove(at: index)
                    kundeTaskArr.append(local)
                    //print("EAN after", taskArr[index].ean)
                    print("-----------")
                }
            }else{
                //kundeTaskArr.append(task)
                
                kundeTaskArr.append(task)
            }
        }
        return kundeTaskArr
    }
    
    func saveCSV(_ name : String, _ array : [Task], _ customUrl : URL) -> Bool {
        taskArr.removeAll()
        taskArr = array
        let fileName = "\(name).csv"
       // path = customUrl
        let b = customUrl.appendingPathComponent(fileName)
        
        
        var csvText = ""
        if name == "Kunde"{
            csvText = "EAN,Menge,Name\n"
            for task in taskArr {
                let newLine = "\(task.ean),\(task.menge),\(task.name)\n"
                csvText.append(newLine)
            }
        }
        else{
            csvText = "ID,Color,Datum,EAN,Karton,Menge,Name,Position,Größe,SKU\n"
            for task in taskArr {
                let newLine = "\(task.id),\(task.color),\(task.date),\(task.ean),\(task.karton),\(task.menge),\(task.name),\(task.position),\(task.size),\(task.sku)\n"
                csvText.append(newLine)
            }
        }
        
        do {
            try csvText.write(to: b, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print("Failed to create file")
            print("\(error)")
            return false
        }
    }
    
    @IBAction func exportieren(_ sender: Any) {
        

        let kundeFile =  customObjects.url_csv?.appendingPathComponent("Kunde.csv")
        let bestandFile =  customObjects.url_csv?.appendingPathComponent("Bestand.csv")

        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [kundeFile,bestandFile], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func create(_ sender: Any) {
        
        createCsv(name: listArray[0])
        createCsv(name: listArray[1])
        
        exportBtn.alpha = 1.0
    }
    
    

}

extension ListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
       // cell.detailTextLabel?.text = pdfArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    func createCsv(name : String){
        
        switch name {
        case "Kunde":
            let a = createCustomerArray()
            if saveCSV(name,a, customObjects.url_csv!){
                print("csv erstellt",name,customObjects.url_csv)
            }
            break
        case "Bestand":
            if saveCSV(name, createBestandArray(), customObjects.url_csv!){
                print("csv erstellt",name,customObjects.url_csv)
            }
            break
        default:
            break
        }

    }
    
    

}
