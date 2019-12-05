//
//  Extensions.swift
//  HomeTime
//
//  Created by iOS Developer on 12/5/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

// MARK: Date Extension
extension Date {
    
    /// This method is used to display the hour in 12 hour format
    func timeIn12HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    /// This method is used to calculate the difference between two time
    /// - Parameter fromTime: the time to compare with
    func timeDifference(since fromTime: Date) -> String {
        let interval = abs(self.timeIntervalSince(fromTime))
        let hours = Int(interval / 3600)
        let minutes = Int(interval.truncatingRemainder(dividingBy: 3600) / 60)
        if hours != 0 {
            return "\(hours.of("hour")) \(minutes.of("minute"))"
        } else if minutes != 0 {
            return "\(minutes.of("minute"))"
        } else {
            return "now"
        }
    }
}

// MARK: Integer extension
extension Int {
    
    /// This method is used to display the noun as plural or singular
    /// - Parameter name: The noun name. For example, student
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}
