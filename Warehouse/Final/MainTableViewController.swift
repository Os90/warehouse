//
//  MainTableViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 10.05.18.
//  Copyright © 2018 osman. All rights reserved.
//
import UIKit
import Firebase
import SwiftCSVExport

class MainTableViewController: UIViewController,UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var filter: UISearchBar!
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var scanBtn: UIBarButtonItem!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var filterArray  = ["Heute","Team","Ingesamt","Bestand 0"]
    
    var selectedFilter : String?
    
    var db: DatabaseReference!
    
    var dataProducts = [CustomProdutct]()
    var realDataProducts = [CustomProdutct]()
    
    var taskArr = [Task]()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(tableName: mytbl, nibname: "MainCell", cell: "Cell")
       
        indicator.startAnimating()
        dataFromServer()
        filter.placeholder = "name"
        filter.showsCancelButton = true
        filter.keyboardType = .default
        filter.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
//        guard let update = SessionStruct.updated else {return}
//        if update == true{
//            dataFromServer()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func scanBtnAct(_ sender: Any) {
        self.performSegue(withIdentifier: "scan", sender: self)
    }
    
    @IBAction func mach(_ sender: Any) {
        meins()
    }
    // MARK: CSV file creating
    func creatCSV(_ name : String) -> Void {
        let fileName = "\(name).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//        var csvText = "Color,Datum,EAN,image,karton,key,menge,name,position,size,sku,variantenID\n"
//
//        for task in taskArr {
//            let newLine = "\(task.color),\(task.date),\(task.ean),\(task.imageUrl),\(task.karton),\(task.key),\(task.menge),\(task.name),\(task.position),\(task.size),\(task.sku),\(task.vID)\n"
//            csvText.append(newLine)
//        }
        
        var csvText = ""
        if name == "kunde"{
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
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
    }
    
    func meins(){
        
       // CSVExport.export.enableStrictValidation = true
        
       var ii = 0
        for i in realDataProducts{
            ii = ii + 1
            task = Task()
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
            taskArr.append(task!)
        }
        creatCSV("bestand")
        
        
        taskArr.removeAll()
        ii = 0
        for i in realDataProducts{
            ii = ii + 1
            task = Task()
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
            
            if let local = taskArr.first(where: {$0.ean == i.ean}) {
                print("-----------")
                print("ID von local",local.id)
                print("ean von i",i.ean)
                print("ean von local",local.ean)
                print("menge von local",local.menge)
                print("menge von i",i.menge)
                local.menge += i.menge
                print("after menge von local",local.menge)
                if let index = taskArr.index(where: {$0.ean == i.ean}) {
                    print("index",index)
                    taskArr.remove(at: index)
                    taskArr.append(local)
                    //print("EAN after", taskArr[index].ean)
                    print("-----------")
                }
            }else{
                taskArr.append(task!)
            }
        }
         creatCSV("kunde")
        //https://bellisproduct-24167.firebaseio.com/bestand.json?menge=true
        //curl 'https://bellisproduct-24167].firebaseio.com/bestan.json'
    }
    
    func checkFirebaseConnection(){
        let connectedRef = db.child("bestand")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.indicator.stopAnimating()
                self.dataFromServer()
            } else {
                let alertController = UIAlertController(title:"Keine Internet Verbindung", message: "Nochmal versuchhen", preferredStyle:.alert)
                
                let Action = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
                    self.checkFirebaseConnection()
                }
                let CancelAction = UIAlertAction.init(title: "Abbrechen", style: .cancel) { (UIAlertAction) in
                    
                }
                alertController.addAction(Action)
                alertController.addAction(CancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func dataFromServer(){
         db = Database.database().reference()
        db.child("bestand").observe(.value, with: {(snapshot) in
           // print(snapshot)
            if snapshot.childrenCount > 0 {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                self.dataProducts.removeAll()
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //print(artists)
                    let a = CustomProdutct.init(snapshot: artists)
                    self.dataProducts.append(a)
                }
                self.realDataProducts = self.dataProducts
                
                if let a = SessionStruct.filter{
                    self.filterSearch()
                }else{
                    self.filterSearch(" ")
                }
            }
        }, withCancel: {
            error in
            let alertController = UIAlertController(title:"Ein Fehler ist aufgetreten", message: "Nochmal versuchhen", preferredStyle:.alert)
            
            let Action = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
                self.dataFromServer()
            }
            let CancelAction = UIAlertAction.init(title: "Abbrechen", style: .cancel) { (UIAlertAction) in
                
            }
            alertController.addAction(Action)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit"{
            let destinationVC = segue.destination as! ScanDetailViewController
            destinationVC.name = dataProducts[sender as! Int].name
            destinationVC.eanValueFrom = dataProducts[sender as! Int].ean
            destinationVC.date = dataProducts[sender as! Int].date
            destinationVC.karton = dataProducts[sender as! Int].karton
            destinationVC.menge = String(dataProducts[sender as! Int].menge)
            destinationVC.groeße = dataProducts[sender as! Int].size
            destinationVC.keyValue = dataProducts[sender as! Int].key
            destinationVC.position = dataProducts[sender as! Int].position
            destinationVC.detaiData = true
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
    func filterSearch(_ filterString: String = ""){
        
        guard let filter = SessionStruct.filter else {
                dataProducts = realDataProducts.filter{ $0.name.lowercased().contains(filterString.lowercased()) }
                mytbl.reloadData()
                return
            }
            switch filter{
            case "Heute":
                let todayDate = getDate().components(separatedBy: " ").first
                dataProducts = realDataProducts.filter{ $0.date.components(separatedBy: " ").first == todayDate}
                var realAfterFilter = [CustomProdutct]()
                realAfterFilter = dataProducts
                if filterString != ""{
                    dataProducts = realAfterFilter.filter{ $0.name.lowercased().contains(filterString.lowercased()) }

                }
                break;
            case "Team":
                print("Team")
                break;
            case "Ingesamt":
                dataProducts = realDataProducts
                if filterString != ""{
                    dataProducts = realDataProducts.filter{ $0.name.lowercased().contains(filterString.lowercased()) }
                }
                break;
            case "Bestand 0":
                dataProducts = realDataProducts.filter{ $0.menge == 0}
                var realAfterFilter = [CustomProdutct]()
                realAfterFilter = dataProducts
                if filterString != ""{
                    dataProducts = realAfterFilter.filter{ $0.name.lowercased().contains(filterString.lowercased()) }
                }
                break;
            default:
                break
            }
            mytbl.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataProducts = self.realDataProducts
        filter.text = ""
        filter.endEditing(true)
        filterSearch()
        mytbl.reloadData()
    }
    @IBAction func filter(_ sender: Any) {
        let alertView = UIAlertController(
            title: "",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(1, inComponent: 0, animated: true)
        alertView.view.addSubview(pickerView)
        
        let image = UIImage(named: "icons8-filter_filled") as UIImage?
        let button   = UIButton(type: .custom) as UIButton
        button.frame = CGRectMake(90, 0, 100, 100)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(MainTableViewController.btnTouched), for:.touchUpInside)
        
        
        alertView.view.addSubview(button)
        
        
        alertView.addAction(UIAlertAction(title: "Filtern", style: .default, handler: { (action: UIAlertAction!) in
            
            let attributedString = NSAttributedString(string: SessionStruct.filter ?? "© Warehouse",
                                                      attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10.0)])
            self.navigationItem.title = attributedString.string
            self.filterSearch()
            //self.filterSearch("Filter")
            //SessionStruct.filter = self.selectedFilter
        }))
        
        
        alertView.addAction(UIAlertAction(title: "Abbrechen", style: .destructive, handler: { (action: UIAlertAction!) in
            //self.selectedFilter = ""
            SessionStruct.filter = nil
            alertView.dismiss(animated: true, completion: nil)
        }))
        
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
        
    }
    
    @objc func btnTouched(){
        print("ok")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedFilter = filterArray[row]
        SessionStruct.filter = filterArray[row]
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
                    //self.dataFromServer()
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
extension UIViewController {
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
