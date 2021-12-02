//
//  APIManager.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 02/12/2021.
//

import Foundation

class APIManager {
    
    private let googleUrl: String = "https://maps.googleapis.com/maps/api"
    private let googleKey: String = "AIzaSyDYC2snvmp61Ebi0NJ0R_iNfkhT4a2Qs0w"
    
    private let timezoneUrl: String = "https://timezoneapi.io/api/timezone"
    private let timezoneKey: String = "aATMXSVPZzMftdgmAmDu"
    
    private func getMethod(url: String, completion: @escaping ([String: Any]) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }

                completion(jsonObject)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func getTimeZone(address: String, completion: @escaping (String) -> Void) {
        let parsedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as String
        getMethod(url: "\(googleUrl)/geocode/json?address=\(parsedAddress)&key=\(googleKey)", completion: { jsonPosition in
            let position = ((((jsonPosition["results"] as! Array<Any>)[0] as AnyObject)["geometry"] as AnyObject)["location"] as AnyObject)
            let lat = position["lat"]!!
            let lng = position["lng"]!!

            let timestamp = Int(NSDate().timeIntervalSince1970)
            self.getMethod(url: "\(self.googleUrl)/timezone/json?location=\(lat),\(lng)&timestamp=\(timestamp)&key=\(self.googleKey)", completion: { jsonTimezone in
                let timezoneId = (jsonTimezone["timeZoneId"]) as! String
                completion(timezoneId)
            })
            
            
        })
    }
}
