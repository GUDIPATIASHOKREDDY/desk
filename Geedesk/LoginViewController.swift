//
//  LoginViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 14/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mobileNumber: ACFloatingTextfield!
    @IBOutlet var phoneNumber: ACFloatingTextfield!
    let defaults = UserDefaults.standard
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumber.delegate = self
        phoneNumber.isSecureTextEntry = true
        
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // textField.resignFirstResponder()
        return true
    }


    @IBAction func Login(_ sender: Any) {
        
        
        
        if mobileNumber.text  != nil && (mobileNumber.text?.isEmpty)!
        {
            showAlert(msg:"Please enter Mobile number/Email")
            return

        }
        if phoneNumber.text  != nil && (phoneNumber.text?.isEmpty)!
        {
            showAlert(msg:"Please enter Password")
           return
        }

      
        var params: [String:Any] = [:]
        params["user_name"] =  mobileNumber.text
        params["user_pswd"]  = phoneNumber.text
        params["device_IMEI_MEID_ESN"]  = getUUID()
        
        print(params)
        
        myProgressView.shared.showProgressView(self.view)
        print(params)
        HttpWrapper.post(with: GeedeskConstants.login, parameters: params, headers: nil, completionHandler: { (response) in
            
            print(response)
            print(response["status"] as! String)
               myProgressView.shared.hideProgressView()
            if response["status"]! as! String  == "success"
            {
                print(response["access_token"]! as! String)
            self.defaults.set(response["access_token"]! as! String, forKey: "access_token")
                _ = UIApplication.shared.delegate as! AppDelegate
                let id = "SplitNavigationView"
                let vc = UIStoryboard.getViewController(storyboardName: "Main", storyboardId: id)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }else
            {
                self.showAlert(msg:response["msg"]! as! String)
            }
        }){ (error) in
            myProgressView.shared.hideProgressView()
            
        }
    
        

        
        
    }
    
     
    
    
    @IBAction func showSecurePassword(_ sender: Any) {
        if(iconClick == true) {
            phoneNumber.isSecureTextEntry = false
        } else {
            phoneNumber.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumber
        {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        return true
    }
    

}

extension UIViewController
{
    func  showAlert(msg:String){
        let alert = UIAlertController(title: "Geedesk", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getDateTimeDiff(dateStr:String) -> String {
        
        let formatter : DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = formatter.string(from: NSDate() as Date)
        let startDate = formatter.date(from: dateStr)
        let endDate = formatter.date(from: now)
        
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate!))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate!, to: endDate!)
        
        // *** Get Individual components from date ***
        let years = dateComponents.year!
        let months = dateComponents.month!
        let days = dateComponents.day!
        let hours = dateComponents.hour!
        let minutes = dateComponents.minute!
        let seconds = dateComponents.second!
        
        var timeAgo = ""
        
        if (seconds > 0){
            if seconds < 2 {
                timeAgo = "Second Ago"
            }
            else{
                timeAgo = "\(seconds) Second Ago"
            }
        }
        
        if (minutes > 0){
            if minutes < 2 {
                timeAgo = "Minute Ago"
            }
            else{
                timeAgo = "\(minutes) Minutes Ago"
            }
        }
        
        if(hours > 0){
            if minutes < 2 {
                timeAgo = "Hour Ago"
            }
            else{
                timeAgo = "\(hours) Hours Ago"
            }
        }
        
        if (days > 0) {
            if minutes < 2 {
                timeAgo = "Day Ago"
            }
            else{
                timeAgo = "\(days) Days Ago"
            }
        }
        
        if(months > 0){
            if minutes < 2 {
                timeAgo = "Month Ago"
            }
            else{
                timeAgo = "\(months) Months Ago"
            }
        }
        
        if(years > 0){
            if minutes < 2 {
                timeAgo = "Year Ago"
            }
            else{
                timeAgo = "\(years) Years Ago"
            }
        }
        
        
        return timeAgo;
    }

}

