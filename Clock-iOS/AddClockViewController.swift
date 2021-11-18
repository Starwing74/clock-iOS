//
//  AddClockViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class AddClockViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var clockNameText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClock(_ sender: UIBarButtonItem) {
        print("Adding new alarm")
        let defaults = UserDefaults.standard
        // Get name and time from UI
        let time: Date = datePicker.date
        let name: String = clockNameText.text ?? ""

        // Parse time to desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";

        // Get existing data in defaults
        var idCounter = defaults.integer(forKey: "idCounter")
        var alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()

        // Create JSON from data
        let alarm: Alarm = Alarm(id: idCounter, name: name, time: dateFormatter.string(from: time), enabled: true)
        let jsonData = try! JSONEncoder().encode(alarm)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        // Add the alarm id so we can keep track of it
        alarmIds.append(idCounter)
        
        idCounter += 1
        
        // Set values in defaults
        defaults.set(idCounter, forKey: "idCounter")
        defaults.set(alarmIds, forKey: "alarmIds")
        defaults.set(jsonString, forKey: "alarm\(idCounter - 1)")

        print("JSON: \(jsonString)")
        print("IDS: \(alarmIds)")
        print("COUNTER: \(idCounter)")
    }
}

