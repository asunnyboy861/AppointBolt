import SwiftUI
import SwiftData

@main
struct AppointBoltApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Appointment.self, Client.self, Reminder.self, BusinessProfile.self])
    }
}
