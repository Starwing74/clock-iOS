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

    public func setAlarm(alarm: Alarm) {
        self.alarm = alarm
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func setName(name: String) {
        nameLabel.text = name
    }

    public func setTime(isoDate: String) {
        let dateFormatter = DateFormatter()
        // Parse date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        let date = dateFormatter.date(from: isoDate)!
        // Set text value
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    public func setEnabled(enabled: Bool) {
        enabledSwitch.setOn(enabled, animated: true)
    }
    
    private func coloredText(text: String) {
        
    }
    
    public func setDays(days: [Bool]) {
        // UIFont font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
        let myMutableString = NSMutableAttributedString(string: "Bonjour")
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:4))
        // set label Attribute
        daysLabel.attributedText = myMutableString
    }
    
    @IBAction func switchChanged() {
        alarm.enabled = enabledSwitch.isOn
        alarm.commit()
        print("Switch changed")
    }
    
}
