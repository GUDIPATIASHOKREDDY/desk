//
//  VIPAlertsViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 21/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class VIPAlertsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var count: UILabel!
    
    @IBOutlet var vipTableview: UITableView!
    
    var titles: String?
    var url:String?
    
     let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.vipTableview.tableFooterView = UIView()
        
        if titles == "Vipalerts"
        {
            url = GeedeskConstants.vipAlerts
            self.title = "VIP Alerts"
        }
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        vipTableview.addSubview(refreshControl)
        
        
     
        callAPI()
        
        
        
        
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: Any) {
        //  your code to refresh tableView
        
        callAPI()
        
        refreshControl.endRefreshing()
    }
    
    
    func callAPI()
    {
        
        myProgressView.shared.showProgressView(self.view)
        
        
        HttpWrapper.gets(with: url!, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            print(response)
            guard let data = response else { return }
            do {
                // myProgressView.shared.hideProgressView()
                
                let loginRespone = try JSONDecoder().decode(Array<VipAlert>.self, from: data)
                
                
                
                SharedData.data.vipAlert = loginRespone
                
                let count = String(describing: (SharedData.data.vipAlert?.count)!)
                
                self.count.text = "VIP Alerts("  + "\((count))" + ")"
                
                
                
                print(SharedData.data.vipAlert?.count)
                myProgressView.shared.hideProgressView()
                
                self.vipTableview.delegate = self
                self.vipTableview.dataSource = self
                self.vipTableview.reloadData()
                //
                print(SharedData.data.myTickets?.count)
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (SharedData.data.vipAlert?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:InnerTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"InnerTableViewCell") as? InnerTableViewCell
        if cell == nil{
            tableView.register(UINib.init(nibName: "InnerTableViewCell", bundle: nil), forCellReuseIdentifier: "InnerTableViewCell")
            let arrNib:Array = Bundle.main.loadNibNamed("InnerTableViewCell",owner: self, options: nil)!
            cell = arrNib.first as? InnerTableViewCell
            
            
        }
    //    cell?.selcetTicket.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        
        
        cell?.id.text = SharedData.data.vipAlert?[indexPath.row].id
        cell?.heading.text = SharedData.data.vipAlert?[indexPath.row].dept_name
     //   cell?.priority.text = SharedData.data.myTickets?[indexPath.row].priority
        cell?.department.text = "\(String(describing: (SharedData.data.vipAlert?[indexPath.row].user_fname)!))" + " " + "\(String(describing: (SharedData.data.vipAlert?[indexPath.row].user_lname)!))"
        cell?.room.text = getDateTimeDiff(dateStr:(SharedData.data.vipAlert?[indexPath.row].alert_raised_on)!)
            
            
            //SharedData.data.vipAlert?[indexPath.row].alert_raised_on

        
        
        
        // cell?.textLabel?.text = "dfgdfg"
        return cell!
    }
    

}
