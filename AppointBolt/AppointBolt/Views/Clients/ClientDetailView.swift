import SwiftUI
import SwiftData

struct ClientDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var client: Client
    @State private var showDeleteConfirmation = false

    private var upcomingAppointments: [Appointment] {
        client.appointments
            .filter { $0.date >= Date() && $0.status != .cancelled }
            .sorted { $0.date < $1.date }
    }

    private var pastAppointments: [Appointment] {
        client.appointments
            .filter { $0.date < Date() || $0.status == .completed || $0.status == .noShow }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            Section("Contact") {
                LabeledContent("Phone", value: client.phone)
                if !client.email.isEmpty {
                    LabeledContent("Email", value: client.email)
                }
            }

            Section("Stats") {
                LabeledContent("Total Appointments", value: "\(client.totalAppointments)")
                LabeledContent("No-Shows", value: "\(client.noShowCount)")
                if client.noShowCount > 0 && client.totalAppointments > 0 {
                    LabeledContent("No-Show Rate", value: String(format: "%.0f%%", Double(client.noShowCount) / Double(client.totalAppointments) * 100))
                }
            }

            if !upcomingAppointments.isEmpty {
                Section("Upcoming") {
                    ForEach(upcomingAppointments) { appointment in
                        NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                            VStack(alignment: .leading) {
                                Text(appointment.serviceName)
                                    .font(.headline)
                                Text("\(appointment.date.formattedDate) at \(appointment.date.formattedTime)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            if !pastAppointments.isEmpty {
                Section("Past") {
                    ForEach(pastAppointments.prefix(10)) { appointment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(appointment.serviceName)
                                    .font(.subheadline)
                                Text(appointment.date.formattedDate)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            StatusBadge(status: appointment.status)
                        }
                    }
                }
            }

            if !client.notes.isEmpty {
                Section("Notes") {
                    Text(client.notes)
                }
            }

            Section {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Client", systemImage: "trash")
                }
            }
        }
        .navigationTitle(client.fullName)
        .alert("Delete Client?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                modelContext.delete(client)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClientDetailView(client: Client(firstName: "John", lastName: "Doe", phone: "555-1234"))
    }
    .modelContainer(for: [Client.self, Appointment.self], inMemory: true)
}
