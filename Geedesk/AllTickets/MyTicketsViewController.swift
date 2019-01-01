//
//  MyTicketsViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 20/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class MyTicketsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet var myTicketTableView: UITableView!
    
    var titles: String?
    var url:String?
     let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
      //  myProgressView.shared.showProgressView(self.view)
        self.myTicketTableView.tableFooterView = UIView()
       
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        myTicketTableView.addSubview(refreshControl)
       
        
        if titles == "AllTickets"
        {
        
            url = GeedeskConstants.alltickets
            self.title = "All Tickets"
        }
    
        if titles == "MyTickets"
        {
            url = GeedeskConstants.mytickets
            self.title = "My Tickets"
        }
        
        if titles == "timeline"
        {
            url = GeedeskConstants.timeline
            self.title = "Timeline"
        }
        
        if titles == "myteamtickets"
        {
            url = GeedeskConstants.myteamtickets
            self.title = "My Team Tickets"
        }
        if titles == "NewTickets"
        {
            url = GeedeskConstants.all_new_tickets
            self.title = "New Tickets"
        }
        if titles == "OpenTickets"
        {
            url = GeedeskConstants.all_open_tickets
            self.title = "Open Tickets"
        }
        if titles == "EscalatedTickets"
        {
             url = GeedeskConstants.sla_violated_tickets
            self.title = "Escalated Tickets"
            
        }
        if titles == "onHoldTickets"
        
        {
             url = GeedeskConstants.onHoldTickets
             self.title = "OnHold Tickets"
            
        }
        if titles == "ResolvedTickets"
        {
            url = GeedeskConstants.resolvedTickets
             self.title = "Resolved Tickets"
        }
        if titles == "DeletedTickets"
        {
             url = GeedeskConstants.DeletedTickets
            self.title = "Deleted Tickets"
            
        }
        if titles == "SceduledTickets"
        {
             url = GeedeskConstants.schduledTickets
             self.title = "Sceduled Tickets"
        }
        if titles == "Vipalerts"
        {
            url = GeedeskConstants.vipAlerts
            self.title = "VIP Alerts"
        }
        
        
        
        
        callAPI()
        
        
        
      //  print(url)
        
       
        

        // Do any additional setup after loading the view.
    }
    
    func callAPI()
    {
        
        print(url)
        
        myProgressView.shared.showProgressView(self.view)
        HttpWrapper.gets(with: url!, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            print(response)
            guard let data = response else { return }
            do {
                // myProgressView.shared.hideProgressView()
                
                let loginRespone = try JSONDecoder().decode(Array<newtickets>.self, from: data)
                
                print(loginRespone)
                
                
                SharedData.data.myTickets = loginRespone
                
                myProgressView.shared.hideProgressView()
                
                self.myTicketTableView.delegate = self
                self.myTicketTableView.dataSource = self
                self.myTicketTableView.reloadData()
                
                print(SharedData.data.myTickets?.count)
                
                
                
                
                //  print(SharedData.data.allRooms?[2].dept_name)
                
                
            } catch let jsonErr {
                myProgressView.shared.hideProgressView()
                print("Error serializing json:", jsonErr)
                
                self.showAlert(msg:"No Tickets found")
            }
            
            
        }){ (error) in
            myProgressView.shared.hideProgressView()
            self.showAlert(msg:"No Tickets found")
            
        }
        
    }
    
    @objc func refresh(_ sender: Any) {
        //  your code to refresh tableView
        
         callAPI()
        
        refreshControl.endRefreshing()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (SharedData.data.myTickets?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            var cell:InnerTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"InnerTableViewCell") as? InnerTableViewCell
            if cell == nil{
                tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
                let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
                cell = arrNib.first as? InnerTableViewCell
                
                
            }
            cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            
            cell?.selcetTicket.tag = Int((SharedData.data.myTickets?[indexPath.row].id)!)!
            
            cell?.id.text = SharedData.data.myTickets?[indexPath.row].id
            cell?.heading.text = SharedData.data.myTickets?[indexPath.row].ticket_heading
        
        if SharedData.data.myTickets?[indexPath.row].priority == "P1" || SharedData.data.myTickets?[indexPath.row].priority == "Critical"
        {
            cell?.priority.backgroundColor = UIColor(displayP3Red: 217.0/255.0, green: 83.0/255.0, blue: 84.0/255.0, alpha: 1)
            cell?.priority.text = "C"
            cell?.priority.textColor = UIColor.white
        }
        if SharedData.data.myTickets?[indexPath.row].priority == "P2" ||  SharedData.data.myTickets?[indexPath.row].priority == "High"
        {
            cell?.priority.backgroundColor = UIColor(displayP3Red: 241.0/255.0, green: 174.0/255.0, blue: 78.0/255.0, alpha: 1)
            cell?.priority.text = "H"
            cell?.priority.textColor = UIColor.white
        }
        if SharedData.data.myTickets?[indexPath.row].priority == "P3" || SharedData.data.myTickets?[indexPath.row].priority == "Medium"
        {
            cell?.priority.backgroundColor = UIColor(displayP3Red: 91.0/255.0, green: 193.0/255.0, blue: 223.0/255.0, alpha: 1)
            cell?.priority.text = "M"
            cell?.priority.textColor = UIColor.white
        }
        if SharedData.data.myTickets?[indexPath.row].priority == "P4" || SharedData.data.myTickets?[indexPath.row].priority == "Low"
        {
            cell?.priority.backgroundColor = UIColor.white
            cell?.priority.text = "L"
            cell?.priority.textColor = UIColor.black
        }
            //cell?.priority.text = SharedData.data.myTickets?[indexPath.row].priority
            cell?.department.text = SharedData.data.myTickets?[indexPath.row].queue_name
            cell?.room.text = SharedData.data.myTickets?[indexPath.row].dept_name
            
            
            
            
            // cell?.textLabel?.text = "dfgdfg"
            return cell!
        }
        
    
    @objc func buttonAction(sender: UIButton!) {
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "TicketDetailViewController") as? TicketDetailViewController
         vc?.ticketid = String(describing: sender.tag)
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
