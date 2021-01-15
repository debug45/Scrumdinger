/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation


/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.
class ScrumTimer: ObservableObject {
    /// A struct to keep track of meeting members during a meeting.
    struct Speaker: Identifiable {
        /// The member name.
        let name: String
        /// True if the member has completed their turn to speak.
        var isCompleted: Bool
        /// Id for Identifiable conformance.
        let id = UUID()
    }
    /// The name of the meeting member who is speaking.
    @Published var activeSpeaker = ""
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0
    /// The number of seconds until all members have had a turn to speak.
    @Published var secondsRemaining = 0
    /// All meeting members, listed in the order they will speak.
    @Published var speakers: [Speaker] = []

    /// The scrum meeting duration.
    var durationInMinutes: Int
    /// A closure that is executed when a new member begins speaking.
    var speakerChangedAction: (() -> Void)?

    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var durationInSeconds: Int { durationInMinutes * 60 }
    private var secondsPerSpeaker: Int {
        (durationInMinutes * 60) / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no members and zero duration.
     Use `startScrum()` to start the timer.
     
     - Parameters:
        - durationInMinutes: The meeting duration.
        -  members: The name of each member.
     */
    init(durationInMinutes: Int = 0, members: [String] = []) {
        self.durationInMinutes = durationInMinutes
        self.speakers = members.isEmpty ? [Speaker(name: "Player 1", isCompleted: false)] : members.map { Speaker(name: $0, isCompleted: false) }
        secondsRemaining = durationInSeconds
        activeSpeaker = speakerText
    }
    /// Start the timer.
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    /// Advance the timer to the next speaker.
    func skipSpeaker() {
        changeToSpeaker(at: speakerIndex + 1)
    }

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText

        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = durationInSeconds - secondsElapsed
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }

    private func update(secondsElapsed: Int) {
        secondsElapsedForSpeaker = secondsElapsed
        self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
        guard secondsElapsed <= secondsPerSpeaker else {
            return
        }
        secondsRemaining = max(durationInSeconds - self.secondsElapsed, 0)

        guard !timerStopped else { return }

        if secondsElapsedForSpeaker >= secondsPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }
    
    /**
     Reset the timer with a new meeting duration and new members.
     
     - Parameters:
         - durationInMinutes: The meeting duration.
         - members: The name of each member.
     */
    func reset(durationInMinutes: Int, members: [String]) {
        self.durationInMinutes = durationInMinutes
        self.speakers = members.isEmpty ? [Speaker(name: "Player 1", isCompleted: false)] : members.map { Speaker(name: $0, isCompleted: false) }
        secondsRemaining = durationInSeconds
        activeSpeaker = speakerText
    }
}

extension DailyScrum {
    /// A new `ScrumTimer` using the meeting duration and members in the `DailyScrum`.
    var timer: ScrumTimer {
        ScrumTimer(durationInMinutes: durationInMinutes, members: members)
    }
}
