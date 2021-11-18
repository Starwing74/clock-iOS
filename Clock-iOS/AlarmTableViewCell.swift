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
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        let date = dateFormatter.date(from: "2021-11-18T14:08:26+01:00")!
        // Set text value
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func setEnabled(enabled: Bool) {
        enabledSwitch.setOn(enabled, animated: true)
    }
    
} // 2021-11-18 09:55:02 +0000
