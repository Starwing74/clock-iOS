//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class Alarm {
    private var id: Int
    private var allowSelfUpdate: Bool = false
    public var name: String { didSet { self.selfUpdate() }}
    public var isoDate: String { didSet { self.selfUpdate() }}
    public var enabled: Bool { didSet { self.selfUpdate() }}
    private struct AlarmStruct: Codable {
        var id: Int
        var name: String
        var isoDate: String
        var enabled: Bool
    }
    
    public init(alarmJSON: String) {
        let decoder = JSONDecoder()
        let alarmJSONData = alarmJSON.data(using: .utf8)!
        let alarmStruct = try! decoder.decode(AlarmStruct.self, from: alarmJSONData)
        
        self.id = alarmStruct.id
        self.name = alarmStruct.name
        self.isoDate = alarmStruct.isoDate
        self.enabled = alarmStruct.enabled
        self.allowSelfUpdate = true
    }
    
    public init(name: String?, isoDate: String, enabled: Bool) {
        self.id = -1
        self.name = name ?? ""
        self.isoDate = isoDate
        self.enabled = enabled
        self.allowSelfUpdate = true
        selfUpdate();
    }
    
    private func toJSON() -> String {
        let tempAlarm: AlarmStruct = AlarmStruct(id: id, name: name, isoDate: isoDate, enabled: enabled)
        let jsonData = try! JSONEncoder().encode(tempAlarm)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    private func selfUpdate() {
        
        if (!allowSelfUpdate) { return } // Prevent self update spam on initaliaztion
        
        let defaults = UserDefaults.standard
        
        // Get existing data in defaults
        var alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()

        // Add the alarm id so we can keep track of it (if it doesn't exists)
        if (!alarmIds.contains(id)) {
            var idCounter = defaults.integer(forKey: "idCounter")
            // First set id and add it
            alarmIds.append(idCounter)
            self.id = idCounter
            
            // Then increment id and set new value
            idCounter += 1
            defaults.set(idCounter, forKey: "idCounter")
            defaults.set(alarmIds, forKey: "alarmIds")
        }
        
        // Set values in defaults
        defaults.set(toJSON(), forKey: "alarm\(id)")
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var alarmsTable: UITableView!
    var alarmIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmsTable?.delegate = self
        self.alarmsTable?.dataSource = self
        
        print("init call")
        let defaults = UserDefaults.standard
        let alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()
        self.alarmIds = alarmIds
        
        let  authOption = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { (success, error) in
            if let error = error {
                print("Error:", error)
            }
        }
        
        /*defaults.set(0, forKey: "idCounter")
        defaults.set([], forKey: "alarmIds")*/
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
        
        // Create Alarm object
        let alarmJSON: String = defaults.string(forKey: "alarm\(alarmId ?? 0)")!
        let alarm = Alarm(alarmJSON: alarmJSON)
        
        // Update cell values
        let cell = alarmsTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath) as! AlarmTableViewCell
        cell.setAlarm(alarm: alarm) // Create Alarm object from AlarmStruct
        cell.setName(name: alarm.name)
        cell.setTime(isoDate: alarm.isoDate)
        cell.setEnabled(enabled: alarm.enabled)
        
        return cell
    }

}

