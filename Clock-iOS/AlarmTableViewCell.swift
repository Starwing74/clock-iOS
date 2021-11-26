//
//  AlarmTableViewCell.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    private var alarm: Alarm!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setAlarm(alarm: Alarm) {
        self.alarm = alarm
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setName(name: String) {
        nameLabel.text = name
    }

    func setTime(isoDate: String) {
        let dateFormatter = DateFormatter()
        // Parse date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        let date = dateFormatter.date(from: isoDate)!
        // Set text value
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func setEnabled(enabled: Bool) {
        enabledSwitch.setOn(enabled, animated: true)
    }
    
    @IBAction func switchChanged() {
        alarm.enabled = enabledSwitch.isOn
        print("Switch changed")
    }
    
}
