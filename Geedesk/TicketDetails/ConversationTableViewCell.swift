//
//  ConversationTableViewCell.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 22/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
