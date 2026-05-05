import SwiftUI
import SwiftData

struct AppointmentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var appointment: Appointment
    @Query private var profiles: [BusinessProfile]

    @State private var showReschedule = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        List {
            Section("Client") {
                if let client = appointment.client {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(client.fullName)
                                .font(.headline)
                            Text(client.phone)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        StatusBadge(status: appointment.status)
                    }
                } else {
                    Text("No client assigned")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Appointment") {
                LabeledContent("Service", value: appointment.serviceName)
                LabeledContent("Date", value: appointment.date.formattedDate)
                LabeledContent("Time", value: appointment.date.formattedTime)
                LabeledContent("Duration", value: formatDuration(appointment.duration))
                LabeledContent("Price", value: String(format: "$%.2f", appointment.price))
            }

            if !appointment.notes.isEmpty {
                Section("Notes") {
                    Text(appointment.notes)
                }
            }

            Section("Actions") {
                if appointment.status == .scheduled {
                    Button(action: { appointment.status = .confirmed }) {
                        Label("Mark Confirmed", systemImage: "checkmark.circle")
                    }
                    .tint(Color.appSuccess)
                }

                if appointment.status != .cancelled && appointment.status != .completed {
                    Button(action: { appointment.status = .cancelled }) {
                        Label("Cancel Appointment", systemImage: "xmark.circle")
                    }
                    .tint(Color.appDanger)
                }

                if appointment.status == .scheduled || appointment.status == .confirmed {
                    Button(action: { appointment.status = .noShow }) {
                        Label("Mark No-Show", systemImage: "exclamationmark.triangle")
                    }
                    .tint(Color.appDanger)
                }

                if appointment.status == .noShow {
                    Button(action: {
                        appointment.status = .completed
                        appointment.client?.noShowCount = max(0, (appointment.client?.noShowCount ?? 1) - 1)
                    }) {
                        Label("Undo No-Show", systemImage: "arrow.uturn.backward")
                    }
                    .tint(Color.appPrimary)
                }

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Appointment", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Appointment Details")
        .alert("Delete Appointment?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                modelContext.delete(appointment)
            }
        }
    }

    private func formatDuration(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        if minutes >= 60 {
            let hours = minutes / 60
            let remaining = minutes % 60
            return remaining > 0 ? "\(hours)h \(remaining)m" : "\(hours)h"
        }
        return "\(minutes)m"
    }
}

#Preview {
    NavigationStack {
        AppointmentDetailView(appointment: Appointment(title: "Test", date: Date(), duration: 3600, serviceName: "Haircut", price: 80))
    }
    .modelContainer(for: [Appointment.self, Client.self, BusinessProfile.self], inMemory: true)
}
