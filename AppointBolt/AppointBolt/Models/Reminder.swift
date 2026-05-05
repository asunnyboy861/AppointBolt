import Foundation
import SwiftData

@Model
final class Reminder {
    var id: UUID
    var typeRaw: String
    var channelRaw: String
    var statusRaw: String
    var offsetMinutes: Int
    var message: String
    var scheduledAt: Date
    var sentAt: Date?

    var appointment: Appointment?

    var type: ReminderType {
        get { ReminderType(rawValue: typeRaw) ?? .reminder }
        set { typeRaw = newValue.rawValue }
    }

    var channel: ReminderChannel {
        get { ReminderChannel(rawValue: channelRaw) ?? .push }
        set { channelRaw = newValue.rawValue }
    }

    var status: ReminderStatus {
        get { ReminderStatus(rawValue: statusRaw) ?? .pending }
        set { statusRaw = newValue.rawValue }
    }

    enum ReminderType: String, Codable {
        case confirmation
        case reminder
        case followUp
        case noShowFollowUp
    }

    enum ReminderChannel: String, Codable {
        case sms
        case email
        case push
    }

    enum ReminderStatus: String, Codable {
        case pending
        case scheduled
        case sent
        case failed
        case cancelled
    }

    init(type: ReminderType, channel: ReminderChannel, offsetMinutes: Int, message: String) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.channelRaw = channel.rawValue
        self.statusRaw = ReminderStatus.pending.rawValue
        self.offsetMinutes = offsetMinutes
        self.message = message
        self.scheduledAt = Date()
        self.sentAt = nil
    }
}
