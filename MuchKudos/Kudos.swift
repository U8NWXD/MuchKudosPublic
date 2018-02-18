//
//  Kudos.swift
//  MuchKudos
//
//  Created by cs on 2/18/18.
//

import Foundation

class Kudos {
    var body: String?
    var recipient: String?
    var timestamp: String?
    
    init(recipient: String, body: String, timestamp: NSNumber) {
        self.recipient = recipient
        self.body = body
        let date = Date(timeIntervalSince1970: TimeInterval(truncating: timestamp))
        self.timestamp = date.description(with: Locale.current)
    }
    
    func toString() -> String {
        var result: String = "["
        result += timestamp! + "] Kudos to "
        result += recipient! + ": "
        result += body!
        return result
    }
}
