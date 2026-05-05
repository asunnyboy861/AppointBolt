import Foundation
import SwiftData

@Model
final class Client {
    var id: UUID
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    var notes: String
    var noShowCount: Int
    var totalAppointments: Int
    var createdAt: Date

    var appointments: [Appointment]

    var fullName: String { "\(firstName) \(lastName)" }

    init(firstName: String, lastName: String, phone: String, email: String = "") {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.notes = ""
        self.noShowCount = 0
        self.totalAppointments = 0
        self.createdAt = Date()
        self.appointments = []
    }
}
