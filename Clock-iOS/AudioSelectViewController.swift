//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class AudioSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var audiosTable: UITableView!
    var audios: [Int] = []
    
    private func getAudios() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audiosTable?.delegate = self
        self.audiosTable?.dataSource = self
    
        // Get alarms ids
        getAudios()
        
        // Request notifications permission
        let  authOption = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { (success, error) in
            if let error = error {
                print("Error:", error)
            }
        }
        
        // Used to clear the alarms for debugging purpose
        /*defaults.set(0, forKey: "idCounter")
        defaults.set([], forKey: "alarmIds")*/
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAudios()
        audiosTable?.reloadData()   // ...and it is also visible here.
    }
    
    func openAddClock(alarm: Alarm?) {
        // Get the storyboard "Main"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Get the ViewController "Clock"
        let clockVC = storyboard.instantiateViewController(identifier: "AddClockViewController") as! AddClockViewController
        if ((alarm) != nil) { clockVC.editAlarm = alarm }
        // Open it
        self.navigationController?.pushViewController(clockVC, animated: true)
    }
    
    @IBAction func openAddClockButtonClick(_ sender: UIBarButtonItem) {
        openAddClock(alarm: nil);
    }

    /**
     Tells the TableView how many rows there are
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(audios.count) alarms")
        return audios.count
    }

    /**
     On row clicked
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! UIAlarmTableViewCell
        let alarm = cell.alarm!
        openAddClock(alarm: alarm)
    }
    
    /**
     Populates the TableView with the data from the alarms
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Add call")

        

        // Update cell values
        let cell = audiosTable.dequeueReusableCell(withIdentifier: "dummyAlarm", for: indexPath)


        return cell
        
    }
}

