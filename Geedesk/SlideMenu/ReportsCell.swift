//
//  EmailCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class ReportsCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel?
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard let item = item as? ProfileViewModelEmailItem else {
//                return
//            }
//
//            emailLabel?.text = item.email
//        }
//    }
//
//
    
    
    var item: Reports? {
        didSet {
            guard let item = item else {
                return
            }
            
            
             emailLabel?.text = item.reporttype
        }
    }
    

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
