//
//  ViewController.swift
//  Geedesk
//
//  Created by Allvy on 14/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import Intercom

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var onHoldTickets: UITableView!
    
    @IBOutlet var scrollViewMain: UIScrollView!
    @IBOutlet var openTicketTableView: UITableView!
    
    @IBOutlet var newTicketTableView: UITableView!
    
    @IBOutlet weak var outerTableView: UITableView!
    
    var sourceVC: SplitViewController?
    
     let refreshControl1 = UIRefreshControl()
     let refreshControl2 = UIRefreshControl()
     let refreshControl3 = UIRefreshControl()
    let refreshControl4 = UIRefreshControl()
    
    var CCompanyLogoImage = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Intercom.enableLogging()
       
      
        //offsetFrom(date : "2018-12-16 10:05:30")
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "geedesk"))
        
        
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.newTicketTableView.refreshControl = refreshControl1
        newTicketTableView.addSubview(refreshControl1)
        
        
        
        refreshControl2.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl2.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.openTicketTableView.refreshControl = refreshControl2
        openTicketTableView.addSubview(refreshControl2)
       
        refreshControl3.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl3.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.onHoldTickets.refreshControl = refreshControl3
         onHoldTickets.addSubview(refreshControl3)
        
        scrollViewMain.isUserInteractionEnabled = true;
        scrollViewMain.isScrollEnabled = true;
        scrollViewMain.alwaysBounceVertical = true
        self.scrollViewMain.insertSubview(refreshControl4, at: 0)
        refreshControl4.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl4.addTarget(self, action: #selector(refresh), for: .valueChanged)
       // self.view.refreshControl = refreshControl1
        self.scrollViewMain.addSubview(refreshControl4)
       
    
    }

    
    
    @IBAction func SlideButton(_ sender: Any) {
        
       self.slideMenuController()?.openLeft()
        
    }
    
    @objc func refresh(_ sender: Any) {
        //  your code to refresh tableView
        
        callAPI()
        
        refreshControl1.endRefreshing()
         refreshControl2.endRefreshing()
         refreshControl3.endRefreshing()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        callAPI()
  
    }
    
    
    func callAPI()
    {
        myProgressView.shared.showProgressView(self.view)
        
        let homePageTickets = GeedeskConstants.homePageTickets + UserDefaults.standard.string(forKey: "access_token")!
        
        HttpWrapper.gets(with: homePageTickets, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            // print(response)
            guard let data = response else { return }
            do {
                
                let loginRespone = try JSONDecoder().decode(Array<HomeAllTickets>.self, from: data)
                
                print(loginRespone)
                
                
                SharedData.data.homeAllTickets = loginRespone
                
                myProgressView.shared.hideProgressView()
                
                
               
                self.newTicketTableView.delegate = self
                self.newTicketTableView.dataSource = self
                self.openTicketTableView.delegate = self
                self.openTicketTableView.dataSource = self
                self.onHoldTickets.dataSource = self
                self.onHoldTickets.delegate = self
                self.newTicketTableView.reloadData()
                self.openTicketTableView.reloadData()
                self.onHoldTickets.reloadData()
                
                
                
                
            } catch let jsonErr {
                myProgressView.shared.hideProgressView()
                print("Error serializing json:", jsonErr)
                
                self.showAlert(msg:"internal server error")
            }
            
            
        }){ (error) in
            myProgressView.shared.hideProgressView()
            self.showAlert(msg:"internal server error")
            
        }
        
    }
    
   func numberOfSections(in tableView: UITableView) -> Int
    {
        
        if tableView == newTicketTableView
        {
        
            let numOfSection: NSInteger = (SharedData.data.homeAllTickets?[0].new_tickets?.count)!
        
        if numOfSection == 0
        {
            
//            self.newTicketTableView.backgroundView = nil
//            numOfSection = 1
            
            let noDataLabel: UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.newTicketTableView.frame.width, height: self.newTicketTableView.frame.height))
            noDataLabel.backgroundColor = .white
            newTicketTableView.separatorStyle = .none
            noDataLabel.text = "Hooray,No New Tickets"
            noDataLabel.textAlignment = NSTextAlignment.center
            self.newTicketTableView.backgroundView = noDataLabel
             return 1
            
        }
        else
        {
            
             return 1
        }
        
     //   return numOfSection
            
        }
        
        
        
        if tableView == openTicketTableView
        
        {
            
            let numOfSection: NSInteger = (SharedData.data.homeAllTickets?[1].open_tickets?.count)!
            
            if numOfSection == 0
            {
                
                //            self.newTicketTableView.backgroundView = nil
                //            numOfSection = 1
                
                let noDataLabel: UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.openTicketTableView.frame.width, height: self.openTicketTableView.frame.height))
                noDataLabel.backgroundColor = .white
               openTicketTableView.separatorStyle = .none
                noDataLabel.text = "Hooray,No Open Tickets"
                noDataLabel.textAlignment = NSTextAlignment.center
                self.openTicketTableView.backgroundView = noDataLabel
                 return 1
            }
            else
            {
                
                return 1
            }
            
        }
        
        if tableView == onHoldTickets
            
        {
            
          //  print(SharedData.data.homeAllTickets?[2].onhold_tickets)
            let numOfSection: NSInteger = (SharedData.data.homeAllTickets?[2].onhold_tickets?.count)!
            
            if numOfSection == 0
            {
                
                //            self.newTicketTableView.backgroundView = nil
                //            numOfSection = 1
                
                let noDataLabel: UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.onHoldTickets.frame.width, height: self.onHoldTickets.frame.height))
                noDataLabel.backgroundColor = .white
                onHoldTickets.separatorStyle = .none
                noDataLabel.text = "Hooray,No OnHold Tickets"
                noDataLabel.textAlignment = NSTextAlignment.center
                self.onHoldTickets.backgroundView = noDataLabel
                 return 1
                
            }
            else
            {
                
                return 1
            }
            
        }
        
        return 1
       
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == newTicketTableView
        {
            return ((SharedData.data.homeAllTickets?[0].new_tickets?.count)!)
        }
        
        if tableView == openTicketTableView
        {
            
     // print(haredData.data.homeAllTickets?[1].open_tickets?.count)
            
            
            
            return (SharedData.data.homeAllTickets?[1].open_tickets?.count)!
            
        }
        if tableView == onHoldTickets
        {
            return (SharedData.data.homeAllTickets?[2].onhold_tickets?.count)!
        }
        
       return 1
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == newTicketTableView
        {
            var cell:InnerTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"InnerTableViewCell") as? InnerTableViewCell
            if cell == nil{
                tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
                let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
                cell = arrNib.first as? InnerTableViewCell
                

            }
            
            cell?.selcetTicket.tag = Int((SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].id)!)!
            cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
           // cell?.selcetTicket.setTitle(SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].id, for: .normal)
            if SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].priority == "P1"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 217.0/255.0, green: 83.0/255.0, blue: 84.0/255.0, alpha: 1)
                cell?.priority.text = "C"
                 cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].priority == "P2"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 241.0/255.0, green: 174.0/255.0, blue: 78.0/255.0, alpha: 1)
                cell?.priority.text = "H"
                cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].priority == "P3"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 91.0/255.0, green: 193.0/255.0, blue: 223.0/255.0, alpha: 1)
                cell?.priority.text = "M"
                 cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].priority == "P4"
            {
                cell?.priority.backgroundColor = UIColor.white
                cell?.priority.text = "L"
                 cell?.priority.textColor = UIColor.black
            }
            
         
            
            cell?.id.text = SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].id
            cell?.heading.text = SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].ticket_heading
            cell?.department.text = SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].queue_name
            cell?.room.text = SharedData.data.homeAllTickets?[0].new_tickets?[indexPath.row].dept_name
            
            
            
            
           // cell?.textLabel?.text = "dfgdfg"
            return cell!
        }
        if tableView == openTicketTableView
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenTableViewCell", for: indexPath) as? OpenTableViewCell
            
           // let cell:OpenTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"OpenTableViewCell") as? OpenTableViewCell
