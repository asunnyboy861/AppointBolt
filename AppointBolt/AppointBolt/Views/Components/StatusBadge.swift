import SwiftUI

struct StatusBadge: View {
    let status: Appointment.AppointmentStatus

    private var color: Color {
        switch status {
        case .scheduled: return Color.appPrimary
        case .confirmed: return Color.appSuccess
        case .cancelled: return Color.appDanger
        case .noShow: return Color.appDanger
        case .completed: return Color.appSuccess
        case .rescheduled: return Color.appWarning
        }
    }

    private var label: String {
        switch status {
        case .scheduled: return "Scheduled"
        case .confirmed: return "Confirmed"
        case .cancelled: return "Cancelled"
        case .noShow: return "No-Show"
        case .completed: return "Completed"
        case .rescheduled: return "Rescheduled"
        }
    }

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        StatusBadge(status: .scheduled)
        StatusBadge(status: .confirmed)
        StatusBadge(status: .noShow)
        StatusBadge(status: .completed)
    }
}
