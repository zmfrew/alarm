//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // MARK: - Actions
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    // MARK: - Properties
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
     
}

// MARK: - Protocol Declaration
protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}
