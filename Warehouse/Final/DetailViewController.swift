//
//  DetailViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 12.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var db: DatabaseReference!
     var storageRef: StorageReference!
    
    @IBOutlet weak var mytbl: UITableView!
    
    @IBOutlet weak var mainname: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var eanCode: UILabel!
    
    @IBOutlet weak var skuCode: UILabel!
    
    var key : String?
    var ean : String?
    
    var detailData : CustomProdutct?
    
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var imageUploadSucces = false
    
    var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView()
        db = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        getDataFromEan(key)
        

        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let _ = tapGestureRecognizer.view as! UIImageView
        imageFromPicker()
    }
    func imageFromPicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            print("Button capture")
            let imag = UIImagePickerController()
            imag.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    @objc func back(sender: UIBarButtonItem) {
        if saveBtn.isEnabled{
            let alert = UIAlertController(title: "Sicher, Ohne Speichern zurück kehren?", message: "Wenn sie nicht speichern, werden die Daten nicht akutalisert!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ja,Sicher!", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Nein, doch nicht", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func drawView(){
        registerCell(tableName: mytbl, nibname: "EditCell", cell: "Cell")
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "icons8-circled_chevron_left_filled")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        //self.image.contentMode = .scaleAspectFill
        self.image.layer.borderWidth = 0.2
        self.image.layer.borderColor = UIColor.lightGray.cgColor
        self.image.layer.cornerRadius = self.image.bounds.size.width / 2.0
        self.image.layer.masksToBounds = true
        
        saveBtn.isEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDataFromEan(_ realEan : String?){
        guard let eanValue = realEan else {return}
        db.child("bestand").child(eanValue).observe(.value, with: {(snapshot) in
            let a = CustomProdutct.init(snapshot: snapshot)
            self.detailData = a
            self.mytbl.reloadData()
            self.updateUI()
        }, withCancel: {
            error in
            print(error)
        })
    }
    func updateUI(){
        guard  let data = detailData else {
            return
        }
        mainname.text = data.name
        eanCode.text = data.ean
        skuCode.text = data.sku
        colorLabel.getRoundLabel(colorLabel)
    }
    @IBAction func saveAct(_ sender: Any) {
        var myurl = ""
        if imageUploadSucces{
            uploadMedia() { url in
                if let okurl = url{
                    myurl = okurl
                    self.detailData?.imageUrl = myurl
                     self.detailData?.date =  self.getDate()
                    guard let dict =  self.detailData.getDictionary() else {return}
                     self.db.child("bestand").child(( self.detailData?.key)!).updateChildValues(dict, withCompletionBlock: {error, ref in
                        if error != nil{
                            self.errorAlert()
                        }
                        else{
                            self.saveProcess("bearbeiten", (self.detailData?.menge)!, (self.detailData?.ean)!,(self.detailData?.key)!)
                            self.saveBtn.isEnabled = false
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        }else{
            detailData?.imageUrl = myurl
            detailData?.date = getDate()
            guard let dict = detailData.getDictionary() else {return}
            db.child("bestand").child((detailData?.key)!).updateChildValues(dict, withCompletionBlock: {error, ref in
                if error != nil{
                    self.errorAlert()
                }
                else{
                    self.saveProcess("bearbeiten", (self.detailData?.menge)!, (self.detailData?.ean)!,(self.detailData?.key)!)
                    self.saveBtn.isEnabled = false
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }

        
    }
    
    func saveProcess(_ text : String,_ realStock : Int,_ realEan : String,_ realKey : String){
        let dict = ["vorgang":text,"ean":realEan,"menge":realStock,"view": "DetailView","datum": getDate(),"key": realKey] as [String : Any]
        self.db.child("prozesse").child(text).childByAutoId().setValue(dict, withCompletionBlock: {error ,ref in
            if error != nil{
            }else{
            }
        })
    }
    func errorAlert(){
        let alert = UIAlertController(title: "Fehler beim speichern", message: "Überprüfen sie bitte Ihre Internet!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK,nochmals versuchen", style: .default, handler: { action in
            //self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Änderung verwerfen und wieder zurückkehen", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.keyboardType = .alphabet
        }
    }
    func alertOnDidSelect(_ index : Int){
        var myText = ""
        switch index {
        case 0:
            myText = "Bitte geben Sie den Namen ein"
        case 1:
            myText = "------"
        case 2:
            myText = "Bitte geben Sie die Position ein"
        case 3:
            myText = "Bitte geben Sie die Größe ein"
        case 4:
            myText = "Bitte geben Sie Karton Nummer ein"
        default:
            break
        }
        
        let alert = UIAlertController(title: myText, message: "Danke!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            guard let text = self.textField?.text else {return}
            self.handleReturnOfAlert(text, index)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func handleReturnOfAlert(_ text : String, _ index : Int){
        
        saveBtn.isEnabled = true
        
        switch index {
        case 0:
            detailData?.name = text
        case 1:
            detailData?.menge = Int(text)!
        case 2:
            detailData?.position = text
        case 3:
            detailData?.size = text
        case 4:
            detailData?.karton = text
        default:
            break
        }
        mytbl.reloadData()
        updateUI()
    }
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        var data = NSData()
        let myimage =  image.image?.resizeWithWidth(width: 200)!
        data = UIImageJPEGRepresentation(myimage!, 0.5)! as NSData
        
        self.storageRef.child("WarehouseProduct/").child(db.childByAutoId().key).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                completion(downloadURL)
            }
        }
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        saveBtn.isEnabled = true
        self.imageUploadSucces = true
        var pickimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let selectedImage : UIImage = pickimage
        image.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension DetailViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailViewCell
        
        guard  let data = detailData else {
            return cell
        }
        cell.stepper.isHidden = true
        switch indexPath.row {
        case 0:
            cell.DetailLabel.text = "Name: \(String(describing:data.name))"
            break
        case 1:
            cell.DetailLabel.text = "Menge: \(String(describing:data.menge))"
            cell.stepper.isHidden = false
            break
        case 2:
            cell.DetailLabel.text = "Position: \(data.position)"
            break
        case 3:
            cell.DetailLabel.text = "Größe:  \(data.size)"
            break
        case 4:
            cell.DetailLabel.text = "Karton:  \(data.karton)"
            break
        default:
            break
        }
        cell.stepper.value = Double(data.menge)
        cell.stepper.section = 0
        cell.stepper.row = indexPath.row
        cell.stepper.addTarget(self, action: #selector(self.stepperValueChanged(_:)), for: UIControlEvents.valueChanged)
        return cell
    }
    @IBAction func stepperValueChanged(_ stepper: MyControl) {
        saveBtn.isEnabled = true
        let stepperValue = Int(stepper.value)
        let indexPath = IndexPath(row: stepper.row!, section: stepper.section!)
        print(stepperValue)
        detailData!.menge = stepperValue
        mytbl.reloadData()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Produkt Details"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertOnDidSelect(indexPath.row)
    }
}
extension UIViewController{
    func registerCell(tableName : UITableView, nibname : String, cell : String){
        tableName.register(UINib.init(nibName:nibname, bundle: nil), forCellReuseIdentifier: cell)
    }
}
extension UILabel{
    func getRoundLabel(_ labelName : UILabel){
        labelName.layer.cornerRadius = labelName.frame.height / 2.0
        labelName.textColor = UIColor.white
        labelName.layer.backgroundColor = UIColor.blue.cgColor
        labelName.layer.masksToBounds = true
    }
}
