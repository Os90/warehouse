//
//  ScanViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 10.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import BarcodeScanner
import Firebase
import AVFoundation

class ScanViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //Outlets
    
    @IBOutlet weak var importBtn: UIBarButtonItem!
    
    @IBOutlet weak var exportBtn: UIBarButtonItem!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var eanInputLbl: UIButton!
    
    @IBOutlet weak var eanOutputLbl: UILabel!
    
    var userdefaults = UserDefaults()
    
    //variablen
    fileprivate var mapViewController: BarcodeScannerController?
    
    //Firebase
    var db: DatabaseReference!
    
    var textField: UITextField?
    var textFieldPosition: UITextField?
    var textFieldKarton: UITextField?
    
    
    var pickerData: [String] = [String]()
    var size : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Database.database().reference()
        pickerData = ["Keine Größe","S","M","L","XL"]
//        checkForPrivacy()

        setupScanner()
        setupSubview()
    }
    
    func checkForPrivacy(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            setupScanner()
            setupSubview()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.setupScanner()
                    self.setupSubview()
                } else {
                    //access denied
                }
            })
        }
    }
    func setupScanner(){
        guard let mapController = childViewControllers.last as? BarcodeScannerController else {
            fatalError("Check storyboard for missing MapViewController")
        }
        mapController.codeDelegate = self
        mapController.errorDelegate = self
        mapController.dismissalDelegate = self
    }
    func setupSubview(){
        forwardButton.isEnabled = false
        
        if userdefaults.object(forKey: "income") != nil {
            importBtn.isEnabled = UserDefaults.standard.bool(forKey: "income")
        }
        else{
            importBtn.isEnabled = true
        }
        if userdefaults.object(forKey: "outcome") != nil {
            exportBtn.isEnabled = UserDefaults.standard.bool(forKey: "outcome")
        }
        else{
            exportBtn.isEnabled = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        size = pickerData[row]
    }
    
    func someHandler(alert: UIAlertAction!) {
        print("PRINT")
        //checkUI()
    }
    
    func configurationTextFieldMenge(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Stückzahl Eingeben Bitte";
            // self.textField?.becomeFirstResponder()
            self.textField?.keyboardType = .numberPad
        }
    }
    
    func configurationTextFieldPosition(textField: UITextField!) {
        if (textField) != nil {
            self.textFieldPosition = textField!        //Save reference to the UITextField
            self.textFieldPosition?.placeholder = "Position Eingeben Bitte";
            self.textFieldPosition?.becomeFirstResponder()
            self.textFieldPosition?.keyboardType = .numberPad
        }
    }
    func configurationTextFieldForEan(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "EAN Eingeben Bitte";
            self.textField?.keyboardType = .numberPad
            self.textField?.defaultTextAttributes = ["0":"Keine Stückzahl"]
        }
    }
    func configurationTextFieldKarton(textField: UITextField!) {
        if (textField) != nil {
            self.textFieldKarton = textField!        //Save reference to the UITextField
            self.textFieldKarton?.placeholder = "Karton Eingeben Bitte";
            //self.textFieldKarton?.becomeFirstResponder()
            self.textFieldKarton?.keyboardType = .numberPad
        }
    }
    
    
    func alertWithPickerAndTextField(_ name : String,_ caseInt : Int){
        let alertView = UIAlertController(
            title: "Größe Stückzahl eingeben",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        alertView.view.addSubview(pickerView)
        alertView.addTextField(configurationHandler: configurationTextFieldPosition)
        alertView.addTextField(configurationHandler: configurationTextFieldMenge)
        alertView.addTextField(configurationHandler: configurationTextFieldKarton)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alertView.addAction(UIAlertAction(title: "IST Zustand -> Ok,\(name).", style: .default, handler:{ (UIAlertAction) in
            guard let text = self.textField?.text, let textPosition = self.textFieldPosition?.text else {return}
            if text.isEmpty{
                // the alert view
                let alert = UIAlertController(title: "Fehler!", message: "Bitte ausfüllen", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                    return
                }
            }else{
                self.saveToFirebase(caseInt,stückzahl: text, size: self.size, ean: self.eanOutputLbl.text,position: textPosition,karton:self.textFieldKarton?.text)
            }
            
        }))
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    //actions
    @IBAction func eanInput(_ sender: Any) {
        let alert = UIAlertController(title: "EAN eingabe", message: "Danke!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldForEan)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            guard let text = self.textField?.text else {return}
            self.eanOutputLbl.text = text
            self.forwardButton.isEnabled = true
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            self.childViewControllers.last?.removeFromParentViewController()
            let destinationVC = segue.destination as! ScanDetailViewController
            destinationVC.eanValueFrom = eanOutputLbl.text
            destinationVC.firstScan = true
        }
    }
    
    
    @IBAction func forwardBtnAct(_ sender: Any) {
        var text = ""
        var caseInt = 0
        switch importBtn.isEnabled {
        case true:
            print("importiren wir")
            text = "einbuchen"
            caseInt = 0
        case false:
            print("exportiren wir")
            text = "ausbuchen"
            caseInt = 1
        default:
            break
        }
        self.performSegue(withIdentifier: "detail", sender: self)
        
        //alertWithPickerAndTextField(text,caseInt)
    }
    func saveToFirebase(_ caseVal : Int,stückzahl : String?, size : String?, ean: String?, position : String?,karton : String?){
        
        guard let stock = stückzahl,let eanValue = ean, let posValue = position else {
            
            var count = "0"
            if let amount = stückzahl{
                count = amount
            }
            if caseVal == 0{
                postWithParameter(count,pickerData[0],ean!,"keine Position","0")
            }else{
                updateWithParameter(count,pickerData[0],ean!,"keine Position")
            }
            return
        }
        var sizeInit = "Keine Größe"
        if let sizeValue = size{
            sizeInit = sizeValue
        }
        
        if caseVal == 0{
            postWithParameter(stock,sizeInit,eanValue,posValue,karton ?? "0")
        }else{
            updateWithParameter(stock,sizeInit,eanValue,posValue)
        }
        //        postWithParameter(stock,sizeValue,eanValue)
    }
    func postWithParameter(_ realStock : String,_ realSize : String, _ realEan : String,_ realPosition :String,_ realKarton :String){
        //realKarton
        var product = CustomProdutct()
        //product.menge = Int(realStock)!
        product.ean = realEan
        product.karton = realKarton
        product.size = realSize
        product.date = getDate()
        product.position = realPosition
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
                self.saveProcess("importieren",Int(realStock)!,realEan)
                let alert = UIAlertController(title: "Erfolgreich erstellt", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    for v in self.view.subviews{
//                        v.removeFromSuperview()
//                    }s
                    self.childViewControllers.last?.removeFromParentViewController()
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true)
            }
        })
    }
    
    func updateWithParameter(_ realStock : String,_ realSize : String, _ realEan : String, _ realPosition : String){
        
        
        // ean muss vorhanden sein um es zu exportieren ----
        let dict = ["menge":Int(realStock)!,"size":realSize,"position":realPosition] as [String : Any]
        db.child("bestand").child(realEan).updateChildValues(dict, withCompletionBlock: {error, ref in
            if error != nil{
                let alert = UIAlertController(title: "Fehler beim Exportieren", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true)
            }else{
                self.saveProcess("exportieren",Int(realStock)!,realEan)
                let alert = UIAlertController(title: "Erfolgreich Exporiert", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func outcomeAct(_ sender: Any){
        //        self.importBtn.isEnabled = true
        //        self.exportBtn.isEnabled = false
        //        userdefaults.set(self.exportBtn.isEnabled , forKey: "outcome")
        //        userdefaults.set(self.importBtn.isEnabled, forKey: "income")
    }
    
    
    @IBAction func incomeAct(_ sender: Any) {
        //        self.exportBtn.isEnabled = true
        //        self.importBtn.isEnabled = false
        //        userdefaults.set(self.importBtn.isEnabled, forKey: "income")
        //        userdefaults.set(self.exportBtn.isEnabled, forKey: "outcome")
    }
    
    func saveProcess(_ text : String,_ realStock : Int,_ realEan : String){
        
        let dict = ["vorgang":text,"ean":realEan,"menge":realStock,"view": "ScanView","datum": getDate()] as [String : Any]
        self.db.child("prozesse").child(text).childByAutoId().setValue(dict, withCompletionBlock: {error ,ref in
            if error != nil{
                //                let alert = UIAlertController(title: "Fehler beim erstellen", message: nil, preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                //                    self.navigationController?.popViewController(animated: true)
                //                }))
                
                //self.present(alert, animated: true)
            }else{
                //                let alert = UIAlertController(title: "Prozess erstellt", message: nil, preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                //                    self.navigationController?.popViewController(animated: true)
                //                }))
                // self.navigationController?.popViewController(animated: true)
                //self.present(alert, animated: true)
            }
        })
    }
    
    
}

extension ScanViewController: BarcodeScannerCodeDelegate,BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        //print("Barcode Data: \(code)")
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.eanOutputLbl.text = code
            self.forwardButton.isEnabled = true
            self.mapViewController?.resetWithError()
        }
    }
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        //print(error)
        //self.mapViewController?.resetWithError()
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension Double{
    func getDateStringFromUnixTime(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
extension UIViewController{
    
    func getDate()->String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
}
