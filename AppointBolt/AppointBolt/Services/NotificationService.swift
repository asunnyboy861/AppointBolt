import Foundation
import UserNotifications

@Observable
final class NotificationService {
    static let shared = NotificationService()
    private let notificationCenter = UNUserNotificationCenter.current()

    var isAuthorized = false

    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run { isAuthorized = granted }
            return granted
        } catch {
            return false
        }
    }

    func scheduleNotification(for appointment: Appointment, offsetMinutes: Int) async {
        let reminderDate = appointment.date.addingTimeInterval(-Double(offsetMinutes) * 60)
        guard reminderDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Appointment Reminder"
        content.body = "\(appointment.client?.fullName ?? "Client") - \(appointment.serviceName) in \(formatOffset(offsetMinutes))"
        content.sound = .default
        content.categoryIdentifier = "APPOINTMENT_REMINDER"
        content.userInfo = [
            "appointmentId": appointment.id.uuidString,
            "action": "reminder"
        ]

        let confirmAction = UNNotificationAction(identifier: "CONFIRM", title: "Confirm", options: [])
        let rescheduleAction = UNNotificationAction(identifier: "RESCHEDULE", title: "Reschedule", options: [])
        let cancelAction = UNNotificationAction(identifier: "CANCEL_APPOINTMENT", title: "Cancel", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: "APPOINTMENT_REMINDER",
            actions: [confirmAction, rescheduleAction, cancelAction],
            intentIdentifiers: []
        )
        notificationCenter.setNotificationCategories([category])

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: "reminder-\(appointment.id.uuidString)-\(offsetMinutes)",
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    func cancelNotifications(for appointmentId: UUID) {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    private func formatOffset(_ minutes: Int) -> String {
        if minutes >= 1440 { return "\(minutes / 1440) day(s)" }
        if minutes >= 60 { return "\(minutes / 60) hour(s)" }
        return "\(minutes) min"
    }
}
