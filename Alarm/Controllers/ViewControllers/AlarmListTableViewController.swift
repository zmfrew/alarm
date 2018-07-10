//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.loadFromPersistentStorage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AlarmController.shared.loadFromPersistentStorage()

        tableView.reloadData()
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        let alarmToBeDisplayed = AlarmController.shared.alarms[indexPath.row]
        cell.alarm = alarmToBeDisplayed
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailAlarm" {
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let alarmToDetail = AlarmController.shared.alarms[indexPath.row]
            destinationVC.alarm = alarmToDetail
        }
    }
 
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate, AlarmScheduler {
    
    // MARK: - Protocol Conformance
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if alarm.enabled {
            
        }
    }
    
}
