//
//  AddClockViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

var id: Int! = 0
let defaults = UserDefaults.standard
var alarmeIDD: [String] = []

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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        print(dateFormatter.string(from: time))

        
        if
        
        alarmeIDD[id] = "{id:\(id!), time: \(time), name: \(name), enable: true}"
        
        print(alarmeIDD[id])
        
        //donner json à sauvegarder
        
        let authtoken = alarmeIDD[id]
            // Userdefaults helps to store session data locally
        defaults.set(authtoken, forKey: "alarme_\(id)")

        defaults.synchronize()
        
        //print("\(UserDefaults.standard.array(forKey: <#T##String#>))")
        
        id += 1
        
    }
}

