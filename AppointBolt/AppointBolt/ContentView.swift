import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<BusinessProfile> { $0.isOnboarded == true })
    private var profiles: [BusinessProfile]
    @State private var showOnboarding = false

    var body: some View {
        Group {
            if profiles.isEmpty {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            if profiles.isEmpty {
                showOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Appointment.self, Client.self, Reminder.self, BusinessProfile.self], inMemory: true)
}
