//
//  Util.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}
