//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by Sergey Moskvin on 29.12.2020.
//

import SwiftUI

struct DailyScrum: Identifiable, Codable {
    let id: UUID
    var title: String
    var members: [String]
    var durationInMinutes: Int
    var color: Color
    var history: [History]
    
    init(id: UUID = UUID(), title: String, members: [String], durationInMinutes: Int, color: Color, history: [History] = []) {
        self.id = id
        self.title = title
        self.members = members
        self.durationInMinutes = durationInMinutes
        self.color = color
        self.history = history
    }
}

extension DailyScrum {
    static var data: [DailyScrum] {
        [
            DailyScrum(title: "Design", members: ["Cathy", "Daisy", "Simon", "Jonathan"], durationInMinutes: 10, color: Color.yellow),
            DailyScrum(title: "App Dev", members: ["Katie", "Gray", "Euna", "Luis", "Darla"], durationInMinutes: 5, color: Color.orange),
            DailyScrum(title: "Web Dev", members: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], durationInMinutes: 1, color: Color.pink)
        ]
    }
}

extension DailyScrum {
    struct Data {
        var title: String = ""
        var members: [String] = []
        var durationInMinutes: Double = 5.0
        var color: Color = .random
    }
    
    var data: Data {
        return Data(title: title, members: members, durationInMinutes: Double(durationInMinutes), color: color)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        members = data.members
        durationInMinutes = Int(data.durationInMinutes)
        color = data.color
    }
}
