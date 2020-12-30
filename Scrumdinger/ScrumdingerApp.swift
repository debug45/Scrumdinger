//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Sergey Moskvin on 29.12.2020.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.data
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $scrums)
            }
        }
    }
}
