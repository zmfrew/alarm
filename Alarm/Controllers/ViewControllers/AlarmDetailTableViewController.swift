//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: Outlets
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var alarmButton: UIButton!
    
    // MARK: Actions
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight, let alarmName = alarmTitleTextField.text, !alarmName.isEmpty, alarmName != " " else {
            alarmTitleTextField.text = ""
            return
        }
        let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSince(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: alarmName)
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        } else {
            let newAlarm = AlarmController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: alarmName)
            scheduleUserNotifications(for: newAlarm)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Properties
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    // MARK: Methods
    private func updateViews() {
        guard let alarm = alarm, let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight, isViewLoaded else {
            alarmButton.isHidden = true
            return
        }
        alarmDatePicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: true)
        alarmTitleTextField.text = alarm.name
        alarmButton.isHidden = false
        
        if alarm.enabled {
            alarmButton.setTitle("Disable", for: UIControlState())
            alarmButton.backgroundColor = .red
        } else {
            alarmButton.setTitle("Enable", for: UIControlState())
            alarmButton.backgroundColor = .blue
        }
        self.title = alarm.name
    }
    
}

// MARK: - Protocol Adoption
extension AlarmDetailTableViewController: AlarmScheduler {
    
}
