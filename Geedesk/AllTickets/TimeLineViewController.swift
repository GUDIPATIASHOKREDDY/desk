//
//  TimeLineViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 26/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var timeLineTableview: UITableView!
    var titles: String?
    var url:String?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if titles == "timeline"
        {
            url = GeedeskConstants.timeline
            self.title = "Timeline"
        }
        
        callAPI()
        // Do any additional setup after loading the view.
    }
    @objc func refresh(_ sender: Any) {
        //  your code to refresh tableView
        
        callAPI()
        
        refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
                
                let loginRespone = try JSONDecoder().decode(Array<TimeLine>.self, from: data)
                
                print(loginRespone)
                
                
                SharedData.data.timeLine = loginRespone
                
                myProgressView.shared.hideProgressView()
                
                self.timeLineTableview.delegate = self
                self.timeLineTableview.dataSource = self
                self.timeLineTableview.reloadData()
                
                print(SharedData.data.timeLine?.count)
                
                
                
                
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (SharedData.data.timeLine?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:TimeLineTableViewCell? = tableView.dequeueReusableCell(withIdentifier:"TimeLineTableViewCell") as? TimeLineTableViewCell
        if cell == nil{
            tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
            let arrNib:Array = Bundle.main.loadNibNamed("TimeLineTableViewCell",owner: self, options: nil)!
            cell = arrNib.first as? TimeLineTableViewCell
            
            
        }
       
       cell?.date.text = SharedData.data.timeLine?[indexPath.row].created_on
       cell?.profileImage.roundedImage()
       cell?.name.text = SharedData.data.timeLine?[indexPath.row].user_fname
        cell?.status.text = SharedData.data.timeLine?[indexPath.row].changed_value
        cell?.solvedBy.text = SharedData.data.timeLine?[indexPath.row].message?.message
        
        
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
