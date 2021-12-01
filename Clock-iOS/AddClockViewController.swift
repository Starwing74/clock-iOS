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
@IBDesignable class UIDayButton: UIButton {
    @IBInspectable public var day: Int = 0
    public var isToggled = false
}

class AddClockViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var clockNameText: UITextField!
    @IBOutlet weak var mondayButton: UIDayButton!
    @IBOutlet weak var tuesdayButton: UIDayButton!
    @IBOutlet weak var wednesdayButton: UIDayButton!
    @IBOutlet weak var thursdayButton: UIDayButton!
    @IBOutlet weak var fridayButton: UIDayButton!
    @IBOutlet weak var saturdayButton: UIDayButton!
    @IBOutlet weak var sundayButton: UIDayButton!
    @IBOutlet weak var deleteButton: UIButton!
    var days = [Bool](repeating: false, count: 7)
    var editAlarm : Alarm?
    
    /*
     Called on "DayButton" click, toggle the button and change the days array state
     */
    @IBAction func toggleButton(sourceButton: UIDayButton) {
        let toggled = !sourceButton.isToggled
        sourceButton.isToggled = toggled
        sourceButton.backgroundColor = toggled ? UIColor.systemBlue : UIColor.systemBackground
        sourceButton.titleLabel?.textColor = toggled ? UIColor.white : UIColor.systemBlue // Called by function
        sourceButton.setTitleColor(toggled ? UIColor.white : UIColor.systemBlue, for: .normal) // Clicked by user
        days[sourceButton.day] = toggled
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the delete button if we are adding a new alarm
        if (editAlarm == nil) { deleteButton.isHidden = true }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If we are editing an alarm, restore the values
        if (editAlarm != nil) {
            let alarm: Alarm = editAlarm!
            
            // Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
            print(alarm.isoDate)
            let alarmDate = dateFormatter.date(from: alarm.isoDate)! // "Jun 5, 2016, 4:56 PM"
            datePicker.setDate(alarmDate, animated: true)
            
            // Name
            clockNameText.text = alarm.name
            
            // Days
            let days = alarm.days
            if(days[0]) { toggleButton(sourceButton: mondayButton) }
            if(days[1]) { toggleButton(sourceButton: tuesdayButton) }
            if(days[2]) { toggleButton(sourceButton: wednesdayButton) }
            if(days[3]) { toggleButton(sourceButton: thursdayButton) }
            if(days[4]) { toggleButton(sourceButton: fridayButton) }
            if(days[5]) { toggleButton(sourceButton: saturdayButton) }
            if(days[6]) { toggleButton(sourceButton: sundayButton) }
        }
    }
    
    @IBAction func deleteClock() {
        let that = self
        let refreshAlert = UIAlertController(title: "Attention", message: "Cette alarme sera supprimée", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Confirmer", style: .default, handler: { (action: UIAlertAction!) in
            // Delete alarm
            that.editAlarm?.delete()
            // Go back to the main page
            _ = that.navigationController?.popViewController(animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveClock(_ sender: UIBarButtonItem) {
        // Get name and time from UI
        let time: Date = datePicker.date
        let name: String = clockNameText.text ?? ""

        // Parse time to desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        // Create Alarm object
        if (editAlarm == nil) {
            let alarm = Alarm(name: name, isoDate: dateFormatter.string(from: time), enabled: true, days: days)
            alarm.commit()
        }
        else {
            editAlarm?.name = name
            editAlarm?.days = days
            editAlarm?.isoDate = dateFormatter.string(from: time)
            editAlarm?.enabled = true
            editAlarm?.commit()
        }
        
        /*
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
        }*/
        print("Alarm added")
        
        // Go back to the main page
        _ = navigationController?.popViewController(animated: true)
    }
}