//            if cell == nil{
//                tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
//                let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
//                  cell = arrNib.first as? InnerTableViewCell
//
//
//            }
            
            //cell!.textLabel?.text = "dfdgg"
            
            if SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].priority == "P1"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 217.0/255.0, green: 83.0/255.0, blue: 84.0/255.0, alpha: 1)
                cell?.priority.text = "C"
                cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].priority == "P2"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 241.0/255.0, green: 174.0/255.0, blue: 78.0/255.0, alpha: 1)
                cell?.priority.text = "H"
                cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].priority == "P3"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 91.0/255.0, green: 193.0/255.0, blue: 223.0/255.0, alpha: 1)
                cell?.priority.text = "M"
                cell?.priority.textColor = UIColor.white
            }
            if SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].priority == "P4"
            {
                cell?.priority.backgroundColor = UIColor.white
                cell?.priority.text = "L"
                cell?.priority.textColor = UIColor.black
            }
            
            
            
            
            
            cell?.id.text = SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].id
            cell?.heading.text = SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].ticket_heading
//            cell?.priority.text = SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].priority
            cell?.department.text = SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].queue_name
            cell?.room.text = SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].dept_name
             cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
             cell?.selcetTicket.tag = Int((SharedData.data.homeAllTickets?[1].open_tickets?[indexPath.row].id)!)!
            print(indexPath.row)
           // print(SharedData.data.homeAllTickets?[1].open_tickets?[0].id)
            
