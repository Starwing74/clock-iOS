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
        print("sauvergarder")

        let time: Date = datePicker.date
        let name: String = clockNameText.text ?? ""

        // let dateFormatter = DateFormatter()
        // dateFormatter.dateFormat = "HH:mm"
        // print(dateFormatter.string(from: time))
        
        print(time)
        print(name)
    }
}

