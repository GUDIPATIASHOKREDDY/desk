//
//  ProfileModel.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 4/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation

public func dataFromFile(_ filename: String) -> Data? {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    if let path = bundle.path(forResource: filename, ofType: "json") {
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    return nil
}

class Profile {
    var home = [Home]()
    var pictureUrl: String?
    var reports = [Reports]()
    var tickets = [Tickets]()
    var friends = [Friend]()
    var profileAttributes = [Attribute]()
    
    init?(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let body = json["data"] as? [String: Any] {
                if let home = body["home"] as? [[String: Any]]
                {
                    self.home = home.map { Home(json: $0) }
                }
                
                
                if let tickets = body["tickets"] as? [[String: Any]]
                {
                    self.tickets = tickets.map { Tickets(json: $0) }
                }
                
                
                if let reports = body["reports"] as? [[String: Any]]
                {
                    self.reports = reports.map { Reports(json: $0) }
                }
                
                
               // self.fullName = body["fullName"] as? String
                self.pictureUrl = body["pictureUrl"] as? String
               // self.about = body["about"] as? String
              //  self.email = body["email"] as? String
                
                if let friends = body["friends"] as? [[String: Any]] {
                    self.friends = friends.map { Friend(json: $0) }
                }
                
                if let profileAttributes = body["profileAttributes"] as? [[String: Any]] {
                    self.profileAttributes = profileAttributes.map { Attribute(json: $0) }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }
}

class Friend {
    var name: String?
    var pictureUrl: String?
    
    init(json: [String: Any]) {
        self.name = json["name"] as? String
        self.pictureUrl = json["pictureUrl"] as? String
    }
}
class Home {
    var dashboard:String?
    init(json: [String: Any]) {
        self.dashboard = json["dashboard"] as? String
       
    }
}

class Tickets{
    var tickettype:String?
    init(json: [String: Any]) {
        self.tickettype = json["tickettype"] as? String
        
    }
}

class Reports {
    var reporttype:String?
    init(json: [String: Any]) {
        self.reporttype = json["reportstype"] as? String
        
    }
}
class Attribute {
    var key: String?
    var value: String?
    
    init(json: [String: Any]) {
        self.key = json["key"] as? String
        self.value = json["value"] as? String
    }
}
