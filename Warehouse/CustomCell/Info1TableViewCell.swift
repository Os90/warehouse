//
//  Info1TableViewCell.swift
//  Warehouse
//
//  Created by Osman Ashraf on 02.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class Info1TableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftText: UILabel!
    
    @IBOutlet weak var rightText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
