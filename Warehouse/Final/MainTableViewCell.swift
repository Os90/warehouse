//
//  MainTableViewCell.swift
//  Warehouse
//
//  Created by Osman Ashraf on 04.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameCell: UILabel!
    
    @IBOutlet weak var totalStockCell: UILabel!
    
    @IBOutlet weak var imageUrlCell: UIImageView!
    
    @IBOutlet weak var positionCell: UILabel!
    
    @IBOutlet weak var eanCell: UILabel!

    @IBOutlet weak var dateCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageUrlCell.image = UIImage.init(named: "icons8-unslash_filled")
        self.imageUrlCell.contentMode = .scaleToFill
        self.imageUrlCell.layer.cornerRadius = self.imageUrlCell.bounds.size.width / 2.0
        self.imageUrlCell.layer.masksToBounds = true
        
        totalStockCell.layer.cornerRadius = totalStockCell.frame.height / 2.0
        totalStockCell.textColor = UIColor.white
        totalStockCell.layer.backgroundColor = UIColor.blue.cgColor
        totalStockCell.layer.masksToBounds = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
