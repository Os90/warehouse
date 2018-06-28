//
//  ListTableViewCell.swift
//  Warehouse
//
//  Created by Osman A on 20.06.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var doneImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
