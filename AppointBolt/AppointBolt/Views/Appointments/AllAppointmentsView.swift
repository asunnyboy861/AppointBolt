import SwiftUI
import SwiftData

struct AllAppointmentsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Appointment.date) private var appointments: [Appointment]
    @State private var showAddAppointment = false
    @State private var filter: AppointmentFilter = .upcoming

    enum AppointmentFilter: String, CaseIterable {
        case upcoming = "Upcoming"
        case past = "Past"
        case noShow = "No-Show"
        case cancelled = "Cancelled"
    }

    private var filteredAppointments: [Appointment] {
        switch filter {
        case .upcoming:
            return appointments.filter { $0.date >= Date() && $0.status != .cancelled }
        case .past:
            return appointments.filter { $0.date < Date() && ($0.status == .completed || $0.status == .noShow) }
        case .noShow:
            return appointments.filter { $0.status == .noShow }
        case .cancelled:
            return appointments.filter { $0.status == .cancelled }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $filter) {
                    ForEach(AppointmentFilter.allCases, id: \.self) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if filteredAppointments.isEmpty {
                    EmptyStateView(
                        icon: "calendar",
                        title: "No \(filter.rawValue) Appointments",
                        subtitle: "Tap + to add one"
                    )
                } else {
                    List(filteredAppointments) { appointment in
                        NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                            AppointmentRowView(appointment: appointment)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddAppointment = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddAppointment) {
                AddAppointmentView()
            }
        }
    }
}

#Preview {
    AllAppointmentsView()
        .modelContainer(for: [Appointment.self, Client.self, Reminder.self, BusinessProfile.self], inMemory: true)
}
