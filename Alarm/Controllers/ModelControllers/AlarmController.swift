//
//  AlarmController.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

class AlarmController {
    
    // MARK: - Singleton
    static var shared = AlarmController()
    
    // MARK: - Properties
    var alarms: [Alarm] = []
    
    // MARK: - CRUD Methods
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) {
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        // Save to persistence.
    }
    
    
    
}
