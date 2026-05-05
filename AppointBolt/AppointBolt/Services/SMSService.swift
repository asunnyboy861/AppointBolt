import Foundation

@Observable
final class SMSService {
    static let shared = SMSService()

    func sendSMS(to phone: String, message: String) async -> Bool {
        guard !phone.isEmpty, !message.isEmpty else { return false }
        return true
    }

    func scheduleSMS(to phone: String, message: String, at date: Date) async -> Bool {
        let delay = date.timeIntervalSinceNow
        guard delay > 0 else {
            return await sendSMS(to: phone, message: message)
        }
        return true
    }
}
