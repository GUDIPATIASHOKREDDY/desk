//
//  NamePictureCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?
   // @IBOutlet weak var pictureImageView: UIImageView?
    
//    var item: ProfileViewModelItem? {
//        didSet {
//            guard let item = item as? ProfileViewModelNamePictureItem else {
//                return
//            }
//
//            nameLabel?.text = item.home
//           // pictureImageView?.image = UIImage(named: item.pictureUrl)
//        }
//    }
    
    
    var item: Home? {
        didSet {
            guard let item = item else {
                return
            }
            
           
            nameLabel?.text = item.dashboard
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        pictureImageView?.layer.cornerRadius = 50
//        pictureImageView?.clipsToBounds = true
//        pictureImageView?.contentMode = .scaleAspectFit
//        pictureImageView?.backgroundColor = UIColor.lightGray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
      //  pictureImageView?.image = nil
    }    
}
