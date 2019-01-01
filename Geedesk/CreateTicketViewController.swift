//
//  CreateTicketViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 15/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
struct Namearray:Codable
{
    let name : String?
}


class CreateTicketViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet var tableView1: UITableView!
    
    @IBOutlet var submitButton: UIButton!
    let datePicker : UIDatePicker = UIDatePicker()
    @IBOutlet var guestButton: UIButton!
   
    @IBOutlet var actionBarButtomConstants: NSLayoutConstraint!
    @IBOutlet var dateDispaly: UILabel!
    
    @IBOutlet var timeDisplay: UILabel!
    
    @IBOutlet var guestTableview: UITableView!
    @IBOutlet var scheduleView: UIView!
    @IBOutlet var scheduleViewHeight: NSLayoutConstraint!
    @IBOutlet var selectPriorityButton: UIButton!
    
    @IBOutlet var scheduleButton: UIButton!
    @IBOutlet var scheduleTableView: UITableView!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var ticketTypeTextField: ACFloatingTextfield!
     let datePickerContainer = UIView()
    
    
    var ticketTypeId:String?
    var roomId:String?
    var prority:String?
    var schedule:String?
    var guestCall:String?
    
    
    
    @IBOutlet var ticketTypeTableView: UITableView!
    @IBOutlet var roomSelectionTextFiled: ACFloatingTextfield!
    
    @IBOutlet var priorityView: UIView!
    
    
    var array = ["No","Yes"]
    
    var contorel: [String] = []
     var model = [AllRooms]()
    var filterarray = [AllRooms]()
     var filterarray2 = [AllCategories]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
       // view.addGestureRecognizer(tap)

        
        
        
        
        
        
        
        
        
        
        
        
        
        HttpWrapper.gets(with: GeedeskConstants.allrooms, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            // print(response)
            guard let data = response else { return }
            do {
                 // myProgressView.shared.hideProgressView()
                
                let loginRespone = try JSONDecoder().decode(Array<AllRooms>.self, from: data)
                
              //  print(loginRespone)
            
                    SharedData.data.allRooms = loginRespone
                
              //  print(SharedData.data.allRooms?[2].dept_name)
               
                
            } catch let jsonErr {
                myProgressView.shared.hideProgressView()
                print("Error serializing json:", jsonErr)
               
                   self.showAlert(msg:"internal server error")
            }
        
            
        }){ (error) in
            myProgressView.shared.hideProgressView()
            self.showAlert(msg:"internal server error")
            
        }
        
        

         myProgressView.shared.showProgressView(self.view)
        
        let category = GeedeskConstants.category
        HttpWrapper.gets(with: GeedeskConstants.category, parameters: nil, headers: nil, completionHandler: { (response, error)  in
            // print(response)
              myProgressView.shared.hideProgressView()
            guard let data = response else { return }
            do {
                
                
                let loginRespone = try JSONDecoder().decode(Array<AllCategories>.self, from: data)
                
                print(loginRespone)
                
                SharedData.data.allCategories = loginRespone
                
             
                
                
            } catch let jsonErr {
                myProgressView.shared.hideProgressView()
                print("Error serializing json:", jsonErr)
                
                self.showAlert(msg:"internal server error")
            }
            
            
        }){ (error) in
            myProgressView.shared.hideProgressView()
            self.showAlert(msg:"internal server error")
            
        }
        
        
        
        
      // submitButton.bindToKeyboard()
        
        self.title = "Create Ticket" 
        guestTableview.delegate = self
        
        guestTableview.dataSource = self
        guestTableview.isHidden = true
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
       scheduleTableView.isHidden = true
        priorityView.isHidden = true
        scheduleViewHeight.constant = 0
        scheduleView.isHidden = true
        
        
         tableView1.isHidden = true
        ticketTypeTableView.isHidden = true
    
      roomSelectionTextFiled.delegate = self
        ticketTypeTextField.delegate = self
        tableView1.dataSource = self
        tableView1.delegate = self
         ticketTypeTableView.dataSource = self
         ticketTypeTableView.delegate = self
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        scheduleTableView.isHidden = true
        priorityView.isHidden = true
        guestTableview.isHidden = true
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == scheduleTableView ||  tableView == guestTableview
        {
            return array.count
        }
        
        if tableView == ticketTypeTableView
        
        {
            
        
             return filterarray2.count
        }
       
        return filterarray.count
    }
    
    
    
    @IBAction func GuestButton(_ sender: Any) {
        
        guestTableview.isHidden = false
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == scheduleTableView ||  tableView == guestTableview
        {
              return 30
        }
        
        return 60
        
    }
    
    
    @IBAction func SelectPrority(_ sender: Any) {
        
        priorityView.isHidden = false
    }
    
    
    
    @IBAction func No(_ sender: Any) {
        
        scheduleTableView.isHidden = false
        
    }
    
    
    
    @IBAction func selectPriority(_ sender: Any) {
        priorityView.isHidden = true
        
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            print(buttonTitle)
            selectPriorityButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    
    
    @IBAction func CreteTicketSubmitAction(_ sender: Any) {
        
        
        
        if roomSelectionTextFiled == nil || ((roomSelectionTextFiled.text?.isEmpty)!)
        {
             self.showAlert(msg:"Please select Room")
            
           
            return
        }else if ticketTypeTextField == nil || (ticketTypeTextField.text?.isEmpty)!
        {
             self.showAlert(msg:"Please select Ticket Type")
           
            return
        }
        
        var params: [String:Any] = [:]
        params["access_token"] =  UserDefaults.standard.string(forKey: "access_token")
        params["ticket_type_id"]  = ticketTypeId
        params["ticket_description"]  = textView.text
        params["room_id"]  = roomId
        params["ticket_priority"] = prority
        params["ticket_schedule"] = schedule
        params["schedule_time"] = "\(String(describing: dateDispaly.text!))" + " " + "\(String(describing: timeDisplay.text!))"
        params["guest_call"] = guestCall
        params["ticket_creation_source"] = "iOS App"
        
        myProgressView.shared.showProgressView(self.view)
        print(params)
        HttpWrapper.post(with: GeedeskConstants.new_create_ticket_department, parameters: params, headers: nil, completionHandler: { (response) in
            
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
    
    
    
    
    @IBAction func critical(_ sender: Any) {
         priorityView.isHidden = true
        prority = "P1"
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            print(buttonTitle)
            selectPriorityButton.setTitle(buttonTitle, for: .normal)
        }
        
    }
    
    
    @IBAction func high(_ sender: Any) {
         priorityView.isHidden = true
        prority = "P2"
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            print(buttonTitle)
            selectPriorityButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func medium(_ sender: Any) {
         priorityView.isHidden = true
        prority = "P3"
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            print(buttonTitle)
            selectPriorityButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    
    @IBAction func low(_ sender: Any) {
         priorityView.isHidden = true
        prority = "P4"
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            print(buttonTitle)
            selectPriorityButton.setTitle(buttonTitle, for: .normal)
        }
    }
    

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        
        
        if tableView == tableView1
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath)
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            
            cell.textLabel?.text = filterarray[indexPath.row].dept_name
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            cell.textLabel?.numberOfLines = 0
            
            
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            return cell
        }
        
        if tableView == ticketTypeTableView
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell1",
                for: indexPath)
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            
            cell.textLabel?.text = filterarray2[indexPath.row].name
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            cell.textLabel?.numberOfLines = 0
            
            
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            return cell
        }
        if tableView == scheduleTableView
            {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "cell3",
                    for: indexPath)
                cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
                
                cell.textLabel?.text = array[indexPath.row]
                cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
                cell.textLabel?.numberOfLines = 0
                
                
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
                return cell
        }
        if tableView == guestTableview
        {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell4",
                for: indexPath)
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            
            cell.textLabel?.text = array[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Spinnaker", size: 16)
            cell.textLabel?.numberOfLines = 0
            
            
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    
    
    
    @IBAction func DateSelect(_ sender: Any) {
        

        
        
        //self.datePicker.maximumDate = Date()
        
        datePicker.datePickerMode = .date
       
        datePicker.minimumDate = Date() 
        
        datePickerContainer.frame = CGRect(x: 0, y: self.view.frame.midY, width: self.view.frame.width, height: self.view.frame.height/2)

        datePickerContainer.backgroundColor = UIColor.white
        
        let pickerSize : CGSize = datePicker.sizeThatFits(CGSize.zero)
       
         datePicker.datePickerMode = UIDatePickerMode.date
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        case .pad:
            datePicker.frame = CGRect(x:self.view.frame.midX/2,  y:0, width:pickerSize.width,height: 460)
        // It's an iPad
        case .unspecified:
            datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        // Uh, oh! What could it be?
        case .tv:
            datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        case .carPlay:
            datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        }
       
        datePicker.addTarget(self, action: #selector(dateChangedInDate), for: UIControlEvents.valueChanged)
        datePickerContainer.addSubview(datePicker)
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(donemissPicker), for: UIControlEvents.touchUpInside)
        doneButton.frame    = CGRect(x:self.datePickerContainer.frame.width-70,  y:5.0,width: 70.0, height:37.0)
        
        
        let CancelButton = UIButton()
        CancelButton.setTitle("Cancel", for: UIControlState.normal)
        CancelButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        CancelButton.addTarget(self, action: #selector(dismissPicker), for: UIControlEvents.touchUpInside)
        CancelButton.frame    = CGRect(x:0.0,  y:5.0,width: 70.0, height:37.0)
        
        datePickerContainer.addSubview(CancelButton)
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)

        
    }
    @objc func dateChangedInDate(sender:UIDatePicker){
        
        
        
       // dateFormatter.dateStyle = DateFormatter.Style.long
      //  dateFormatter.timeStyle = DateFormatter.Style.none
       // print("date selected \(UIDatePicker.date)")
        
    }// end dateChangedInDate
    
    /*
     * MARK - dismiss the date picker value
     */
    @objc func donemissPicker(sender: UIButton) {
      print("dismiss date picker")
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //2018-12-22 16:19:51
        
        //dd/MM/yyyy
        dateDispaly.text = dateFormatter.string(from: datePicker.date)
        print(dateFormatter.string(from: datePicker.date))
        
        datePickerContainer.removeFromSuperview()
    }//
    
    @objc func dismissPicker(sender: UIButton)
    {
         datePickerContainer.removeFromSuperview()
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        dateDispaly.text = dateFormatter.string(from: sender.date)
       // dobButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    
    
    @IBAction func timeSelcet(_ sender: Any) {
        
         datePicker.datePickerMode = UIDatePickerMode.time
        
        datePicker.locale = Locale(identifier: "en_GB")
        datePickerContainer.frame = CGRect(x: 0, y: self.view.frame.midY, width: self.view.frame.width, height: self.view.frame.height/2)
        
        datePickerContainer.backgroundColor = UIColor.white
        
        let pickerSize : CGSize = datePicker.sizeThatFits(CGSize.zero)
       
       
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
        datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        case .pad:
            datePicker.frame = CGRect(x:self.view.frame.midX/2,  y:0, width:pickerSize.width,height: 460)
        // It's an iPad
        case .unspecified:
            datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
            // Uh, oh! What could it be?
        case .tv:
             datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        case .carPlay:
             datePicker.frame = CGRect(x:20.0,  y:0, width:pickerSize.width,height: 460)
        }
        datePicker.addTarget(self, action: #selector(dateChangedInDate), for: UIControlEvents.valueChanged)
        datePickerContainer.addSubview(datePicker)
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(donemissPickertime), for: UIControlEvents.touchUpInside)
        doneButton.frame    = CGRect(x:self.datePickerContainer.frame.width-70,  y:5.0,width: 70.0, height:37.0)
        
        
        let CancelButton = UIButton()
        CancelButton.setTitle("Cancel", for: UIControlState.normal)
        CancelButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        CancelButton.addTarget(self, action: #selector(dismissPicker), for: UIControlEvents.touchUpInside)
        CancelButton.frame    = CGRect(x:0.0,  y:5.0,width: 70.0, height:37.0)
        
        datePickerContainer.addSubview(CancelButton)
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)
    }
    
    @objc func donemissPickertime(sender: UIButton) {
        print("dismiss date picker")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
         //dateFormatter.timeStyle = .short
        
        print(dateFormatter.string(from: datePicker.date))
       
        timeDisplay.text = dateFormatter.string(from: datePicker.date)
        print(dateFormatter.string(from: datePicker.date))
        
        datePickerContainer.removeFromSuperview()
    }
    
    
    
    
    
    
    
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == scheduleTableView
        {
            
        }else
        {
        let additionalSeparatorThickness = CGFloat(2)
        
        let additionalSeparator = UIView(frame: CGRect(x: 0,
                                                       y: cell.frame.size.height - additionalSeparatorThickness, width: cell.frame.size.width, height: additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor.gray
        cell.addSubview(additionalSeparator)
            
        }
        
    }
    
    
    
    
   

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == roomSelectionTextFiled
        {
            let arra111 = roomSelectionTextFiled.text
        
            filterarray = SharedData.data.allRooms!.filter{ ($0.dept_name?.localizedStandardContains(arra111!))! }
            
            
            print(filterarray)
            
            self.ticketTypeTableView.isHidden = true
            if filterarray.count > 0
            {
              //  self.ticketTypeTableView.isHidden = true
                self.tableView1.isHidden = false
                self.tableView1.reloadData()
            }else
            {
                self.tableView1.isHidden = true
                self.tableView1.reloadData()
            }
            
     
        }
        if textField == ticketTypeTextField
        {
            let arra111 = ticketTypeTextField.text
            
            filterarray2 = SharedData.data.allCategories!.filter{ ($0.name?.localizedStandardContains(arra111!))! }
            
            
            print(filterarray)
            
            self.tableView1.isHidden = true
            if filterarray2.count > 0
            {
                self.ticketTypeTableView.isHidden = false
                self.ticketTypeTableView.reloadData()
            }else
            {
                self.ticketTypeTableView.isHidden = true
                self.ticketTypeTableView.reloadData()
                
            }
            
            
        }
        return true;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1
        {
            
            tableView1.isHidden = true
            
            roomSelectionTextFiled.text = filterarray[indexPath.row].dept_name
            roomId = filterarray[indexPath.row].id
        }
        
        if tableView == ticketTypeTableView
        {
             ticketTypeTableView.isHidden = true
            ticketTypeTextField.text = filterarray2[indexPath.row].name
            
            ticketTypeId = filterarray2[indexPath.row].id
            textView.text = ticketTypeTextField.text
            
        }
        
        if tableView == scheduleTableView
        {
            
            if indexPath.row == 0
            {
                schedule = "no"
                scheduleButton.setTitle("No", for: .normal)
                scheduleViewHeight.constant = 0
                scheduleView.isHidden = true
                
            }else if indexPath.row == 1
            {
                 schedule = "yes"
                
                scheduleButton.setTitle("Yes", for: .normal)
                scheduleViewHeight.constant = 98
                scheduleView.isHidden = false
            }
            scheduleTableView.isHidden = true
            
        }
        
        if tableView == guestTableview
        
        {
            if indexPath.row == 0
            {
               guestCall = "no"
                guestButton.setTitle("No", for: .normal)
                 guestTableview.isHidden = true
            }else if indexPath.row == 1
            {
                guestCall = "yes"
                guestButton.setTitle("Yes", for: .normal)
                guestTableview.isHidden = true
            }
            
            
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

}


extension CreateTicketViewController{
    
    func keybordControl(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardControl(notification, isShowing: true)
    }
    
    
    
    @objc func keyboardWillHide(notification: Notification) {
        self.keyboardControl(notification, isShowing: false)
    }
    
    
    
    private func keyboardControl(_ notification: Notification, isShowing: Bool) {
        
        /* Handle the Keyboard property of Default, Text*/
        
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        
        var  pureheightOffset : CGFloat = -heightOffset
        
        if isShowing {
            if #available(iOS 11.0, *) {
                pureheightOffset = pureheightOffset + view.safeAreaInsets.bottom
            }
        }
        self.actionBarButtomConstants?.constant = pureheightOffset
        
        UIView.animate(
            withDuration: duration!,
            delay: 0,
            options: options,
            animations: {
                self.view.layoutIfNeeded()
                
        },
            completion: { bool in
                
        })
        
    }
    
    
   
    
    
}
extension UIButton {
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIButton.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
