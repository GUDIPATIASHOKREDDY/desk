//
//  ChangeProfileViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 17/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import Alamofire

class ChangeProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var changeProfileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
      //https://app.geedesk.com/api/v1/users/update/profile-pic/format/json
        
       // changeProfileImage.image = UIImage(named: "geedesk_logo")
        
        
         self.navigationController?.navigationBar.isHidden = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        changeProfileImage.isUserInteractionEnabled = true
        changeProfileImage.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       // let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let alert:UIAlertController=UIAlertController(title: "Choose your profile", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
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
        
        // Your action
    }
    
    
    
    
    @IBAction func SubmitButtonAction(_ sender: Any) {
        
        let data = UIImageJPEGRepresentation(changeProfileImage.image!, 0.5)
        requestWith(endUrl: "\(GeedeskConstants.updateprofilepic)", imageData: data)
        
    }
    
    
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        changeProfileImage.image = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))
        
      
       
       
        
        dismiss(animated:true, completion: nil)
    }
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = UIImageJPEGRepresentation(img, 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func requestWith(endUrl: String, imageData: Data?){
        
        
        
         myProgressView.shared.showProgressView(self.view)
        
        
        let url = "\(GeedeskConstants.updateprofilepic)" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "enctype": "multipart/form-data"
        ]
        
        var parameters = [String:Any]()
        parameters = ["access_token": UserDefaults.standard.string(forKey: "access_token")!]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if let data = imageData{
                multipartFormData.append(data, withName: "newUserProfilePic", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        },to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    
                    myProgressView.shared.hideProgressView()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if let JSON = response.result.value as? [String: Any] {
                        print(JSON)
                        let status = JSON["status"] as? String
                         let response = JSON["message"] as? String
                        
                        if status! == "success"
                        {
                             self.showAlert(msg:response!)
                            SharedData.data.image = self.changeProfileImage.image
                        }
                       
                       
                       
                        
                     
                    }
                   
                    if let err = response.error{
                        
                        return
                    }
                    // onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
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
enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        
        return imageData?.base64EncodedString()
    }
}

extension String {
    func imageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        
        return UIImage(data: data)
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
