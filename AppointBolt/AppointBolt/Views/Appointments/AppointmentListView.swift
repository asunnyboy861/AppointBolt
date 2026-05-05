import SwiftUI
import SwiftData

struct AppointmentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Appointment.date) private var appointments: [Appointment]
    @State private var showAddAppointment = false

    private var todayAppointments: [Appointment] {
        let today = Date()
        return appointments.filter { appointment in
            Calendar.current.isDate(appointment.date, inSameDayAs: today) &&
            appointment.status != .cancelled
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if todayAppointments.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.clock",
                        title: "No Appointments Today",
                        subtitle: "Tap + to add your first appointment"
                    )
                } else {
                    List(todayAppointments) { appointment in
                        NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                            AppointmentRowView(appointment: appointment)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Today")
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
    AppointmentListView()
        .modelContainer(for: [Appointment.self, Client.self, Reminder.self, BusinessProfile.self], inMemory: true)
}
