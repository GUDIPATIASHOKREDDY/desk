//
//  OpenTableViewCell.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 20/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class OpenTableViewCell: UITableViewCell {
    
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
