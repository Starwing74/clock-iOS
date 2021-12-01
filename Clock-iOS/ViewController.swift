//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var alarmsTable: UITableView!
    var alarmIds: [Int] = []
    
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
        
        // Request notifications permission
        let  authOption = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { (success, error) in
            if let error = error {
                print("Error:", error)
            }
        }
        
        // Used to clear the alarms for debugging purpose
        /*defaults.set(0, forKey: "idCounter")
        defaults.set([], forKey: "alarmIds")*/
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlarmsIds()
        alarmsTable?.reloadData()   // ...and it is also visible here.
    }
    
    @IBAction func openAddClock(_ sender: UIBarButtonItem) {
        // Get the storyboard "Main"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Get the ViewController "Clock"
        let clockVC = storyboard.instantiateViewController(identifier: "AddClockViewController") as! AddClockViewController
        // Open it
        self.navigationController?.pushViewController(clockVC, animated: true)
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
        let cell = tableView.cellForRow(at: indexPath)
        print(cell.getAlarm)
    }
    
    /**
     Populates the TableView with the data from the alarms
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Add call")
        // Get alarm from defaults
        let defaults = UserDefaults.standard
        let alarmId = alarmIds.last
        _ = alarmIds.popLast()
        
        // Create Alarm object
        let alarmJSON: String = defaults.string(forKey: "alarm\(alarmId ?? 0)")!
        let alarm = Alarm(alarmJSON: alarmJSON)
        
        // Update cell values
        let cell = alarmsTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath) as! AlarmTableViewCell
        cell.setAlarm(alarm: alarm) // Create Alarm object from AlarmStruct
        cell.setName(name: alarm.name)
        cell.setTime(isoDate: alarm.isoDate)
        cell.setEnabled(enabled: alarm.enabled)
        cell.setDays(days: alarm.days)

        return cell
    }
}

