//
//  ScrumListView.swift
//  Scrumdinger
//
//  Created by Sergey Moskvin on 29.12.2020.
//

import SwiftUI

struct ScrumListView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @State private var newScrumData = DailyScrum.Data()
    init(_ scrums: Binding<[DailyScrum]>) {
        self._scrums = scrums
    }
    var body: some View {
        List {
            ForEach(scrums) { scrum in
                NavigationLink(destination: DetailView(scrum: binding(for: scrum))) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.color)
            }
        }
        .navigationTitle("Daily Scrums")
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(scrumData: $newScrumData)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isPresented = false
                    }, trailing: Button("Add") {
                        let newScrum = DailyScrum(title: newScrumData.title, members: newScrumData.members, durationInMinutes: Int(newScrumData.durationInMinutes), color: newScrumData.color)
                        scrums.append(newScrum)
                        isPresented = false
                    })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                DataManager.instance.save()
            }
        }
    }
    
    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $scrums[scrumIndex]
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumListView(.constant(DailyScrum.data))
        }
    }
}
