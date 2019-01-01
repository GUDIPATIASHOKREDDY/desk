//
//  AboutCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class TicketsCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel?
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard  let item = item as? ProfileViewModelAboutItem else {
//                return
//            }
//
//            aboutLabel?.text = item.about
//        }
//    }
    
    
    var item: Tickets? {
        didSet {
            guard let item = item else {
                return
            }
            
//            if let pictureUrl = item.pictureUrl {
//                //  pictureImageView?.image = UIImage(named: pictureUrl)
//            }
//
             aboutLabel?.text = item.tickettype
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
