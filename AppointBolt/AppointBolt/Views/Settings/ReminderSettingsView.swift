import SwiftUI
import SwiftData

struct ReminderSettingsView: View {
    @Bindable var profile: BusinessProfile
    @State private var showConfirmation = false
    @State private var showReminder = false
    @State private var showFollowUp = false

    var body: some View {
        Form {
            Section("Reminder Channels") {
                Toggle("Push Notifications", isOn: $profile.pushEnabled)
                Toggle("SMS Reminders", isOn: $profile.smsEnabled)
                Toggle("Email Reminders", isOn: $profile.emailEnabled)
            }

            Section("Reminder Timing") {
                ForEach(profile.defaultReminderOffsets, id: \.self) { offset in
                    HStack {
                        Text(formatOffset(offset))
                        Spacer()
                        Button(role: .destructive) {
                            profile.defaultReminderOffsets.removeAll { $0 == offset }
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundStyle(Color.appDanger)
                        }
                    }
                }

                Menu("Add Reminder Time") {
                    Button("15 minutes before") { profile.defaultReminderOffsets.append(15) }
                    Button("30 minutes before") { profile.defaultReminderOffsets.append(30) }
                    Button("1 hour before") { profile.defaultReminderOffsets.append(60) }
                    Button("2 hours before") { profile.defaultReminderOffsets.append(120) }
                    Button("1 day before") { profile.defaultReminderOffsets.append(1440) }
                    Button("2 days before") { profile.defaultReminderOffsets.append(2880) }
                }
            }

            Section {
                Button("Confirmation Template") { showConfirmation = true }
                Button("Reminder Template") { showReminder = true }
                Button("Follow-Up Template") { showFollowUp = true }
            } header: {
                Text("Message Templates")
            } footer: {
                Text("Available variables: {client_name}, {service}, {business_name}, {date}, {time}")
            }
        }
        .navigationTitle("Reminder Settings")
        .sheet(isPresented: $showConfirmation) {
            NavigationStack {
                TemplateEditorView(title: "Confirmation", text: $profile.confirmationTemplate)
            }
        }
        .sheet(isPresented: $showReminder) {
            NavigationStack {
                TemplateEditorView(title: "Reminder", text: $profile.reminderTemplate)
            }
        }
        .sheet(isPresented: $showFollowUp) {
            NavigationStack {
                TemplateEditorView(title: "Follow-Up", text: $profile.followUpTemplate)
            }
        }
    }

    private func formatOffset(_ minutes: Int) -> String {
        if minutes >= 1440 { return "\(minutes / 1440) day(s) before" }
        if minutes >= 60 { return "\(minutes / 60) hour(s) before" }
        return "\(minutes) min before"
    }
}

struct TemplateEditorView: View {
    let title: String
    @Binding var text: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField("Template", text: $text, axis: .vertical)
                    .lineLimit(5...10)
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Available variables:")
                    Text("{client_name} - Client's full name")
                    Text("{service} - Service name")
                    Text("{business_name} - Your business name")
                    Text("{date} - Appointment date")
                    Text("{time} - Appointment time")
                }
                .font(.caption2)
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReminderSettingsView(profile: BusinessProfile(businessName: "Test", ownerName: "Test"))
    }
    .modelContainer(for: [BusinessProfile.self], inMemory: true)
}
