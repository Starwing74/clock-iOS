//
//  Alarm.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 01/12/2021.
//

import Foundation

class Alarm {
    private var id: Int
    public var name: String
    public var isoDate: String
    public var enabled: Bool
    public var days: [Bool]
    private struct AlarmStruct: Codable {
        var id: Int
        var name: String
        var isoDate: String
        var enabled: Bool
        var days: [Bool]
    }
    
    public init(alarmJSON: String) {
        let decoder = JSONDecoder()
        let alarmJSONData = alarmJSON.data(using: .utf8)!
        let alarmStruct = try! decoder.decode(AlarmStruct.self, from: alarmJSONData)
        
        self.id = alarmStruct.id
        self.name = alarmStruct.name
        self.isoDate = alarmStruct.isoDate
        self.enabled = alarmStruct.enabled
        self.days = alarmStruct.days
    }
    
    public init(name: String?, isoDate: String, enabled: Bool, days: [Bool]) {
        self.id = -1
        self.name = name ?? ""
        self.isoDate = isoDate
        self.enabled = enabled
        self.days = days
    }
    
    private func toJSON() -> String {
        let tempAlarm: AlarmStruct = AlarmStruct(id: id, name: name, isoDate: isoDate, enabled: enabled, days: days)
        let jsonData = try! JSONEncoder().encode(tempAlarm)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    public func commit() {
        let defaults = UserDefaults.standard
        
        // Get existing data in defaults
        var alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()

        // Add the alarm id so we can keep track of it (if it doesn't exists)
        if (!alarmIds.contains(id)) {
            var idCounter = defaults.integer(forKey: "idCounter")
            // First set id and add it
            alarmIds.append(idCounter)
            id = idCounter
            
            // Then increment id and set new value
            idCounter += 1
            defaults.set(idCounter, forKey: "idCounter")
            defaults.set(alarmIds, forKey: "alarmIds")
        }
        
        // Set values in defaults
        defaults.set(toJSON(), forKey: "alarm\(id)")
    }
    
    public func delete() {
        let defaults = UserDefaults.standard
        
        // Get existing data in defaults
        var alarmIds = defaults.array(forKey: "alarmIds")  as? [Int] ?? [Int]()

        // Add the alarm id so we can keep track of it (if it doesn't exists)
        if (alarmIds.contains(id)) {
            // Remove alarm id from list
            let alarmIdIndex = alarmIds.firstIndex(of: id)!
            alarmIds.remove(at: alarmIdIndex)
            
            // Remove alarm from defaults
            defaults.removeObject(forKey: "alarm\(id)")
            
            // Update values
            defaults.set(alarmIds, forKey: "alarmIds")
        }
    }
}
