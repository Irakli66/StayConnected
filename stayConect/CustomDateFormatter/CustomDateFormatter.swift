//
//  CustomDateFormatter.swift
//  CustomDateFormatter
//
//  Created by irakli kharshiladze on 30.11.24.
//

import Foundation

public protocol CustomDateFormatterProtocol {
    func formattedDate(from: String, inputFormat: String, outputFormat: String) -> String
}

public final class CustomDateFormatter: CustomDateFormatterProtocol {
    public init() {}
    
    public func formattedDate(from dateString: String, inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", outputFormat: String = "EEEE, d MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Unknown Date"
        }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}
