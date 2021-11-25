//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

struct AlarmStruct: Codable {
    var id: Int
    var name: String
    var isoDate: String
    var enabled: Bool
}

class Alarm {
    var id: Int
    var name: String
    var isoDate: String
    var enabled: Bool

    init(id: Int, name: String?, isoDate: String, enabled: Bool) {
        self.id = id
        self.name = name ?? ""
        self.isoDate = isoDate
        self.enabled = enabled
    }
    
    func toJSON() -> String {
        let tempAlarm: AlarmStruct = AlarmStruct(id: id, name: name, isoDate: isoDate, enabled: enabled)
        let jsonData = try! JSONEncoder().encode(tempAlarm)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    func selfUpdate() {
        let defaults = UserDefaults.standard
        defaults.set(toJSON(), forKey: "alarm\(id)")
    }
    
    func setEnabled(enabled: Bool) {
        self.enabled = enabled
        selfUpdate()
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var alarmsTable: UITableView!
    // var clockJson = "{\"id\":0, \"time\": \"2021-11-18T14:08:26+01:00\", \"name\":\"Travail\", \"enabled\": true}".data(using: .utf8)!
    var alarmIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmsTable?.delegate = self
        self.alarmsTable?.dataSource = self
        
        print("init call")
        let defaults = UserDefaults.standard
        let alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()
        self.alarmIds = alarmIds
        
        
        // defaults.set(0, forKey: "idCounter")
        // defaults.set([], forKey: "alarmIds")
    }

    @IBAction func openAddClock(_ sender: UIBarButtonItem) {
        // Get the storyboard "Main"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Get the ViewController "Clock"
        let clockVC = storyboard.instantiateViewController(identifier: "AddClockViewController") as! AddClockViewController
        // Open it
        self.navigationController?.pushViewController(clockVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(alarmIds.count) alarms")
        return alarmIds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Add call")
        // Get alarm from defaults
        let defaults = UserDefaults.standard
        let alarmId = alarmIds.last
        _ = alarmIds.popLast()
        
        /*// Get it's json and parse it
        let decoder = JSONDecoder()
        let clockJson = defaults.string(forKey: "alarm\(alarmId ?? 0)")!.data(using: .utf8)!
        let alarm = try! decoder.decode(AlarmStruct.self, from: clockJson)
        print(alarm)*/
        
        // Update cell values
        let cell = alarmsTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath) as! AlarmTableViewCell
        /*cell.setName(name: alarm.name ?? "")
        cell.setTime(isoDate: alarm.isoDate)
        cell.setEnabled(enabled: alarm.enabled)*/
        
        return cell
    }

}

