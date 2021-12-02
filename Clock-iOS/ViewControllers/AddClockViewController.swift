//
//  AddClockViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class AddClockViewController: UIViewController {

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var clockNameText: UITextField!
    @IBOutlet private weak var mondayButton: UIDayButton!
    @IBOutlet private weak var tuesdayButton: UIDayButton!
    @IBOutlet private weak var wednesdayButton: UIDayButton!
    @IBOutlet private weak var thursdayButton: UIDayButton!
    @IBOutlet private weak var fridayButton: UIDayButton!
    @IBOutlet private weak var saturdayButton: UIDayButton!
    @IBOutlet private weak var sundayButton: UIDayButton!
    @IBOutlet private weak var deleteButton: UIButton!
    private var days = [Bool](repeating: false, count: 7)
    public var editAlarm : Alarm?
    
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
        if (editAlarm == nil) {
            deleteButton.isHidden = true
        }
        else {
            self.title = "Modifier une alarme"
        }
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
    
    private func registerNotification(alarm: Alarm) {
        // Create notification
        // Notification info
        let content = UNMutableNotificationContent()
        content.title = alarm.name
        content.body = "Cliquez ici pour arrêter l'alarme"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "audio/notification.mp3"))
        
        // Notification date
        // Parse time to desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
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
            registerNotification(alarm: alarm)
        }
        else {
            editAlarm?.name = name
            editAlarm?.days = days
            editAlarm?.isoDate = dateFormatter.string(from: time)
            editAlarm?.enabled = true
            editAlarm?.commit()
            registerNotification(alarm: editAlarm!)
        }
        
        
        print("Alarm added")
        
        // Go back to the main page
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAudio() {
        // Get the storyboard "Main"
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Get the ViewController "Clock"
        // let audioVC = storyboard.instantiateViewController(identifier: "AudioSelectViewController") as! AudioSelectViewController
        // Open it
        // self.navigationController?.pushViewController(audioVC, animated: true)
    }
}

