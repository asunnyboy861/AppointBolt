import Foundation
import SwiftData

@Model
final class Appointment {
    var id: UUID
    var title: String
    var date: Date
    var duration: TimeInterval
    var statusRaw: String
    var notes: String
    var createdAt: Date
    var serviceName: String
    var price: Double
    var calendarEventID: String?

    var reminders: [Reminder]

    var client: Client?

    var status: AppointmentStatus {
        get { AppointmentStatus(rawValue: statusRaw) ?? .scheduled }
        set { statusRaw = newValue.rawValue }
    }

    enum AppointmentStatus: String, Codable, CaseIterable {
        case scheduled
        case confirmed
        case cancelled
        case noShow
        case completed
        case rescheduled
    }

    init(title: String, date: Date, duration: TimeInterval, serviceName: String, price: Double) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.duration = duration
        self.statusRaw = AppointmentStatus.scheduled.rawValue
        self.notes = ""
        self.createdAt = Date()
        self.serviceName = serviceName
        self.price = price
        self.calendarEventID = nil
        self.reminders = []
    }
}
