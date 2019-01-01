//
//  TableViewCell.swift
//  Geedesk
//
//  Created by Allvy on 14/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

protocol CustomDelegate: class {
    func didSelectItem()
}




class TableViewCell: UITableViewCell {
    @IBOutlet weak var ticketsTitle: UILabel!
     var delegate: CustomDelegate?
    @IBOutlet weak var detailTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//       detailTableView.delegate = self
//        detailTableView.dataSource = self
      //  detailTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 9
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell:InnerTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"InnerTableViewCell") as? InnerTableViewCell
//        if cell == nil{
//            tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
//            let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
//            cell = arrNib.first as? InnerTableViewCell
//           /// cell!.selcetTicket.add
//        }
//      //  cell!.delegate = self
//
//
//
//        cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//
//        return cell!
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("dsfsdf")
//        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketViewController") as? MyTicketViewController
//
//         delegate?.didSelectItem()
//       // self.navigationController?.pushViewController(vc!, animated: false)
//    }
//    @objc func buttonAction(sender: UIButton!) {
//        print("Button tapped")
//         delegate?.didSelectItem()
//        let detailOrderVC = MyTicketViewController()
//        self.inputViewController?.navigationController?.pushViewController(detailOrderVC, animated: true)
//    }
//
//}
//extension TableViewCell: CustomDelegate {
//    func didSelectItem() {
//        delegate?.didSelectItem()
//    }
//}

//extension ViewController: CustomDelegate {
////    func didSelectItem(record: String) {
////        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
////        if let detailVC = storyBoard.instantiateViewController(withIdentifier: "MyTicketViewController") as? MyTicketViewController {
////            self.navigationController?.pushViewController(detailVC, animated: true)
////        }
////    }
//}

}
