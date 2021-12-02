//
//  AlarmTableViewCell.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class UITimeZoneTableViewCell: UITableViewCell {

    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    public var time: Time!
    public var source: TimeListViewController!
    private var timeZoneId: String!
    
    /**
     Set the name of the alarm
     */
    public func setAddress(address: String) {
        addressLabel.text = address
    }
    
    public func setTimeZoneId(timeZoneId: String) {
        self.timeZoneId = timeZoneId
        setTimeText()
    }

    /**
     Set the time of the alarm from an ISO date
     */
    public func setTimeText() {
        // Pase isodate to time
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = TimeZone(identifier: timeZoneId)!
        format.dateFormat = "HH:mm:ss"
        let time = format.string(from: currentDate)
        timeLabel.text = time
    }
    
    func setSource(source: TimeListViewController){
        self.source = source
    }
    
    func setTime(time: Time) {
        self.time = time
    }
    
    func registerUpdate() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.setTimeText()
        })
    }
    
    @IBAction func deleteTime(source: UIButton) {
        time.delete()
        self.source.getTimeIds(reload: true)
    }
}
