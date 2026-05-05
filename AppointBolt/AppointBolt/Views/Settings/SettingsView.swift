import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var profiles: [BusinessProfile]
    @State private var purchaseManager = PurchaseManager.shared

    private var profile: BusinessProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            List {
                Section("Business") {
                    if let profile = profile {
                        NavigationLink(destination: BusinessProfileView(profile: profile)) {
                            Label("Business Profile", systemImage: "building.2")
                        }
                    }
                }

                Section("Reminders") {
                    if let profile = profile {
                        NavigationLink(destination: ReminderSettingsView(profile: profile)) {
                            Label("Reminder Settings", systemImage: "bell.badge")
                        }
                    }
                    NavigationLink(destination: CalendarSyncSettingsView()) {
                        Label("Calendar Sync", systemImage: "calendar.badge.plus")
                    }
                }

                Section("Subscription") {
                    NavigationLink(destination: SubscriptionView()) {
                        Label(
                            purchaseManager.isProPlusUser ? "Pro Plus Active" :
                            purchaseManager.isProUser ? "Pro Active" : "Upgrade to Pro",
                            systemImage: purchaseManager.isProPlusUser ? "crown.fill" :
                                         purchaseManager.isProUser ? "star.fill" : "arrow.up.circle"
                        )
                    }
                }

                Section("Support") {
                    NavigationLink(destination: ContactSupportView()) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                    Link(destination: URL(string: "https://asunnyboy861.github.io/AppointBolt/support.html")!) {
                        Label("Support Page", systemImage: "questionmark.circle")
                    }
                    Link(destination: URL(string: "https://asunnyboy861.github.io/AppointBolt/privacy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    Link(destination: URL(string: "https://asunnyboy861.github.io/AppointBolt/terms.html")!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                Section {
                    Button(action: {
                        Task { await purchaseManager.restorePurchases() }
                    }) {
                        Label("Restore Purchases", systemImage: "arrow.uturn.backward")
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct CalendarSyncSettingsView: View {
    @State private var isCalendarAuthorized = false

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: isCalendarAuthorized ? "checkmark.circle.fill" : "exclamationmark.circle")
                        .foregroundStyle(isCalendarAuthorized ? Color.appSuccess : Color.appWarning)
                    Text(isCalendarAuthorized ? "Calendar Access Granted" : "Grant Calendar Access")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        isCalendarAuthorized = await CalendarSyncService.shared.requestAccess()
                    }
                }
            } footer: {
                Text("AppointBolt syncs your appointments with Apple Calendar. Google Calendar events connected through Apple Calendar will also sync.")
            }
        }
        .navigationTitle("Calendar Sync")
        .onAppear {
            isCalendarAuthorized = CalendarSyncService.shared.isAuthorized
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [BusinessProfile.self], inMemory: true)
}
