//
//  AddClockViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

/*
 Custom button type for days
 It's a toggle button with a number corresponding to its day (0 to 6)
 */
@IBDesignable class DayButton: UIButton {
    @IBInspectable public var day: Int = 0
    public var isToggled = false
}

class AddClockViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var clockNameText: UITextField!
    var days = [Bool](repeating: false, count: 7)
    
    /*
     Called on "DayButton" click, toggle the button and change the days array state
     */
    @IBAction func toggleButton(sourceButton: DayButton) {
        sourceButton.isToggled = !sourceButton.isToggled
        let toggled = sourceButton.isToggled
        sourceButton.backgroundColor = toggled ? UIColor.systemBlue : UIColor.white
        sourceButton.setTitleColor(toggled ? UIColor.white : UIColor.systemBlue, for: .normal)
        days[sourceButton.day] = toggled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClock(_ sender: UIBarButtonItem) {
        // Get name and time from UI
        let time: Date = datePicker.date
        let name: String = clockNameText.text ?? ""

        // Parse time to desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";

        // Create Alarm object
        let alarm = Alarm(name: name, isoDate: dateFormatter.string(from: time), enabled: true, days: days)
        alarm.commit()
        
        // Create notification
        // Notification info
        let content = UNMutableNotificationContent()
        content.title = alarm.name
        content.body = "Cliquez ici pour arrêter l'alarme"

        // Notification date
        let date = dateFormatter.date(from: alarm.isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .timeZone], from: date)
        
        // Notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if (error != nil) {
                print(error ?? "no error")
                print("error happened")
            }
            print("Notification added")
        }
        print("Alarm added")
        
        // Go back to the main page
        _ = navigationController?.popViewController(animated: true)
    }
}

