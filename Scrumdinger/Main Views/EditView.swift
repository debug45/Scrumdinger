//
//  EditView.swift
//  Scrumdinger
//
//  Created by Sergey Moskvin on 29.12.2020.
//

import SwiftUI

struct EditView: View {
    @Binding var scrumData: DailyScrum.Data
    @State private var newMember = ""
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $scrumData.title)
                HStack {
                    Slider(value: $scrumData.durationInMinutes, in: 5 ... 30, step: 1.0) {
                        Text("Duration")
                    }
                    .accessibilityLabel(Text("\(Int(scrumData.durationInMinutes)) minutes"))
                    Spacer()
                    Text("\(Int(scrumData.durationInMinutes)) minutes")
                        .accessibility(hidden: true)
                }
                ColorPicker("Color", selection: $scrumData.color)
                    .accessibilityLabel(Text("Color picker"))
            }
            Section(header: Text("Members")) {
                ForEach(scrumData.members, id: \.self) { member in
                    Text(member)
                }
                .onDelete { indices in
                    scrumData.members.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Member", text: $newMember)
                    Button(action: {
                        withAnimation {
                            scrumData.members.append(newMember)
                            newMember = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add member"))
                    }
                    .disabled(newMember.isEmpty)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(scrumData: .constant(DailyScrum.data[0].data))
    }
}
