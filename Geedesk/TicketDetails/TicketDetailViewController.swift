//
//  TicketDetailViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 16/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TicketDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var mainViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet var conversionTableView: UITableView!
    @IBOutlet var requestDate: UILabel!
    @IBOutlet var takeButton: UIButton!
    @IBOutlet var id: UILabel!
    @IBOutlet var heading: UILabel!
    @IBOutlet var room: UILabel!
    @IBOutlet var ticketHeadingTitle: UILabel!
    @IBOutlet var attachmentName: UILabel!
    
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var createdByName: UILabel!
    @IBOutlet var takeOnDate: UILabel!
    var image = UIImage()
    
    @IBOutlet var descriptionTicket: UILabel!
    
    @IBOutlet var statusTableView: UITableView!
    @IBOutlet var priorityButton: UIButton!
    @IBOutlet var priorityTableView: UITableView!
    @IBOutlet var departmentButton: UIButton!
    @IBOutlet var departmentTableView: UITableView!
    @IBOutlet var convensionVewHeight: NSLayoutConstraint!
    @IBOutlet var conversionTableviewHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    @IBOutlet var conversionTitleLabelHeight: NSLayoutConstraint!
    @IBOutlet var scrollViewTi: UIScrollView!
    
    @IBOutlet var commentTextView: IQTextView!
    var ticketid:String?
    
    var priority = ["Critical","High","Medium","Low"]
     var priorityFORM = ["P1","P2","P3","P4"]
     var status = ["Open","On Hold","Resolved","Delete"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        uidesign()
       
        ticketDetails()
         getComments()
        
       // let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
      //  view.addGestureRecognizer(tap)


    }
    
    
    func uidesign()
    {
        self.title = "Ticket Details"
        
        departmentTableView.dataSource = self
        departmentTableView.delegate = self
        departmentTableView.isHidden = true
        
        priorityTableView.dataSource = self
        priorityTableView.delegate = self
        priorityTableView.isHidden = true
        
        conversionTableView.delegate = self
        conversionTableView.dataSource = self
        
        
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.isHidden = true
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        priorityTableView.isHidden = true
        
        statusTableView.isHidden = true
        departmentTableView.isHidden = true
    }
    
    
    @IBAction func departmentButtonAction(_ sender: Any) {
        
        
//        departmentTableView.isHidden = false
//        statusTableView.isHidden = true
//
//        priorityTableView.isHidden = true
    }
    
    
    @IBAction func statusButtonAction(_ sender: Any) {
        
        
        statusTableView.isHidden = false
        departmentTableView.isHidden = true

        priorityTableView.isHidden = true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == departmentTableView{
              return 19
        }
        if tableView == priorityTableView{
            return priority.count
        }
        if tableView == statusTableView{
            return status.count
        }
        
        if SharedData.data.ticketCommentDetails?.count != nil
        {
             return (SharedData.data.ticketCommentDetails?.count)!
        }
       
       return 1
    }
    
    
    @IBAction func priorityButtonAction(_ sender: Any) {
        
        
        priorityTableView.isHidden = false
        
        statusTableView.isHidden = true
        departmentTableView.isHidden = true
        
        
        
    }
    
    
    
    
    @IBAction func takeButtonAction(_ sender: Any) {
        
        
        
        
        var params: [String:Any] = [:]
        params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
        params["ticket_id"]  = ticketid
        
        
        myProgressView.shared.showProgressView(self.view)
        print(params)
        HttpWrapper.post(with: GeedeskConstants.taketicket, parameters: params, headers: nil, completionHandler: { (response) in
            
            print(response)
            print(response["status"] as! String)
            myProgressView.shared.hideProgressView()
            if response["status"]! as! String  == "success"
            {
                self.ticketDetails()
                
                self.showAlert(msg:response["message"]! as! String)
               
                
                
            }else
            {
                self.showAlert(msg:response["message"]! as! String)
            }
        }){ (error) in
            myProgressView.shared.hideProgressView()
            
        }
        
        
    }
    
    
    
    @IBAction func addAttachmentActiojn(_ sender: Any) {
        
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose attachment from", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = UIColor(red: 28.0/255.0, green: 36.0/255.0, blue: 43.0/255.0, alpha: 1)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        
        // Add the actions
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        if let popoverController =  alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.frame.width-10, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openGallary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image1 = info[UIImagePickerControllerOriginalImage] as! UIImage
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        print(assetPath)
        image = image1
        attachmentName.text = assetPath.lastPathComponent
        
        print(assetPath.lastPathComponent)
        
       // changeProfileImage.image = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))
        
       // let data = UIImageJPEGRepresentation(changeProfileImage.image!, 1.0)
        // requestWith(endUrl: "\(GeedeskConstants.updateprofilepic)", imageData: data)
        //image
      //  SharedData.data.image = changeProfileImage.image
        
        dismiss(animated:true, completion: nil)
    }
    
    
    

    @IBAction func saveCommentAction(_ sender: Any) {
        
        
        
        if commentTextView.text == nil ||  commentTextView.text.isEmpty
        {
            
              self.showAlert(msg:"Please Enter Your Comments")
             return
        }
        
        
        
        
        var params: [String:Any] = [:]
        params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
        params["ticket_id"]  = ticketid
        params["new_comment"]  = commentTextView.text
        params["comment_files"] = ""
        
        
        myProgressView.shared.showProgressView(self.view)
      //  print(params)
        HttpWrapper.post(with: GeedeskConstants.addticketcomment, parameters: params, headers: nil, completionHandler: { (response) in
            
            print(response)
            print(response["status"] as! String)
            myProgressView.shared.hideProgressView()
            if response["status"]! as! String  == "success"
            {
                
                self.commentTextView.text = nil
                self.showAlert(msg:response["msg"]! as! String)
                self.getComments()
                
                
            }else
            {
                self.showAlert(msg:response["msg"]! as! String)
            }
        }){ (error) in
            myProgressView.shared.hideProgressView()
            
        }
        
    
    
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.priorityTableView.isHidden = true
        self.departmentTableView.isHidden = true
        self.statusTableView.isHidden = true
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == departmentTableView
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell11",
                for: indexPath)
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            
            cell.textLabel?.text = "sdfsdfsdf"
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            cell.textLabel?.numberOfLines = 0
            
            
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            
            tableView.layoutIfNeeded()
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            
            
            return cell
            
        }else  if tableView == priorityTableView
        {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell11",
            for: indexPath)
       
        
        cell.textLabel?.text = priority[indexPath.row]
      
        cell.textLabel?.numberOfLines = 0
        
        
        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
     
        tableView.layoutIfNeeded()
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
        
      
        return cell
        }else if tableView == statusTableView
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell13",
                for: indexPath)
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            
            cell.textLabel?.text = status[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            cell.textLabel?.numberOfLines = 0
            
            
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            
            tableView.layoutIfNeeded()
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            
            return cell
        }
        
        else
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ConversationTableViewCell",
                for: indexPath) as? ConversationTableViewCell
            
            
          cell?.name.text = SharedData.data.ticketCommentDetails?[indexPath.row].commentby_fname
             cell?.comment.text = SharedData.data.ticketCommentDetails?[indexPath.row].ticket_comment
            cell?.time.text = SharedData.data.ticketCommentDetails?[indexPath.row].comment_created_on
            
            
          
            
            tableView.layoutIfNeeded()
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            
            
            return cell!
            
        }
        
       
                
      
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == departmentTableView
        {
            
            departmentTableView.isHidden = true
            departmentButton.setTitle("some", for: .normal)
            
        }else if tableView == priorityTableView
        {
            priorityTableView.isHidden = true
            priorityButton.setTitle(priority[indexPath.row], for: .normal)
            
            var params: [String:Any] = [:]
            params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
            params["ticket_id"]  = ticketid
            params["new_ticket_priority"]  = priorityFORM[indexPath.row]
            
            
            myProgressView.shared.showProgressView(self.view)
            print(params)
            HttpWrapper.post(with: GeedeskConstants.updateticketpriority, parameters: params, headers: nil, completionHandler: { (response) in
                
                print(response)
                print(response["status"] as! String)
                myProgressView.shared.hideProgressView()
                if response["status"]! as! String  == "success"
                {
                    
                    self.showAlert(msg:response["message"]! as! String)
                    
                    
                }else
                {
                    self.showAlert(msg:response["message"]! as! String)
                }
            }){ (error) in
                myProgressView.shared.hideProgressView()
                
            }
            
            
            
        }else if tableView == statusTableView
        {
            statusTableView.isHidden = true
            statusButton.setTitle(status[indexPath.row], for: .normal)
            
            var params: [String:Any] = [:]
            
            print(UserDefaults.standard.string(forKey: "access_token"))
            params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
            params["ticket_id"]  = ticketid
            params["new_status"]  = status[indexPath.row]
            
            
            myProgressView.shared.showProgressView(self.view)
            print(params)
            HttpWrapper.post(with: GeedeskConstants.updateticketstatus, parameters: params, headers: nil, completionHandler: { (response) in
                
                print(response)
                print(response["status"] as! String)
                myProgressView.shared.hideProgressView()
                if response["status"]! as! String  == "success"
                {
                    
                    self.showAlert(msg:response["msg"]! as! String)
                    
                    
                }else
                {
                    self.showAlert(msg:response["msg"]! as! String)
                }
            }){ (error) in
                myProgressView.shared.hideProgressView()
                
            }
            
        }
        

    }
    
    
   
     func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    
    
    func getComments()
    {
        
        let ticketCommentUrl = GeedeskConstants.ticketComment
        
        let finelTicketCommentUrl = ticketCommentUrl + ticketid! + "/access_token/" + "\(String(describing: GeedeskConstants.token!))" + "/format/json"
        
        HttpWrapper.gets(with: finelTicketCommentUrl, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            // print(response)
            guard let data = response else { return }
            do {
                
                let loginRespone = try JSONDecoder().decode(Array<TicketCommentsDetials>.self, from: data)
                
                print(loginRespone)
                
                
                SharedData.data.ticketCommentDetails = loginRespone
                
                self.conversionTableView.reloadData()
                
                self.convensionVewHeight.constant = 199
                self.conversionTableView.isHidden = false
                self.conversionTitleLabelHeight.constant = 32
                 self.viewHeight.constant = 1080
                
                myProgressView.shared.hideProgressView()
                

                
            } catch let jsonErr {
                myProgressView.shared.hideProgressView()
                
                self.convensionVewHeight.constant = 0
                self.conversionTableView.isHidden = true
                self.viewHeight.constant = 880
              //  self.conversionTableviewHeight.constant = 0
                self.conversionTitleLabelHeight.constant = 0
                print("Error serializing json:", jsonErr)
                SharedData.data.ticketCommentDetails = nil
                //self.showAlert(msg:"internal server error")
            }
            
            
        }){ (error) in
           // myProgressView.shared.hideProgressView()
            self.showAlert(msg:"internal server error")
            
        }
    }
    
    
    func ticketDetails()
    {
        let ticketDetailsUrl = GeedeskConstants.ticketDetails
        
        let finalTicketDetailsUrl = ticketDetailsUrl + ticketid! + "/access_token/" + "\(String(describing: GeedeskConstants.token!))" + "/format/json"
        
        print(finalTicketDetailsUrl)
        myProgressView.shared.showProgressView(self.view)
        HttpWrapper.gets(with: finalTicketDetailsUrl, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            // print(response)
            guard let data = response else { return }
            do {
                
                let loginRespone = try JSONDecoder().decode(Array<TicketDetials>.self, from: data)
                
                print(loginRespone)
                
                
                SharedData.data.ticketDetails = loginRespone
                
             
                
                
                self.ticketHeadingTitle.text = SharedData.data.ticketDetails![0].ticket_heading
                self.descriptionTicket.text = SharedData.data.ticketDetails![0].ticket_heading
                
                
                
                self.id.text =  SharedData.data.ticketDetails![0].id
                self.heading.text = SharedData.data.ticketDetails![0].ticket_heading
                self.room.text = SharedData.data.ticketDetails![0].room_name
                self.departmentButton.setTitle(SharedData.data.ticketDetails![0].department_name, for: .normal)
                self.requestDate.text = SharedData.data.ticketDetails![0].ticket_created_on
                self.createdByName.text = SharedData.data.ticketDetails![0].user_fname
                
                
                if SharedData.data.ticketDetails![0].priority == "P1"
                {
                    self.priorityButton.setTitle("Critical", for: .normal)
                    
                }else if SharedData.data.ticketDetails![0].priority == "P2"
                {
                    self.priorityButton.setTitle("High", for: .normal)
                    
                }else if SharedData.data.ticketDetails![0].priority == "P3"
                {
                    self.priorityButton.setTitle("Medium", for: .normal)
                }else if SharedData.data.ticketDetails![0].priority == "P4"
                {
                    self.priorityButton.setTitle("Low", for: .normal)
                }
                
                
                
                if SharedData.data.ticketDetails![0].ticket_status == "New"
                {
                    self.statusButton.isUserInteractionEnabled = false
                    self.takeButton.isHidden = false
                }else
                {
                    self.statusButton.isUserInteractionEnabled = true
                    self.takeButton.isHidden = true
                    
                }
                
                self.statusButton.setTitle(SharedData.data.ticketDetails![0].ticket_status, for: .normal)
                self.takeOnDate.text = SharedData.data.ticketDetails![0].ticket_taken_on
                
                  // myProgressView.shared.hideProgressView()
                
                
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
   
    
    

}
extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
    
   
    
    
}
