//
//  VarianteAddViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 06.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import BarcodeScanner
import Firebase

class VarianteAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    var db: DatabaseReference!
    
    var tag : Int?
    
    @IBOutlet weak var saveLavel: UIBarButtonItem!
    
    @IBOutlet weak var eanLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    
    @IBOutlet weak var doneImage: UIImageView!
    
    var textField: UITextField?
    
    var key : String?
    
    var VariantenProduct : Product?
    
    fileprivate var mapViewController: BarcodeScannerController?
    
    var pickerData: [String] = [String]()
    
    var VariantenColor : String?
    
    @IBOutlet weak var colorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["S","M","L","XL"]
        guard let mapController = childViewControllers.last as? BarcodeScannerController else {
            fatalError("Check storyboard for missing MapViewController")
            
            
        }
//        case rot = "ROT"
//        case gelb = "GELB"
//        case weis = "WEIS"
        
        print(tag)
        
        switch VariantenColor {
        case "WEIS":
            colorLabel.backgroundColor = UIColor.white
        case "ROT":
            colorLabel.backgroundColor = UIColor.red

        case "GELB":
            colorLabel.backgroundColor = UIColor.yellow
        default:
            break
        }
        colorLabel.layer.borderWidth = 1.0
        colorLabel.layer.borderColor = UIColor.gray.cgColor
        colorLabel.layer.cornerRadius = colorLabel.frame.height / 2.0
        colorLabel.layer.masksToBounds = true
        
        
        
        db = Database.database().reference()
        saveLavel.isEnabled = false
       
        
        
        mapController.codeDelegate = self
        mapController.errorDelegate = self
        mapController.dismissalDelegate = self
        mapViewController = mapController

    }
    
    func checkUI(){
        if sizeLabel.text != "Größe" && stockLabel.text != "Stückzahl" && eanLabel.text != "EAN" && positionLabel.text != "Position"{
            
            DispatchQueue.main.async {
                self.saveLavel.isEnabled = true
            }

        }
        else{
            //print("fhelt")
        }
    }
    
    func updateDB(){
        var a = Variante()
        guard let ean = self.eanLabel.text,let size  = self.sizeLabel.text,let stock = Int(self.stockLabel.text!), let index = tag, let position = positionLabel.text else {return}
        
                    a.ean = ean
                    a.size = size
                    a.stock = stock
                    a.position = position
                    var myalle = VariantenProduct?.colorVariante[index].varianten
        
                    myalle?.append(a)
        
                    VariantenProduct?.colorVariante[index].varianten = myalle!
        
                    var totalStock = 0
        
                    if let sections = VariantenProduct?.colorVariante.count {
                        if sections > 0{
                            for i in 0 ... sections - 1{
                                if (VariantenProduct?.colorVariante[i].varianten.count)! > 0{
                                    for x in 0 ... (VariantenProduct?.colorVariante[i].varianten.count)! - 1{
                                        totalStock = totalStock + (VariantenProduct?.colorVariante[i].varianten[x].stock)!
                                    }
                                }
                            }
                        }
                    }else{
                        
                    }

                    VariantenProduct?.total_stock = totalStock
        
                    let dict = VariantenProduct?.getDictionary()
        
                    db.child(key!).updateChildValues(dict!, withCompletionBlock: {error, ref in
        
                        if error != nil{
                            //print("ERROR")
                        }
                        else{
                            //print("ok")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
    }
    
    @IBAction func saveActioon(_ sender: Any) {
        
        updateDB()
  
    }
    
    @IBAction func positionEingabe(_ sender: Any) {
        
        let alert = UIAlertController(title: "Position Eingabe", message: "Danke!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldForPosition)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
           // print("User click Ok button")
            guard let text = self.textField?.text else {return}
            self.positionLabel.text = text
            self.checkUI()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let vc = self.childViewControllers.last{
            vc.removeFromParentViewController()
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
        sizeLabel.text = pickerData[row]
        print(pickerData[row])
    }
    
    func someHandler(alert: UIAlertAction!) {
        print("PRINT")
        checkUI()
    }
    
    @IBAction func sizeButtom(_ sender: Any) {
        let alertView = UIAlertController(
            title: "Select item from list",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // comment this line to use white color
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: someHandler)
        let Cancelaction = UIAlertAction(title: "Canel", style: .cancel, handler: nil)
        alertView.addAction(action)
        alertView.addAction( Cancelaction)
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    
    

    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Stückzahl Eingeben Bitte";
            self.textField?.keyboardType = .numberPad
        }
    }
    
    
    func configurationTextFieldForEan(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "EAN Eingeben Bitte";
            self.textField?.keyboardType = .numberPad
        }
    }
    func configurationTextFieldForPosition(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Position Eingeben Bitte";
            self.textField?.keyboardType = .default
        }
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: "Stückzahl für diese Variante eingebe", message: "Danke!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            guard let text = self.textField?.text else {return}
            self.stockLabel.text = text
            self.checkUI()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func stockButton(_ sender: Any) {
       openAlertView()
    }
    
    @IBAction func eanEingabeButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "EAN eingabe", message: "Danke!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextFieldForEan)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            guard let text = self.textField?.text else {return}
            self.eanLabel.text = text
            self.checkUI()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
extension VarianteAddViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        eanLabel.text  = code
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.checkUI()
            self.mapViewController?.resetWithError()
        }
    }
}

extension VarianteAddViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension VarianteAddViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
