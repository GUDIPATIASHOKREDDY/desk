//
//  InnerTableViewCell.swift
//  Geedesk
//
//  Created by Allvy on 14/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class InnerTableViewCell: UITableViewCell {
    @IBOutlet var selcetTicket: UIButton!
    
    @IBOutlet var id: UILabel!
    
    
    @IBOutlet var heading: UILabel!
    
    @IBOutlet var priority: RoundedLabel!
    
    
    
    @IBOutlet var department: UILabel!
    
    
    @IBOutlet var room: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
