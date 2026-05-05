import SwiftUI

struct AppointmentRowView: View {
    let appointment: Appointment

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .center, spacing: 2) {
                Text(appointment.date.formattedTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.client?.fullName ?? "No Client")
                    .font(.headline)
                Text(appointment.serviceName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            StatusBadge(status: appointment.status)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        AppointmentRowView(appointment: {
            let a = Appointment(title: "Test", date: Date(), duration: 3600, serviceName: "Haircut", price: 80)
            return a
        }())
    }
}
