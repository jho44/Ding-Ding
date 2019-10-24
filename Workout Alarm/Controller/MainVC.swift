//
//  MainVC.swift
//  Workout Alarm
//
//  Created by Jessica Ho on 7/26/19.
//  Copyright © 2019 Jessica Ho. All rights reserved.
//

/* TODO:
 
 minor things:
 - options for sounds
 - UI for when device horizontal
 
 major things:
 - change times back to 2 mins, 30 secs
 
 */

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var reportLbl: UILabel!
    @IBOutlet weak var promptLbl: UILabel!
    @IBOutlet weak var bgView: GradientView!
    @IBOutlet weak var powerBtn: UIButton!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet var options: [UIButton]!
    
    @IBOutlet weak var optionChosen: UILabel!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapBgGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenuUponTap(sender:)))
        bgView.addGestureRecognizer(tapBgGesture)
        tapBgGesture.delegate = self as? UIGestureRecognizerDelegate
        
        let tapDropDownGesture = UITapGestureRecognizer(target: self, action: #selector(openMenu(sender:)))
        dropDownView.addGestureRecognizer(tapDropDownGesture)
        
        dropDownView.layer.cornerRadius = 5
    }
    
    @IBAction func optionsPressed(_ sender: UIButton) {
        optionChosen.text = sender.titleLabel?.text
    }
    
    @objc func openMenu(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.options.forEach { (button) in
                button.isHidden = !button.isHidden
            }
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3) {
            self.options.forEach { (button) in
                /* TODO: erase the text in the buttons every time close menu */
                button.isHidden = true
            }
        }
    }
    
    @objc func closeMenuUponTap(sender: UITapGestureRecognizer) {
        closeMenu()
    }
    
    @IBAction func powerBtnPressed(_ sender: Any) {
        if optionChosen.text == "" {
            return
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.powerBtn.isEnabled = false
                debugPrint("Notifications not allowed.")
                // TODO: put an actual alert for user
            } else {
                debugPrint("Notifications allowed.")
            }
        }
        let controller = CurrentSetVC.shared as! CurrentSetVC
        controller.set(optionChosen: optionChosen.text!)
        show(controller, sender: self)
        closeMenu()
        //optionChosen.text = ""
    }
}

