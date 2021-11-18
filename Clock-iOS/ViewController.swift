//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

struct Alarm: Codable {
    var id: Int
    var name: String?
    var time: String
    var enabled: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var alarmsTable: UITableView!
    var clockJson = "{\"id\":0, \"time\": \"2021-11-18T14:08:26+01:00\", \"name\":\"Travail\", \"enabled\": true}".data(using: .utf8)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmsTable?.delegate = self
        self.alarmsTable?.dataSource = self
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "idCounter")
        defaults.set([], forKey: "alarmIds")
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let decoder = JSONDecoder()
        let alarm = try! decoder.decode(Alarm.self, from: clockJson)
        
        let cell = alarmsTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath) as! AlarmTableViewCell
        
        // Name
        cell.setName(name: alarm.name ?? "")
        // Time
        cell.setTime(isoDate: alarm.time)
        // Enabled
        cell.setEnabled(enabled: alarm.enabled)
        
        return cell
    }

}

