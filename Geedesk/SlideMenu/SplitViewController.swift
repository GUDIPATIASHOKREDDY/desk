//
//  SplitViewController.swift
//  Chomp
//
//  Created by Ashok Reddy G on 16/05/18.
//  Copyright © 2018 Ashok Reddy G. All rights reserved.
//

import UIKit

class SplitViewController: SlideMenuController {
    var sideNavigation: UINavigationController?
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var slideButton: UIButton!
    @IBOutlet weak var slideContainer: UIView!
    @IBOutlet weak var slideMenuConstraint: NSLayoutConstraint!
    
    var gesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.addLeftBarButtonWithImage(UIImage(named: "MenuIcon")!)

        // Do any additional setup after loading the view.
    }
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationVC") {
            self.mainViewController = controller
            self.sideNavigation = controller as? UINavigationController
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SlideMenuVC") as? SlideMenuVC {
            self.leftViewController = controller
            controller.delegate = self as? SideMenuDelegate
        }
        super.awakeFromNib()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.isHidden = true
    }
    
    func gestureAction(_ sender: UITapGestureRecognizer) {
        slideMenuConstraint.constant = -320
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0
            self.slideButton.alpha = 1
        }
        
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        slideMenuConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 1
            self.slideButton.alpha = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "HomeNCSegue" {
//            let vc = segue.destination as? UINavigationController
//            for homeVC in (vc?.viewControllers)! {
//                if homeVC is HomeViewController {
//                    (homeVC as! HomeViewController).sourceVC = self
//                }
//            }
//            sideNavigation = vc
//        }
    }
}
extension SplitViewController {
    
    open override func closeLeft() {
        super.closeLeft()
        
    }
    
    open override func openLeft() {
        super.openLeft()
        
    }
    
}

  



    

    


