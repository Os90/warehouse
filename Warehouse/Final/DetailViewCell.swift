//
//  DetailTableViewCell.swift
//  Warehouse
//
//  Created by Osman Ashraf on 12.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {
    
    @IBOutlet weak var DetailLabel: UILabel!
    
    @IBOutlet weak var stepper: MyControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
