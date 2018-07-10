//
//  AlarmController.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController {
    
    // MARK: - Singleton
    static var shared = AlarmController()
    
    // MARK: - Properties
    var alarms: [Alarm] = []
    
    var mockAlarms: [Alarm] {
        let parkingPass = Alarm(fireTimeFromMidnight: 50000, name: "Get parking pass.")
        let walkDog = Alarm(fireTimeFromMidnight: 9823, name: "Walk Finn.")
        let finishAlarmProject = Alarm(fireTimeFromMidnight: 102746, name: "Finish the alarm project.")
        return [parkingPass, walkDog, finishAlarmProject]
    }
    
    // MARK: - Initializers
    init() {
        self.alarms = self.mockAlarms
    }
    
    // MARK: - CRUD Methods
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        saveToPersistentStorage()
        return newAlarm
    }
    
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let indexOfAlarmToDelete = alarms.index(of: alarm) else { return }
        alarms.remove(at: indexOfAlarmToDelete)
        saveToPersistentStorage()
    }
    
    // MARK: - Instance Methods
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
    func saveToPersistentStorage() {
        guard let persistentAlarmsFilePath = AlarmController.persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(alarms, toFile: persistentAlarmsFilePath)
    }
    
    func loadFromPersistentStorage() {
        guard let persistentAlarmsFilePath = AlarmController.persistentAlarmsFilePath else { return }
        if let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: persistentAlarmsFilePath) as? [Alarm] {
            self.alarms = alarms
        }
    }
    
}

// MARK: - Protocols
protocol AlarmScheduler: class {
    
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
    
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.body = "\(alarm.name) is over!"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (e) in
            if let e = e {
                print("Error occurred: \(e.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
}
