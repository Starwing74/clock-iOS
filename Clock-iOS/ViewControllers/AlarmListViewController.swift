//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDYC2snvmp61Ebi0NJ0R_iNfkhT4a2Qs0w&address=Grenoble
    // https://maps.googleapis.com/maps/api/timezone/json?key=AIzaSyDYC2snvmp61Ebi0NJ0R_iNfkhT4a2Qs0w&location=45.188529,5.724524&timestamp=1331161200
    // https://timezoneapi.io/api/timezone/?token=aATMXSVPZzMftdgmAmDu&Europe/Paris
    
    @IBOutlet private weak var alarmsTable: UITableView!
    private var alarmIds: [Int] = []
    
    private func getAlarmsIds() {
        let defaults = UserDefaults.standard
        let alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()
        self.alarmIds = alarmIds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmsTable?.delegate = self
        self.alarmsTable?.dataSource = self
    
        // Get alarms ids
        getAlarmsIds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlarmsIds()
        alarmsTable?.reloadData()   // ...and it is also visible here.
    }
    
    func openAddClock(alarm: Alarm?) {
        // Get the storyboard "Main"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Get the ViewController "Clock"
        let clockVC = storyboard.instantiateViewController(identifier: "AddClockViewController") as! AddClockViewController
        if ((alarm) != nil) { clockVC.editAlarm = alarm }
        // Open it
        self.navigationController?.pushViewController(clockVC, animated: true)
    }
    
    @IBAction func openAddClockButtonClick(_ sender: UIBarButtonItem) {
        openAddClock(alarm: nil);
    }

    /**
     Tells the TableView how many rows there are
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(alarmIds.count) alarms")
        return alarmIds.count
    }

    /**
     On row clicked
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! UIAlarmTableViewCell
        let alarm = cell.alarm!
        openAddClock(alarm: alarm)
    }
    
    /**
     Populates the TableView with the data from the alarms
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Addding alarm to the TableView")
        // Get alarm from defaults
        let defaults = UserDefaults.standard
        let alarmId = alarmIds.last
        _ = alarmIds.popLast()
        
        // Create Alarm object
        let alarmJSON: String = defaults.string(forKey: "alarm\(alarmId ?? 0)")!
        let alarm = Alarm(alarmJSON: alarmJSON)
        
        // Update cell values
        let cell = alarmsTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath) as! UIAlarmTableViewCell
        cell.alarm = alarm // Create Alarm object from AlarmStruct
        cell.setName(name: alarm.name)
        cell.setTime(isoDate: alarm.isoDate)
        cell.setEnabled(enabled: alarm.enabled)
        cell.setDays(days: alarm.days)

        return cell
    }
}

