import Foundation
import SwiftData

@Observable
final class ReminderEngine {
    static let shared = ReminderEngine()

    private let notificationService = NotificationService.shared
    private let smsService = SMSService.shared

    func scheduleReminders(for appointment: Appointment, profile: BusinessProfile) async {
        let offsets = profile.defaultReminderOffsets

        for offsetMinutes in offsets {
            let reminderDate = appointment.date.addingTimeInterval(-Double(offsetMinutes) * 60)
            guard reminderDate > Date() else { continue }

            if profile.pushEnabled {
                await notificationService.scheduleNotification(for: appointment, offsetMinutes: offsetMinutes)
            }

            if profile.smsEnabled {
                let message = profile.reminderTemplate
                    .replacingOccurrences(of: "{client_name}", with: appointment.client?.fullName ?? "Client")
                    .replacingOccurrences(of: "{service}", with: appointment.serviceName)
                    .replacingOccurrences(of: "{business_name}", with: profile.businessName)
                    .replacingOccurrences(of: "{date}", with: appointment.date.formattedDate)
                    .replacingOccurrences(of: "{time}", with: appointment.date.formattedTime)

                await smsService.scheduleSMS(to: appointment.client?.phone ?? "", message: message, at: reminderDate)
            }
        }

        await scheduleConfirmationRequest(for: appointment, profile: profile)
    }

    func handleNoShow(appointment: Appointment, profile: BusinessProfile) {
        appointment.status = .noShow
        appointment.client?.noShowCount += 1

        let message = profile.followUpTemplate
            .replacingOccurrences(of: "{client_name}", with: appointment.client?.fullName ?? "Client")
            .replacingOccurrences(of: "{service}", with: appointment.serviceName)
            .replacingOccurrences(of: "{time}", with: appointment.date.formattedTime)

        Task {
            if profile.smsEnabled {
                await smsService.sendSMS(to: appointment.client?.phone ?? "", message: message)
            }
        }
    }

    private func scheduleConfirmationRequest(for appointment: Appointment, profile: BusinessProfile) async {
        let message = profile.confirmationTemplate
            .replacingOccurrences(of: "{client_name}", with: appointment.client?.fullName ?? "Client")
            .replacingOccurrences(of: "{service}", with: appointment.serviceName)
            .replacingOccurrences(of: "{business_name}", with: profile.businessName)
            .replacingOccurrences(of: "{date}", with: appointment.date.formattedDate)
            .replacingOccurrences(of: "{time}", with: appointment.date.formattedTime)

        if profile.smsEnabled {
            await smsService.scheduleSMS(to: appointment.client?.phone ?? "", message: message, at: Date().addingTimeInterval(300))
        }
    }
}
