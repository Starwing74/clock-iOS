//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class TimeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var timesTable: UITableView!
    private var timeIds: [Int] = []
    
    public func getTimeIds(reload: Bool) {
        let defaults = UserDefaults.standard
        let timeIds = defaults.array(forKey: "timeIds")  as? [Int] ?? [Int]()
        self.timeIds = timeIds
        if (reload) { timesTable.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timesTable?.delegate = self
        self.timesTable?.dataSource = self
        searchBar.delegate = self
        
        // Get alarms ids
        getTimeIds(reload: false)
    }
    
    func searchBarSearchButtonClicked(_: UISearchBar) {
        let manager = APIManager()
        manager.getTimeZone(address: searchBar.text ?? "Paris", completion: { [self] timeZone in
            DispatchQueue.main.async {
                let time = Time(name: self.searchBar.text, timeZoneId: timeZone)
                time.commit()
                print("relaod")
                getTimeIds(reload: true)
                searchBar.text = ""
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTimeIds(reload: true)   // ...and it is also visible here.
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
        print("There are \(timeIds.count) times")
        return timeIds.count
    }

    /**
     On row clicked
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
    /**
     Populates the TableView with the data from the alarms
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Addding time to the TableView")
        // Get alarm from defaults
        let defaults = UserDefaults.standard
        let timeId = timeIds.last
        _ = timeIds.popLast()
        
        // Create Alarm object
        let timeJSON: String = defaults.string(forKey: "time\(timeId ?? 0)") ?? "{}"
        if (timeJSON != "{}") {
            let time = Time(timeJSON: timeJSON)
            
            // Update cell values
            let cell = timesTable.dequeueReusableCell(withIdentifier: "dummyTime", for: indexPath) as! UITimeZoneTableViewCell
            cell.setSource(source: self)
            cell.setTime(time: time)
            cell.setAddress(address: time.address)
            cell.setTimeZoneId(timeZoneId: time.timeZoneId)
            cell.registerUpdate()
            return cell
        }
        else {
            return timesTable.dequeueReusableCell(withIdentifier: "dummyTime", for: indexPath) as! UITimeZoneTableViewCell
        }
    }
}

