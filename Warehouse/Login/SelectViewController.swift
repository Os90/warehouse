//
//  SelectViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 04.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import Firebase

class SelectViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var imageUrl: UIImageView!
    
    var countSelect : Int?
    
    var db: DatabaseReference!
    
    var SelectProduct : Product?
    
    @IBOutlet weak var selectedTbl: UITableView!
    
    var key : String?
    
    var selectedProdcut = [VarianteColor?]()
    
    var sections = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database.database().reference()
        
        registerCell(tableName: selectedTbl, nibname: "SelectedCell", cell: "Cell")
        
        sections =  (selectedProdcut.count)
        
        
        guard let count = countSelect else {
            return
        }
        countLabel.text  = "\(count) ausgewählt"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneActio(_ sender: Any) {

        var totalStock = 0
        //alles auf False setzen
            for i in 0 ... sections - 1{
                guard let t  = selectedProdcut[i] else {return}
                for x in 0 ... t.varianten.count - 1{
                    selectedProdcut[i]?.varianten[x].selected = false
                    totalStock = totalStock + (selectedProdcut[i]?.varianten[x].stock)!
                }
            }
    
        SelectProduct?.total_stock = totalStock
        
        //hochladen

        guard let id = key,let myproduct = SelectProduct else {return}
        var changeProduct = myproduct
        changeProduct.colorVariante = selectedProdcut as! [VarianteColor]
        guard let dict = changeProduct.getDictionary() else {return}
        db.child(id).updateChildValues(dict, withCompletionBlock: {error, ref in

            if error != nil{
                print("ERROR")
            }
            else{
                print("ok")
                if let firstViewController = self.navigationController?.viewControllers[1] {
                    self.navigationController?.popToViewController(firstViewController, animated: true)
                }
            }
        })
        
        
    }
}
extension SelectViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        switch section {
            
        case 0:
            guard let c  = selectedProdcut[0]?.varianten.count else {return 0}
            count = c
            break
        case 1:
            guard let c  = selectedProdcut[1]?.varianten.count else {return 0}
            count = c
            break
        case 2:
            guard let c  = selectedProdcut[2]?.varianten.count else {return 0}
            count = c
            break
        case 3:
            guard let c  = selectedProdcut[3]?.varianten.count else {return 0}
            count = c
            break
        case 4:
            guard let c  = selectedProdcut[4]?.varianten.count else {return 0}
            count = c
            break
        default:
            return 0
        }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title : ColorForProduct
        switch section {
        case 0:
            guard let t = ColorForProduct(rawValue: (selectedProdcut[0]?.color).map { $0.rawValue }!) else {return ""}
            title = t
            break
        case 1:
            guard let t = ColorForProduct(rawValue: (selectedProdcut[1]?.color).map { $0.rawValue }!) else {return ""}
            title = t
            break
        case 2:
            guard let t = ColorForProduct(rawValue: (selectedProdcut[2]?.color).map { $0.rawValue }!) else {return ""}
            title = t
            break
        case 3:
            guard let t = ColorForProduct(rawValue: (selectedProdcut[3]?.color).map { $0.rawValue }!) else {return ""}
            title = t
            break
        case 4:
            guard let t = ColorForProduct(rawValue: (selectedProdcut[4]?.color).map { $0.rawValue }!) else {return ""}
            title = t
            break
        default:
            return ""
        }
        return title.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = selectedTbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectedTableViewCell
        
        if selectedProdcut[indexPath.section]?.varianten[indexPath.row].selected == true{
            cell.stepperOutlet.isHidden = false
        }else{
            cell.stepperOutlet.isHidden = true
        }
        
        if let stockCount = selectedProdcut[indexPath.section]?.varianten[indexPath.row].stock{
            cell.totalStockCell.text =  String(describing:stockCount)
            cell.stepperOutlet.value = Double(stockCount)
        }
        else {
            cell.totalStockCell.text =  "0"
        }
        cell.sizeCell.text = selectedProdcut[indexPath.section]?.varianten[indexPath.row].size
        
        cell.stepperOutlet.section = indexPath.section
        cell.stepperOutlet.row = indexPath.row
        cell.stepperOutlet.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        return cell
    }
    @IBAction func stepperValueChanged(_ stepper: MyControl) {
        let stepperValue = Int(stepper.value)
        let indexPath = IndexPath(row: stepper.row!, section: stepper.section!)
        selectedProdcut[indexPath.section]?.varianten[indexPath.row].stock = stepperValue
        selectedTbl.reloadData()
    }
}
extension UIViewController{

}
