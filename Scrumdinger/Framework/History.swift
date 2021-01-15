/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var members: [String]
    var durationInMinutes: Int
    var transcript: String?

    init(id: UUID = UUID(), date: Date = Date(), members: [String], durationInMinutes: Int, transcript: String? = nil) {
        self.id = id
        self.date = date
        self.members = members
        self.durationInMinutes = durationInMinutes
        self.transcript = transcript
    }
}
