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

        // Create JSON from data
        let alarm: Alarm = Alarm(name: name, isoDate: dateFormatter.string(from: time), enabled: true)
        alarm.selfUpdate();
    }
}

