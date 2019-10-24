//
//  SettingsVC.swift
//  Workout Alarm
//
//  Created by Jessica Ho on 8/5/19.
//  Copyright © 2019 Jessica Ho. All rights reserved.
//

import UIKit

/* TODO:
 - disable being able to put more than 2 digits in text field
 */

class SettingsVC: UIViewController {
    
    @IBOutlet weak var option_2_stage_1_minLbl: UITextField!
    @IBOutlet weak var option_2_stage_1_secLbl: UITextField!
    @IBOutlet weak var option_2_stage_2_minLbl: UITextField!
    @IBOutlet weak var option_2_stage_2_secLbl: UITextField!
    
    @IBOutlet weak var option_3_stage_1_minLbl: UITextField!
    @IBOutlet weak var option_3_stage_1_secLbl: UITextField!
    @IBOutlet weak var option_3_stage_2_minLbl: UITextField!
    @IBOutlet weak var option_3_stage_2_secLbl: UITextField!
    @IBOutlet weak var option_3_stage_3_minLbl: UITextField!
    @IBOutlet weak var option_3_stage_3_secLbl: UITextField!
    
    var keyDict : [String : UITextField]?
    
    @IBOutlet var bgView: GradientView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        option_2_stage_1_minLbl.delegate = self
        option_2_stage_1_secLbl.delegate = self
        option_2_stage_2_minLbl.delegate = self
        option_2_stage_2_secLbl.delegate = self
        
        option_3_stage_1_minLbl.delegate = self
        option_3_stage_1_secLbl.delegate = self
        option_3_stage_2_minLbl.delegate = self
        option_3_stage_2_secLbl.delegate = self
        option_3_stage_3_minLbl.delegate = self
        option_3_stage_3_secLbl.delegate = self
        
        let tapBgGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
        bgView.addGestureRecognizer(tapBgGesture)
        tapBgGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        for index in keyDict! {
            index.value.resignFirstResponder()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        keyDict = ["option2stage1min" : option_2_stage_1_minLbl,
                    "option2stage1sec": option_2_stage_1_secLbl,
                    "option2stage2min" : option_2_stage_2_minLbl,
                    "option2stage2sec": option_2_stage_2_secLbl,
                    "option3stage1min" : option_3_stage_1_minLbl,
                    "option3stage1sec": option_3_stage_1_secLbl,
                    "option3stage2min" : option_3_stage_2_minLbl,
                    "option3stage2sec": option_3_stage_2_secLbl,
                    "option3stage3min" : option_3_stage_3_minLbl,
                    "option3stage3sec": option_3_stage_3_secLbl
                    ]
        // see if user has set values for stage times in User Defaults
        // if they have, fill the corresponding text field with that user-set value
        // if not, set it to the default times defined in Constants.swift
        for index in keyDict! {
            if let stageTime = defaults.string(forKey: "\(index.key)") {
                index.value.text = stageTime
            } else {
                index.value.text = DEFAULT_TIMES_DICT[index.key]
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // zero out any text fields that were left empty
        for index in keyDict! {
            zeroOut(label: index.value)
        }
        
        // save settings in user defaults
        // note: after first time user opens and closes settings VC,
        // default times will never be called again
        for index in keyDict! {
            defaults.set(index.value.text, forKey: "\(index.key)")
            debugPrint("\(index.key): \(String(describing: defaults.string(forKey: "\(index.key)")))")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // HELPER FUNCS
    func zeroOut(label: UITextField) {
        if label.text == "" {
            label.text = "0"
        }
    }
    
    func totalStageTime(min: Int, sec: Int) -> Int {
        let min = Int(min) * 60
        let sec = Int(sec)
        return min+sec
    }
}

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //if textField == option_3_stage_2_minLbl {
            debugPrint("text field began editing")
        //}
        if textField == option_3_stage_1_minLbl
        || textField == option_3_stage_1_secLbl
        || textField == option_3_stage_2_minLbl
        || textField == option_3_stage_2_secLbl
        || textField == option_3_stage_3_minLbl
        || textField == option_3_stage_3_secLbl
        {
            bgView.bindToKeyboard()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        bgView.separateFromKeyboard()
    }

}
