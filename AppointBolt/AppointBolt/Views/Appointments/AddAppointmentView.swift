import SwiftUI
import SwiftData

struct AddAppointmentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var clients: [Client]
    @Query private var profiles: [BusinessProfile]

    @State private var serviceName = ""
    @State private var priceText = ""
    @State private var selectedDate = Date()
    @State private var durationMinutes = 60
    @State private var notes = ""
    @State private var selectedClient: Client?
    @State private var showAddClient = false
    @State private var searchText = ""

    private var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchText) ||
            $0.phone.contains(searchText)
        }
    }

    private let durations = [15, 30, 45, 60, 90, 120]

    var body: some View {
        NavigationStack {
            Form {
                Section("Client") {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search or add client...", text: $searchText)
                    }

                    if selectedClient != nil {
                        HStack {
                            Text(selectedClient?.fullName ?? "")
                            Spacer()
                            Button("Change") {
                                selectedClient = nil
                            }
                            .font(.caption)
                        }
                    } else {
                        ForEach(filteredClients.prefix(5)) { client in
                            Button(action: { selectedClient = client }) {
                                HStack {
                                    Text(client.fullName)
                                    Spacer()
                                    Text(client.phone)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        Button(action: { showAddClient = true }) {
                            Label("Add New Client", systemImage: "plus.circle")
                        }
                    }
                }

                Section("Service") {
                    TextField("Service Name", text: $serviceName)
                    HStack {
                        Text("$")
                        TextField("Price", text: $priceText)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Date & Time") {
                    DatePicker("Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    DatePicker("Time", selection: $selectedDate, displayedComponents: .hourAndMinute)

                    Picker("Duration", selection: $durationMinutes) {
                        ForEach(durations, id: \.self) { d in
                            Text(d >= 60 ? "\(d/60)h\(d % 60 > 0 ? " \(d%60)m" : "")" : "\(d)m").tag(d)
                        }
                    }
                }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAppointment()
                    }
                    .fontWeight(.semibold)
                    .disabled(serviceName.isEmpty)
                }
            }
            .sheet(isPresented: $showAddClient) {
                AddClientView { newClient in
                    selectedClient = newClient
                }
            }
        }
    }

    private func saveAppointment() {
        let appointment = Appointment(
            title: serviceName,
            date: selectedDate,
            duration: Double(durationMinutes) * 60,
            serviceName: serviceName,
            price: Double(priceText) ?? 0
        )
        appointment.client = selectedClient
        appointment.notes = notes
        modelContext.insert(appointment)

        if let profile = profiles.first {
            Task {
                await ReminderEngine.shared.scheduleReminders(for: appointment, profile: profile)
                let eventID = await CalendarSyncService.shared.syncAppointment(appointment)
                appointment.calendarEventID = eventID
            }
        }

        dismiss()
    }
}

#Preview {
    AddAppointmentView()
        .modelContainer(for: [Appointment.self, Client.self, BusinessProfile.self], inMemory: true)
}
