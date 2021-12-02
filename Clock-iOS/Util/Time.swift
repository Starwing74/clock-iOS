//
//  Alarm.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 01/12/2021.
//

import Foundation

class Time {
    private var id: Int
    public var address: String
    public var timeZoneId: String
    private struct TimeStruct: Codable {
        var id: Int
        var name: String
        var isoDate: String
    }
    
    public init(timeJSON: String) {
        let decoder = JSONDecoder()
        let timeJSONData = timeJSON.data(using: .utf8)!
        let timeStruct = try! decoder.decode(TimeStruct.self, from: timeJSONData)
        
        self.id = timeStruct.id
        self.address = timeStruct.name
        self.timeZoneId = timeStruct.isoDate
    }
    
    public init(name: String?, timeZoneId: String) {
        self.id = -1
        self.address = name ?? ""
        self.timeZoneId = timeZoneId
    }
    
    private func toJSON() -> String {
        let tempTime: TimeStruct = TimeStruct(id: id, name: address, isoDate: timeZoneId)
        let jsonData = try! JSONEncoder().encode(tempTime)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    public func commit() {
        let defaults = UserDefaults.standard
        
        // Get existing data in defaults
        var timeIds = defaults.array(forKey: "timeIds")  as? [Int] ?? [Int]()

        // Add the alarm id so we can keep track of it (if it doesn't exists)
        if (!timeIds.contains(id)) {
            var idCounter = defaults.integer(forKey: "idCounter")
            // First set id and add it
            timeIds.append(idCounter)
            id = idCounter
            
            // Then increment id and set new value
            idCounter += 1
            defaults.set(idCounter, forKey: "idCounter")
            defaults.set(timeIds, forKey: "timeIds")
        }
        
        // Set values in defaults
        defaults.set(toJSON(), forKey: "time\(id)")
    }
    
    public func delete() {
        let defaults = UserDefaults.standard
        
        // Get existing data in defaults
        var alarmIds = defaults.array(forKey: "timeIds")  as? [Int] ?? [Int]()

        // Add the alarm id so we can keep track of it (if it doesn't exists)
        if (alarmIds.contains(id)) {
            // Remove alarm id from list
            let alarmIdIndex = alarmIds.firstIndex(of: id)!
            alarmIds.remove(at: alarmIdIndex)
            
            // Remove alarm from defaults
            defaults.removeObject(forKey: "time\(id)")
            
            // Update values
            defaults.set(alarmIds, forKey: "timeIds")
        }
    }
}
