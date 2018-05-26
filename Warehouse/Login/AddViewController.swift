//
//  AddViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 06.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth
import Firebase


class AddViewController: UIViewController,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var kategorieLabel: UILabel!
    
    @IBOutlet weak var nameEingabe: UITextField!
    
    @IBOutlet weak var imageSelected: UIImageView!
    
    @IBOutlet weak var picker: UIPickerView!

    var pickerData: [String] = [String]()
    var storageRef: StorageReference!
    
    var db: DatabaseReference!
    var a = Product.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database.database().reference()
        
        storageRef = Storage.storage().reference()
        
        pickerData = ["Männer","Frauen"]
        kategorieLabel.text = pickerData[0]
        nameEingabe.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        imageSelected.image = UIImage.init(named: "icons8-update_tag")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = nameEingabe.text else {
            nameEingabe.resignFirstResponder()
            return true
        }
        a.name = text
        nameLabel.text = "name : \(text)"
        nameEingabe.resignFirstResponder()
        return true
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        var data = NSData()
        let myimage = self.imageSelected.image!.resizeWithWidth(width: 200)!
        data = UIImageJPEGRepresentation(myimage, 0.5)! as NSData
        
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
    
    
    @IBAction func addPost(_ sender: Any) {
        
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let selectedImage : UIImage = image
        imageSelected.image=selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func saveAction(_ sender: Any) {
        uploadMedia() { url in
            if url != nil {
                self.a.imageUrl = [url!]
                guard let text = self.kategorieLabel.text else {return}
                self.a.kategorie = text
                self.a.gender = text
                self.a.colorVariante = [VarianteColor]()
                self.a.key = self.db.childByAutoId().key
                let x = self.a.getDictionary()
                self.db.child(self.a.key).setValue(x, withCompletionBlock: {error ,ref in
                    if error != nil{
                        let alert = UIAlertController(title: "Fehler beim erstellen", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Erfolgreich erstellt", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true)
                    }
                })
            }
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
        kategorieLabel.text = pickerData[row]
        //        a.kategorie = pickerData[row]
        //        a.gender = pickerData[row]
    }

}
extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
}
}
