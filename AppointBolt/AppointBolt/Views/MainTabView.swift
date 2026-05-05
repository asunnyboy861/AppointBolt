import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AppointmentListView()
                .tabItem {
                    Label("Today", systemImage: "calendar.badge.clock")
                }
                .tag(0)

            AllAppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "calendar")
                }
                .tag(1)

            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "person.2")
                }
                .tag(2)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(4)
        }
        .tint(Color.appPrimary)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Appointment.self, Client.self, Reminder.self, BusinessProfile.self], inMemory: true)
}
