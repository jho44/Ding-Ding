//
//  CurrentSetVC.swift
//  Workout Alarm
//
//  Created by Jessica Ho on 7/27/19.
//  Copyright © 2019 Jessica Ho. All rights reserved.
//

/* TODO:
 - fix the ugliness (make your code DRY)
 - test this baby out
 - ask user how much time they think they're going to workout for
 - or maybe get a check of how many notifications are left pending,
 then send an alert when s/he is almost out and force them to
 bring the app to the foreground to reload notifications
 */

import UIKit
import AVFoundation

class CurrentSetVC: UIViewController  {
    
    // the famed singleton
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentSetVC")
    
    @IBOutlet weak var setNumLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    
    private var setNum: Int = 1
    private var setting: String = "GREEN"
    var optionChosen: String?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private var finishedFirstSession = false
    
    private var notifsLeft: Int = 0
    
    let defaults = UserDefaults.standard
    
    var player: AVAudioPlayer!
    
    func set(optionChosen: String) {
        self.optionChosen = optionChosen
    }
        
    func createContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = ""
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "bell.aiff"))
        return content
    }
    
    func dateWrapAround(dateComp:inout DateComponents) {
        if dateComp.second == 60 {
            dateComp.minute!+=1
            dateComp.second=0
            if dateComp.minute == 60 {
                dateComp.hour!+=1
                dateComp.minute=0
            }
        }
    }
    
    func scheduleNotifications() {
        var stage = "1"
        var notifsCounter = 0
        let dateObj = Date()
        let calendar = Calendar.current
        var dateComp = DateComponents()
        dateComp.hour = calendar.component(.hour, from: dateObj)
        dateComp.minute = calendar.component(.minute, from: dateObj)
        dateComp.second = calendar.component(.second, from: dateObj)
        
        // TODO: fix this ugliness
        if optionChosen == "3" {
            while notifsCounter < 64 {
                //let content = createContent()
                let content = UNMutableNotificationContent()
                content.title = ""
                content.body = ""
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "bell.aiff"))
                
                var trigger: UNCalendarNotificationTrigger
                
                switch stage {
                case "1":
                    if let min = defaults.string(forKey: "option3stage1min"),
                        let sec = defaults.string(forKey: "option3stage1sec") {
                        let time = Int(min)! * 60 + Int(sec)!
                        dateComp.second! += time
                        debugPrint("time is \(time)")
                    } else {
                        dateComp.second! += DEFAULT_OPTION_3_STAGE_1_TIME
                    }
                    stage = "2"
                    notifsCounter += 1
                case "2":
                    if let min = defaults.string(forKey: "option3stage2min"),
                        let sec = defaults.string(forKey: "option3stage2sec") {
                        let time = Int(min)! * 60 + Int(sec)!
                        dateComp.second! += time
                        debugPrint("time is \(time)")
                    } else {
                        dateComp.second! += DEFAULT_OPTION_3_STAGE_2_TIME
                    }
                    stage = "3"
                    notifsCounter += 1
                case "3":
                    if let min = defaults.string(forKey: "option3stage3min"),
                        let sec = defaults.string(forKey: "option3stage3sec") {
                        let time = Int(min)! * 60 + Int(sec)!
                        dateComp.second! += time
                        debugPrint("time is \(time)")
                    } else {
                        dateComp.second! += DEFAULT_OPTION_3_STAGE_3_TIME
                    }
                    stage = "1"
                    notifsCounter += 1
                default:
                    debugPrint("you done messed up")
                }
                
                //dateWrapAround(dateComp: &dateComp)
                if dateComp.second! >= 60 {
                    let minutes = dateComp.second! / 60
                    dateComp.minute!+=minutes
                    dateComp.second = dateComp.second! % 60
                    if dateComp.minute! >= 60 {
                        let hours = dateComp.minute! / 60
                        dateComp.hour!+=hours
                        dateComp.minute = dateComp.minute! % 60
                    }
                }
                
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        debugPrint("Problem scheduling request with system.")
                    } else {
                        debugPrint("\(String(describing: dateComp.minute)) \(String(describing: dateComp.second))")
                    }
                }
            }
        } else if optionChosen == "2" {
            while notifsCounter <  64 {
                let content = createContent()
                
                var trigger: UNCalendarNotificationTrigger
                
                switch stage {
                case "1":
                    if let min = defaults.string(forKey: "option2stage1min"),
                        let sec = defaults.string(forKey: "option2stage1sec") {
                        let time = Int(min)! * 60 + Int(sec)!
                        dateComp.second! += time
                    } else {
                        dateComp.second! += DEFAULT_OPTION_2_STAGE_1_TIME
                    }
                    stage = "2"
                    notifsCounter += 1
                case "2":
                    if let min = defaults.string(forKey: "option2stage2min"),
                        let sec = defaults.string(forKey: "option2stage2sec") {
                        let time = Int(min)! * 60 + Int(sec)!
                        dateComp.second! += time
                    } else {
                        dateComp.second! += DEFAULT_OPTION_2_STAGE_2_TIME
                    }
                    stage = "1"
                    notifsCounter += 1
                default:
                    debugPrint("you done messed up")
                }
                
                if dateComp.second! >= 60 {
                    let minutes = dateComp.second! / 60
                    dateComp.minute!+=minutes
                    dateComp.second = dateComp.second! % 60
                    if dateComp.minute! >= 60 {
                        let hours = dateComp.minute! / 60
                        dateComp.hour!+=hours
                        dateComp.minute = dateComp.minute! % 60
                    }
                }
                
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        debugPrint("Problem scheduling request with system.")
                    }
                }
            }
        }
        debugPrint("done scheduling notifs")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorLbl.layer.cornerRadius = 5
        colorLbl.clipsToBounds = true
        scheduleNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundShiftDetected), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(foregroundShiftDetected), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(terminationImminent), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if finishedFirstSession {
            scheduleNotifications()
        }
    }
    
    @objc func terminationImminent() {
        stopEverything()
    }
    
    @objc func foregroundShiftDetected() {
        // figure out how many notifs have been delivered since app last in foreground
        // and use that to determine what setNum and setting should be
        
        let notifsLeftScheduled = UIApplication.shared.scheduledLocalNotifications?.count
        let notifsDiff = notifsLeft - notifsLeftScheduled!
        
        if optionChosen == "2" {
            let settingsToJump = notifsDiff % 2
            if settingsToJump == 1 {
                if setting == GREEN {
                    setting = RED
                } else if setting == RED {
                    setting = GREEN
                }
            }
            
            let setNumDiff = notifsDiff / 2
            setNum += setNumDiff
            notifsLeft = notifsLeftScheduled!
            updateUI()
        } else if optionChosen == "3" {
            var settingsToJump = notifsDiff % 3
            while settingsToJump > 0 {
                if setting == GREEN {
                    setting = YELLOW
                } else if setting == YELLOW {
                    setting = RED
                } else if setting == RED {
                    setting = GREEN
                }
                settingsToJump -= 1
            }
            
            let setNumDiff = notifsDiff / 3
            setNum += setNumDiff
            notifsLeft = notifsLeftScheduled!
            // might screw up when near end of scheduled notifications
            // TODO: check back on that
            updateUI()
        }
    }
    
    @objc func backgroundShiftDetected() {
        notifsLeft = UIApplication.shared.scheduledLocalNotifications!.count
    }
    
    func stopEverything() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func updateUI() {
        setNumLbl.text = "\(String(describing: setNum))"
        
        switch setting {
        case GREEN:
            colorLbl.backgroundColor = GREEN_COLOR
        case YELLOW:
            colorLbl.backgroundColor = YELLOW_COLOR
        case RED:
            colorLbl.backgroundColor = RED_COLOR
        default:
            debugPrint("You messed up in updateUI()")
        }
    }
    
    func resetEverything() {
        setNum = 1
        setting = GREEN
        updateUI()
    }
    
    @IBAction func powerBtnPressed(_ sender: Any) {
        stopEverything()
        finishedFirstSession = true
        dismiss(animated: true, completion: nil)
        resetEverything()
    }
}

extension CurrentSetVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        switch setting {
        case GREEN:
            if optionChosen == "2" {
                setting = RED
            } else if optionChosen == "3" {
                setting = YELLOW
            }
        case YELLOW:
            setting = RED
        case RED:
            setting = GREEN
            setNum += 1
        default:
            debugPrint("messed up in willPresent")
        }
        
        updateUI()
        
        completionHandler(.sound)
        return
    }
}


