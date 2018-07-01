//
//  ProductViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 29.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var forward: UIBarButtonItem!
    
    var cells = [IndexPath]()
    
    var mengeArray  = [Int]()
    
    var selectedNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in customObjects.productList{
            let b = customObjects.listOfProducts.filter({$0.name.lowercased().components(separatedBy: "/").first == i.lowercased()})
            var value = 0
            for x in b{
                value = value + x.menge
            }
            mengeArray.append(value)
        }
        mytbl.isEditing = true
        mytbl.allowsMultipleSelectionDuringEditing = true
        mytbl.reloadData()
   
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
//
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let selected_indexPaths = mytbl.indexPathsForSelectedRows{
            for indexPath in selected_indexPaths {
                print(indexPath.row)
                //selectedNames.append(customObjects.productList[indexPath.row])
                mytbl.deselectRow(at: indexPath, animated: true)
            }
        }
        selectedNames.removeAll()
        forward.isEnabled = false
        navigationItem.title = " \(0) Produkte ausgewählt"
    }
    
    @IBAction func forwardAction(_ sender: Any) {

        if let selected_indexPaths = mytbl.indexPathsForSelectedRows{
            for indexPath in selected_indexPaths {
                print(indexPath.row)
                selectedNames.append(customObjects.productList[indexPath.row])
            }
        }
        print(selectedNames)
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let detailController = segue.destination as! ProductDetailViewController
            //detailController.selectedName = customObjects.productList[sender as! Int]
            //detailController.total = mengeArray[sender as! Int]
            detailController.selectedNamesFromView = selectedNames
        }
    }
    
}
extension ProductViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customObjects.productList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.accessoryType = .checkmark
        
        cell.textLabel?.text = customObjects.productList[indexPath.row]
        
        if mengeArray.count > 0{
            cell.detailTextLabel?.text = String(mengeArray[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows!.count > 0{
            forward.isEnabled = true
        }else{
            forward.isEnabled = false
        }
        navigationItem.title = " \(tableView.indexPathsForSelectedRows!.count) Produkte ausgewählt"
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let a = tableView.indexPathsForSelectedRows {
            if a.count > 0{
                forward.isEnabled = true
            }else{
                forward.isEnabled = false
            }
            navigationItem.title = " \(a.count) Produkte ausgewählt"
        }else{
            forward.isEnabled = false
            navigationItem.title = " \(0) Produkte ausgewählt"
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "alle einzelne Produkte \(customObjects.productList.count)"
    }
}
