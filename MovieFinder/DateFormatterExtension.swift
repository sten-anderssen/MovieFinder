//
//  DateFormatterExtension.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 02.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Returns a formatter with date format "2018-06-01"
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
