//
//  TimeLineTableViewCell.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 26/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    @IBOutlet var date: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UILabel!
    
    @IBOutlet var solvedBy: UILabel!
    @IBOutlet var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
