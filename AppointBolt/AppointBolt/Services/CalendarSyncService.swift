import Foundation
import EventKit

@Observable
final class CalendarSyncService {
    static let shared = CalendarSyncService()
    private let eventStore = EKEventStore()
    var isAuthorized = false

    func requestAccess() async -> Bool {
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            await MainActor.run { isAuthorized = granted }
            return granted
        } catch {
            return false
        }
    }

    func syncAppointment(_ appointment: Appointment) async -> String? {
        guard isAuthorized else { return nil }

        let event = EKEvent(eventStore: eventStore)
        event.title = "\(appointment.serviceName) - \(appointment.client?.fullName ?? "Client")"
        event.startDate = appointment.date
        event.endDate = appointment.date.addingTimeInterval(appointment.duration)
        event.notes = appointment.notes
        event.url = URL(string: "appointbolt://appointment/\(appointment.id.uuidString)")

        let alarms = [
            EKAlarm(relativeOffset: -86400),
            EKAlarm(relativeOffset: -7200)
        ]
        event.alarms = alarms
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            return event.eventIdentifier
        } catch {
            print("Failed to sync appointment: \(error)")
            return nil
        }
    }

    func removeEvent(eventIdentifier: String) async {
        guard let event = eventStore.event(withIdentifier: eventIdentifier) else { return }
        do {
            try eventStore.remove(event, span: .thisEvent)
        } catch {
            print("Failed to remove event: \(error)")
        }
    }
}
