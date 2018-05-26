//
//  SelectedTableViewCell.swift
//  Warehouse
//
//  Created by Osman Ashraf on 04.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class SelectedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sizeCell: UILabel!
    
    @IBOutlet weak var totalStockCell: UILabel!
    
    @IBOutlet weak var stepperOutlet: MyControl!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepper(_ sender: Any) {
        
    }
    

}
