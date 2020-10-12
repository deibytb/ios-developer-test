//
//  Extensions.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

extension Date {
  var onlyDate: String {
    return Formatter.date.string(from: self)
  }
  
  var onlyTime: String {
    return Formatter.hour.string(from: self)
  }
}

extension Formatter {
  static let date: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
  }()
  
  static let hour: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
  }()
}

extension Double {
  func roundForAmount() -> Double {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    let roundedAmount = formatter.string(from: self as NSNumber)!
    return Double(roundedAmount)!
  }
}

extension String {
  func convertToValidFileName() -> String {
    let invalidFileNameCharactersRegex = "[^a-zA-Z0-9_]+"
    let fullRange = startIndex..<endIndex
    var validName = replacingOccurrences(of: invalidFileNameCharactersRegex,
                                         with: "-",
                                         options: .regularExpression,
                                         range: fullRange)
    if validName.last == "-" {
      validName.removeLast()
    }
    return validName.lowercased()
  }
}
