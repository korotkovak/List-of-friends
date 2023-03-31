//
//  String + Ext.swift
//  List of friends
//
//  Created by Kristina Korotkova on 21/03/23.
//

import Foundation

extension String {
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

    func convertStringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.date(from: string)
        return dateFormatter.date(from: string) ?? Date()
    }
}
