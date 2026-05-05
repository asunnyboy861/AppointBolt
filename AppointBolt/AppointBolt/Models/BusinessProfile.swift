import Foundation
import SwiftData

@Model
final class BusinessProfile {
    var id: UUID
    var businessName: String
    var ownerName: String
    var phone: String
    var email: String
    var address: String
    var timezone: String
    var defaultReminderOffsets: [Int]
    var smsEnabled: Bool
    var emailEnabled: Bool
    var pushEnabled: Bool
    var confirmationTemplate: String
    var reminderTemplate: String
    var followUpTemplate: String
    var isOnboarded: Bool

    init(businessName: String, ownerName: String) {
        self.id = UUID()
        self.businessName = businessName
        self.ownerName = ownerName
        self.phone = ""
        self.email = ""
        self.address = ""
        self.timezone = TimeZone.current.identifier
        self.defaultReminderOffsets = [1440, 120]
        self.smsEnabled = true
        self.emailEnabled = true
        self.pushEnabled = true
        self.confirmationTemplate = "Hi {client_name}, your {service} appointment at {business_name} is confirmed for {date} at {time}. Reply C to confirm or R to reschedule."
        self.reminderTemplate = "Reminder: You have a {service} appointment at {business_name} tomorrow at {time}. Reply C to confirm or R to reschedule."
        self.followUpTemplate = "We missed you today! Your {service} appointment was at {time}. Would you like to reschedule? Reply R to pick a new time."
        self.isOnboarded = false
    }
}
