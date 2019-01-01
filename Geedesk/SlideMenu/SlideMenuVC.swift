
import UIKit

protocol SideMenuDelegate: class {
    func pushView(from vc:SlideMenuVC, toViewController id: String)
}

class SlideMenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet var slidemenuProfile: UIImageView!
    
    fileprivate let viewModel = ProfileViewModel()
    @IBOutlet weak var sideTableView: UITableView!
    
    var reloadSections: ((_ section: Int) -> Void)?

     weak var delegate: SideMenuDelegate?
    let defaults = UserDefaults.standard
    var termsServiceView:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        slidemenuProfile.roundedImage()
        
       
            
            //UIColor(red: 2.0, green: 146.0, blue: 252.0, alpha: 1.0).cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        slidemenuProfile.isUserInteractionEnabled = true
        slidemenuProfile.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        
        
        
        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.sideTableView?.beginUpdates()
            self?.sideTableView?.reloadSections([section], with: .fade)
            self?.sideTableView?.endUpdates()
        }
        
        sideTableView.tableFooterView = UIView()
        
        sideTableView?.estimatedRowHeight = 40
        sideTableView?.rowHeight = UITableViewAutomaticDimension
        sideTableView?.sectionHeaderHeight = 40
        //tableView?.separatorStyle = .none
       
        sideTableView?.register(TicketsCell.nib, forCellReuseIdentifier: TicketsCell.identifier)
        sideTableView?.register(HomeCell.nib, forCellReuseIdentifier: HomeCell.identifier)
        sideTableView?.register(OtherCell.nib, forCellReuseIdentifier: OtherCell.identifier)
        sideTableView?.register(AddOneCell.nib, forCellReuseIdentifier: AddOneCell.identifier)
        sideTableView?.register(ReportsCell.nib, forCellReuseIdentifier: ReportsCell.identifier)
        sideTableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        
        
       
        sideTableView.delegate = self
         sideTableView.dataSource = self
        print(viewModel.items)
//        sideTableView?.dataSource = viewModel
     //  sideTableView?.delegate = viewModel
      //  sideTableView?.delegate = self
       
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        termsServiceView = true
        self.slideMenuController()?.closeLeft()
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "ProfileViewController") as? ProfileViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
        // Your action
    }

    override func viewWillAppear(_ animated: Bool) {
        termsServiceView = false
        print("viewWillAppear")
        
        if  SharedData.data.image != nil
        {
            slidemenuProfile.image = SharedData.data.image
        }
  
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if termsServiceView == true
        
        {
            self.navigationController?.navigationBar.isHidden = false
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        print(viewModel.items.count)
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = viewModel.items[section]
        guard item.isCollapsible else {
            return item.rowCount
        }
        
        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .nameAndPicture:
            
            
            if let item = item as? ProfileViewModelNamePictureItem, let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell {
                let friend = item.home[indexPath.row]
                cell.item = friend
                return cell
            }
        case .about:
            
            
            if let item = item as? ProfileViewModelAboutItem, let cell = tableView.dequeueReusableCell(withIdentifier: TicketsCell.identifier, for: indexPath) as? TicketsCell {
                let friend = item.tickets[indexPath.row]
                cell.item = friend
                return cell
            }
            
            
        case .email:
            
            if let item = item as? ProfileViewModelEmailItem, let cell = tableView.dequeueReusableCell(withIdentifier: ReportsCell.identifier, for: indexPath) as? ReportsCell {
                let friend = item.reports[indexPath.row]
                cell.item = friend
                return cell
            }
            
        case .friend:
            if let item = item as? ProfileViewModeFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: OtherCell.identifier, for: indexPath) as? OtherCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ProfileViewModeAttributeItem, let cell = tableView.dequeueReusableCell(withIdentifier: AddOneCell.identifier, for: indexPath) as? AddOneCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                 self.slideMenuController()?.closeLeft()
            }
            
            if indexPath.row == 1
                
            {
                termsServiceView = true
                 self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "AllTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 2
                
            {
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "MyTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 3
                
            {
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "TimeLineViewController") as? TimeLineViewController
                vc?.titles = "timeline"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 4
                
            {
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "myteamtickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            
            
            
            print(indexPath.row)
        }
        if indexPath.section == 1
        {
             if indexPath.row == 0
             {
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "NewTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
                
            }
            
            if indexPath.row == 1
            {
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "OpenTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 2
            {
               
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "EscalatedTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 3
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "onHoldTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 4
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "ResolvedTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 5
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "DeletedTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 6
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "MyTicketsViewController") as? MyTicketsViewController
                vc?.titles = "SceduledTickets"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 7
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "VIPAlertsViewController") as? VIPAlertsViewController
                vc?.titles = "Vipalerts"
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            
            
        }
        
        
        if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "BasicReportsViewController") as? BasicReportsViewController
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
        }
        
        
        
        if indexPath.section == 4
        {
            
            
            if indexPath.row == 1
            {
                
                termsServiceView = true
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "TermsandConditionViewController") as? TermsandConditionViewController
                self.navigationController?.pushViewController(vc!, animated: false)
                return
            }
            if indexPath.row == 2
            {
                
                 termsServiceView = true
                //PrivacyPolicyViewController
                self.navigationController?.navigationBar.isHidden = false
                
                self.slideMenuController()?.closeLeft()
                let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
                self.navigationController?.pushViewController(vc!, animated: false)
                return
               
            }
            if indexPath.row == 3
            {
                
                
                self.slideMenuController()?.closeLeft()
                
                var params: [String:Any] = [:]
                params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
                params["device_IMEI_MEID_ESN"]  = getUUID()
                print(params)
                myProgressView.shared.showProgressView(self.view)
                print(params)
                
               
                HttpWrapper.post(with: GeedeskConstants.logout, parameters: params, headers: nil, completionHandler: { (response) in
                    
                    print(response)
                    print(response["status"] as! String)
                    myProgressView.shared.hideProgressView()
                    if response["status"]! as! String  == "success"
                    {
                       
                        self.defaults.set(nil, forKey: "access_token")
                       
                       
                        _ = UIApplication.shared.delegate as! AppDelegate
                        let id = "NavigationView"
                        let vc = UIStoryboard.getViewController(storyboardName: "Main", storyboardId: id)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = vc
                            appDelegate.window?.makeKeyAndVisible()
                        }
                        
                    }else
                    {
                        self.showAlert(msg:response["msg"]! as! String)
                    }
                }){ (error) in
                    myProgressView.shared.hideProgressView()
                    
                }
                
                
               // self.slideMenuController()?.closeLeft()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = viewModel.items[section]
            
            let borderTop = UIView(frame: CGRect(x:0, y:0, width: tableView.bounds.size.width, height: 1.0))
            borderTop.backgroundColor = UIColor.self.init(red: 48/255, green: 186/255, blue: 160/255, alpha: 1.0)
            headerView.addSubview(borderTop)
            
            let borderBottom = UIView(frame: CGRect(x:0, y:40, width: tableView.bounds.size.width, height: 1.0))
            borderBottom.backgroundColor = UIColor.self.init(red: 48/255, green: 186/255, blue: 160/255, alpha: 1.0)
            headerView.addSubview(borderBottom)
            
            
            headerView.item = item
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }

    
    
   
    
    
   
    
}

extension SlideMenuVC: HeaderViewDelegate {
    
    func toggleSection(header: HeaderView, section: Int) {
        var item = viewModel.items[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            viewModel.reloadSections?(section)
        }
    }
}

    

  



    

