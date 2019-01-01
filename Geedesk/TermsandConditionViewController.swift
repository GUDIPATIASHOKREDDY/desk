//
//  TermsandConditionViewController.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 16/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit

class TermsandConditionViewController: UIViewController,UIWebViewDelegate{
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
         self.navigationController?.navigationBar.isHidden = false
        
        let url = URL (string: "https://geedesk.com/terms-of-service")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)

        // Do any additional setup after loading the view.
    }
    public func webViewDidStartLoad(_ webView: UIWebView)
    {
        myProgressView.shared.showProgressView(self.view)
        
    }
    
    
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myProgressView.shared.hideProgressView()
        
    }
    
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        myProgressView.shared.hideProgressView()
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
