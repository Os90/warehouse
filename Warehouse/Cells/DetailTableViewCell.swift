//
//  DetailTableViewCell.swift
//  Warehouse
//
//  Created by Osman Ashraf on 04.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sizeCel: UILabel!
    @IBOutlet weak var stockCell: UILabel!
    @IBOutlet weak var eanCell: UILabel!
    @IBOutlet weak var positionCell: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //stockCell
        stockCell.layer.cornerRadius = stockCell.frame.height / 2.0
        stockCell.textColor = UIColor.white
        stockCell.layer.backgroundColor = UIColor.blue.cgColor
        stockCell.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDefaultValue(_ mywert : Bool){
       // stockCell.layer.cornerRadius = stockCell.frame.height / 2.0
        stockCell.textColor = UIColor.white
        stockCell.layer.backgroundColor = UIColor.blue.cgColor
        //stockCell.layer.masksToBounds = true
    }
}
