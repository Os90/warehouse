//
//  ScanDetailViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 02.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import Firebase

class ScanDetailViewController: UIViewController {
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var ean: UILabel!
    
    @IBOutlet weak var eanValue: UILabel!
    
    @IBOutlet weak var saveDetailsOutlet: UIBarButtonItem!
    
    var db: DatabaseReference!
    var menge : String?
    var groeße : String?
    var eanValueFrom : String?
    var position : String?
    var karton : String?
    var name : String?
    var date : String?
    var keyValue : String?
    var firstScan : Bool = false
    var detaiData : Bool = false
    var changeValue  = false

    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let value = eanValueFrom else {return}
        //eanValue.text = value
        saveDetailsOutlet.isEnabled = false
        self.navigationItem.title = value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func getLastID()->Int{
        let defaults = UserDefaults.standard
        if isKeyPresentInUserDefaults(key: "id"){
            var id = defaults.integer(forKey: "id")
            id = id + 1
            defaults.set(id, forKey: "id")
            return id
        }else{
            defaults.set(1, forKey: "id")
            return 1
        }
    }
    
    func postWithParameter(_ realStock : String,_ realSize : String, _ realEan : String,_ realPosition :String,_ realKarton :String, _ realName : String){
         db = Database.database().reference()
        var product = CustomProdutct()
        product.menge = Int(realStock) ?? 0
        product.name = realName
        product.ean = realEan
        product.karton = realKarton
        product.size = realSize
        product.date = getDate()
        product.position = realPosition
        product.id = getLastID()
        product.key = db.childByAutoId().key
        let productToSend = product.getDictionary()
        self.db.child("bestand").child(product.key).setValue(productToSend, withCompletionBlock: {error ,ref in
            if error != nil{
                let alert = UIAlertController(title: "Fehler beim erstellen", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true)
            }else{
                //self.saveProcess("importieren",Int(realStock)!,realEan)
                let alert = UIAlertController(title: "Erfolgreich erstellt", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    SessionStruct.updated = true
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    @IBAction func saveDetails(_ sender: Any) {
        if firstScan{
            self.postWithParameter(self.menge ?? "Keine Menge",self.groeße ?? "Keine Größe", eanValueFrom ?? "Keine EAN", self.position ?? "Keine Position", self.karton ?? "Kein Karton", self.name ?? "Kein Name")
        }
        else {
            self.updateWithParameter(self.menge ?? "Keine Menge",self.groeße ?? "Keine Größe", eanValueFrom ?? "Keine EAN", self.position ?? "Keine Position", self.karton ?? "Kein Karton", self.name ?? "Kein Name")
        }
    }
    func updateWithParameter(_ realStock : String,_ realSize : String, _ realEan : String,_ realPosition :String,_ realKarton :String, _ realName : String){
         db = Database.database().reference()
        var detailData = CustomProdutct.init()
        detailData.name = realName
        detailData.date = getDate()
        detailData.ean = realEan
        detailData.size = realSize
        detailData.menge = Int(realStock) ?? 0
        detailData.karton = realKarton
        detailData.position = realPosition
        detailData.key = keyValue!
        
        guard let dict = detailData.getDictionary(), let key = keyValue else {return}
        self.db.child("bestand").child(key).updateChildValues(dict, withCompletionBlock: {error, ref in
            if error != nil{
                let alert = UIAlertController(title: "Fehler beim Aktualisieren", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler: { action in
                    SessionStruct.updated = false
                }))
                
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: "Erfolgreich Aktualisiert", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    SessionStruct.updated = true
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
}

extension ScanDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! Info1TableViewCell
            cell.leftText.text = "Name"
            cell.rightText.text = name ?? "Kein Name"
            return cell
        }
        else {
            let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Info2TableViewCell
            switch indexPath.row {
            case 0:
                cell.leftText.text = "Uhrzeit"
                cell.rightText.text = date ?? getDate()
            case 2:
                cell.leftText.text = "Menge"
                cell.rightText.text = menge ?? "Keine Menge"
            case 3:
                cell.leftText.text = "Position"
                cell.rightText.text = position ?? "Keine Position"
            case 4:
                cell.leftText.text = "Größe"
                cell.rightText.text = groeße ?? "Keine Größe"
            case 5:
                cell.leftText.text = "Karton"
                cell.rightText.text = karton ?? "Kein Karton"
            default:
                break
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 78.0
        }
        else {
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Details zum Produkt"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
            saveDetailsOutlet.isEnabled = true
            addNewValue(indexPath.row)
        }
    }
    func addNewValue(_ indexValue : Int){
        var addText = ""
        var addSubtitle = ""
        var keyboardType  = UIKeyboardType.default
        switch indexValue {
        case 1:
            addText = "Name"
            addSubtitle = "Bitte geben Sie den Namen ein"
            keyboardType  = UIKeyboardType.alphabet
        case 2:
            addText = "Menge"
            addSubtitle = "Bitte geben Sie die Menge ein"
            keyboardType  = UIKeyboardType.numberPad
        case 3:
            addText = "Position"
            addSubtitle = "Bitte geben Sie die Position ein"
            keyboardType  = UIKeyboardType.numberPad
        case 4:
            addText = "Größe"
            addSubtitle = "Bitte geben Sie Größe ein"
            keyboardType  = UIKeyboardType.alphabet
        case 5:
            addText = "Karton"
            addSubtitle = "Bitte geben Sie die Karton Nummer ein"
            keyboardType  = UIKeyboardType.numberPad
        default:
            break
        }
        showInputDialog(title: addText,
                        subtitle: addSubtitle,
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "New number",
                        inputKeyboardType: keyboardType)
        { (input:String?) in
            print("The new number is \(input ?? "")")
            switch indexValue {
            case 1:
                self.name = input
            case 2:
                self.menge = input
            case 3:
                self.position = input
            case 4:
                self.groeße = input
            case 5:
                self.karton = input
            default:
                break
            }
            UIView.transition(with: self.mytbl,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.mytbl.reloadData() })
        }
    }
}
extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
