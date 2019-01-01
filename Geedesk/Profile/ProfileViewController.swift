//
//  ProfileViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 17/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet var ProfileImageView: UIImageView!
    
    @IBOutlet var profileTableview: UITableView!
    
    @IBOutlet var name: UILabel!
    
    
    
    
   var userData = [String]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        self.navigationController?.navigationBar.isHidden = false
         myProgressView.shared.showProgressView(self.view)
        
        HttpWrapper.gets(with: GeedeskConstants.user_details, parameters: nil, headers: nil, completionHandler: { (response, error)  in
           // print(response)
            guard let data = response else { return }
            do {
                // myProgressView.shared.hideProgressView()
                
                let loginRespone = try JSONDecoder().decode(Array<UserProfile>.self, from: data)
                
                print(loginRespone)
                   myProgressView.shared.hideProgressView()
                
                SharedData.data.userProfile = loginRespone
                
                
                
                self.userData.append((SharedData.data.userProfile?[0].phone_number)!)
                self.userData.append((SharedData.data.userProfile?[0].user_name)!)
                self.userData.append((SharedData.data.userProfile?[0].gender)!)
                self.userData.append((SharedData.data.userProfile?[0].user_role)!)
                self.profileTableview.delegate = self
                self.profileTableview.dataSource = self
                
                self.profileTableview.rowHeight = UITableViewAutomaticDimension
                self.name.text =  "\(String(describing: (SharedData.data.userProfile?[0].user_fname)!))" + " " + "\(String(describing: (SharedData.data.userProfile?[0].user_lname)!))"
                
                
                
                if SharedData.data.userProfile?[0].user_profilepic != nil
                {
                
                
                
                DispatchQueue.global(qos: .background).async {
                    do
                    {
                        let data = try Data.init(contentsOf: URL.init(string: (SharedData.data.userProfile?[0].user_profilepic)!)!)
                        DispatchQueue.main.async {
                            let image: UIImage = UIImage(data: data)!
                            self.ProfileImageView.image = image
                            SharedData.data.image = image 
                        }
                    }
                    catch {
                        // error
                    }
                }
                }
                
                
                
                myProgressView.shared.hideProgressView()
                
//                self.myTicketTableView.delegate = self
//                self.myTicketTableView.dataSource = self
//                self.myTicketTableView.reloadData()
                
           //     print(SharedData.data.myTickets?.count)
                
                
                
                
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ProfileImageView.isUserInteractionEnabled = true
        ProfileImageView.addGestureRecognizer(tapGestureRecognizer)
   ProfileImageView.roundedImage()
        
//       // imageView.layer.masksToBounds = true
//        ProfileImageView.layer.borderWidth = 5.5
//        ProfileImageView.layer.borderColor = UIColor.gray.cgColor
//      //  ProfileImageView.roundCorners(radius:2)
//        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "ProfileCell"))!
        cell.textLabel?.text = userData[indexPath.row]
        cell.imageView?.image = UIImage(named: "geedesk")
        
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if  SharedData.data.image != nil
        {
            ProfileImageView.image = SharedData.data.image
        }
    }
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let vc = UIStoryboard.getViewController(storyboardName: "Main",storyboardId: "ChangeProfileViewController") as? ChangeProfileViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
        // Your action
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


extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.gray.cgColor
      
        
}

    
    
}
