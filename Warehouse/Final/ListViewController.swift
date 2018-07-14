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
    var countArray = [Int]()
    
     var pdfArray = [String]()
    
    @IBOutlet weak var exportBtn: UIButton!
    
    @IBOutlet weak var mytbl: UITableView!
    
    var kundeTaskArr = [Task]()
    var bestandTaskArr = [Task]()
    
     var taskArr = [Task]()
    
    @IBOutlet weak var infioLabel: UILabel!
    
     let defaults = UserDefaults.standard
    
    var excelCreated = false
    
    @IBOutlet weak var kundeLabel: UILabel!
    
    @IBOutlet weak var bestandLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            exportBtn.alpha = 0.5
            exportBtn.isEnabled = false
            checkForDate()

        exportBtn.layer.cornerRadius = 5
        exportBtn.layer.borderWidth = 1
        exportBtn.layer.borderColor = UIColor.white.cgColor
        
        createExportList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
//    func listFilesFromDocumentsFolder(_ myUrl : URL?) -> [Any]?
//    {
//        if let url = myUrl{
//            //var filesInFolder = [Any]()
//            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            let myFilesPath = documentDirectoryPath.appending("/CSV")
//            let files = FileManager.default.enumerator(atPath: myFilesPath)
//
//            while let file = files?.nextObject() {
//                filesInFolder.append(file)
//            }
//            return filesInFolder
//        }else{
//            return nil
//        }
//    }
    
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
//                print("-----------")
//                print("ID von local",local.id)
//                print("ean von i",i.ean)
//                print("ean von local",local.ean)
//                print("menge von local",local.menge)
//                print("menge von i",i.menge)
                local.menge += i.menge
               // print("after menge von local",local.menge)
                if let index = kundeTaskArr.index(where: {$0.ean == i.ean}) {
                    //print("index",index)
                    kundeTaskArr.remove(at: index)
                    kundeTaskArr.append(local)
                    //print("EAN after", taskArr[index].ean)
                    //print("-----------")
                }
            }else{
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

        print(customObjects.url_csv)
        print(kundeFile)
       
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [kundeFile,bestandFile], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    func createExportList(){
        createCsv(name: listArray[0])
        createCsv(name: listArray[1])
        
        exportBtn.alpha = 1.0
        exportBtn.isEnabled = true
        
        
        let todayDate = getDate().components(separatedBy: " ").first
        defaults.set(todayDate, forKey: "exportDate")
        infioLabel.text  = "Zuletzt exportiert : Heute!"
    }
    
    @IBAction func create(_ sender: Any) {
        
        createExportList()
        
    }
    
    func isKeyPresentInUserDefaults(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func checkForDate(){
       
        if isKeyPresentInUserDefaults("exportDate"){
            let date = defaults.value(forKey: "exportDate")
            infioLabel.text = "Zuletzt exportiert am \(date!)"
        }else{
            infioLabel.text = "Noch nie exportiert!"
        }
    }
    func createCsv(name : String){
        
        switch name {
        case "Kunde":
            let a = createCustomerArray()
            customObjects.kundeCount = a.count
            if saveCSV(name,a, customObjects.url_csv!){
                countArray.insert(customObjects.kundeCount!, at: 0)
                kundeLabel.text = "\(countArray[0])"
            }
            break
        case "Bestand":
            let a = createBestandArray()
            customObjects.bestandCount = a.count
            if saveCSV(name, a, customObjects.url_csv!){
                countArray.insert(customObjects.bestandCount!, at: 1)
                //bestandLabel.text = "Bestand : \(countArray[1]) Produkte"
            }
            break
        default:
            break
        }
        excelCreated = true
        
        
        
       // mytbl.reloadData()
    }

}

//extension ListViewController : UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
//
//        cell.mainLabel.text = "\(listArray[indexPath.row]).csv"
//
//        if excelCreated{
//            cell.doneImg.isHidden = false
//
//            cell.total.text = "\(countArray[indexPath.row]) Produkte"
//            UIView.animate(withDuration: 1.5, animations: {
//                    cell.doneImg.alpha = 1.0
//            })
//        }else{
//            cell.doneImg.isHidden = true
//        }
//        cell.selectionStyle = .none
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70.0
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Datein zur exportieren"
//    }
//}
