//
//  App.swift
//  Scrumdinger
//
//  Created by Sergey Moskvin on 29.12.2020.
//

import SwiftUI

@main
struct Scrumdinger: App {
    
    @ObservedObject private var dataManager = DataManager.instance
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumListView($dataManager.scrums)
            }
        }
    }
}