//            cell?.id.text = SharedData.data.homeAllTickets?[1].open_tickets?[0].id
//            cell?.heading.text = SharedData.data.homeAllTickets?[1].open_tickets?[0].ticket_heading
//            cell?.priority.text = SharedData.data.homeAllTickets?[1].open_tickets?[0].priority
//            cell?.department.text = SharedData.data.homeAllTickets?[1].open_tickets?[0].dept_name
//            cell?.room.text = SharedData.data.homeAllTickets?[1].open_tickets?[0].dept_name
//            //
            // cell?.textLabel?.text = "dfgdfg"
            return cell!
            
            
        }
        
        
        if tableView == onHoldTickets
        {
            
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "onHoldTableViewCell", for: indexPath) as? OnHoldTableViewCell
            
            
//            var cell:onHoldTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"onHoldTableViewCell") as? onHoldTableViewCell
//            if cell == nil{
//                tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
//                let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
//                cell = arrNib.first as? InnerTableViewCell
//                
//                
//            }
            
             cell?.selcetTicket.tag = Int((SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].id)!)!
            cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            
            
            
            if SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].priority == "P1"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 217.0/255.0, green: 83.0/255.0, blue: 84.0/255.0, alpha: 1)
                cell?.priority.text = "C"
                cell?.priority.textColor = UIColor.white
            }
            if  SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].priority == "P2"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 241.0/255.0, green: 174.0/255.0, blue: 78.0/255.0, alpha: 1)
                cell?.priority.text = "H"
                cell?.priority.textColor = UIColor.white
            }
            if  SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].priority == "P3"
            {
                cell?.priority.backgroundColor = UIColor(displayP3Red: 91.0/255.0, green: 193.0/255.0, blue: 223.0/255.0, alpha: 1)
                cell?.priority.text = "M"
                cell?.priority.textColor = UIColor.white
            }
            if  SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].priority == "P4"
            {
                cell?.priority.backgroundColor = UIColor.white
                cell?.priority.text = "L"
                cell?.priority.textColor = UIColor.black
            }
            
            
            
            
            
            
        //    SharedData.data.homeAllTickets?[2].onhold_tickets?.count

            cell?.id.text = SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].id
            cell?.heading.text = SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].ticket_heading
          //  cell?.priority.text = SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].priority
            cell?.department.text = SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].queue_name
            cell?.room.text = SharedData.data.homeAllTickets?[2].onhold_tickets?[indexPath.row].dept_name
//
//             cell?.textLabel?.text = "dfgdfg"
            return cell!
            
            
            
        }
        
        return UITableViewCell()
    
       

    }
    
    
    @IBAction func NotificationBarButton(_ sender: Any) {
        
        
        
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "NotificationViewController") as? NotificationViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
    
    
    
    
    
    
    @IBAction func CreateTicket(_ sender: Any) {
        
        
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "CreateTicketViewController") as? CreateTicketViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "TicketDetailViewController") as? TicketDetailViewController
        
        
        print(String(describing: sender.tag))
        
        vc?.ticketid = String(describing: sender.tag)
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
//        if tableView.tag == 2
//        {
//            //  print("dsfsdf")
//        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketViewController") as? MyTicketViewController
//        self.navigationController?.pushViewController(vc!, animated: false)
//        }
    }
    
  
    
//    func didSelectItem() {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailVC = storyBoard.instantiateViewController(withIdentifier: "MyTicketViewController") as? MyTicketViewController {
//            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }
    
    
}



