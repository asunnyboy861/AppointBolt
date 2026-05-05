import Foundation
import SwiftData

@Observable
final class AnalyticsService {
    var noShowRate: Double = 0
    var totalRevenue: Double = 0
    var lostRevenue: Double = 0
    var appointmentsThisMonth: Int = 0
    var noShowsThisMonth: Int = 0
    var savedByReminders: Double = 0

    func calculateMetrics(appointments: [Appointment]) {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!

        let thisMonth = appointments.filter { $0.date >= monthStart }
        appointmentsThisMonth = thisMonth.count
        noShowsThisMonth = thisMonth.filter { $0.status == .noShow }.count

        noShowRate = appointmentsThisMonth > 0
            ? Double(noShowsThisMonth) / Double(appointmentsThisMonth) * 100
            : 0

        totalRevenue = thisMonth
            .filter { $0.status == .completed }
            .reduce(0) { $0 + $1.price }

        lostRevenue = thisMonth
            .filter { $0.status == .noShow }
            .reduce(0) { $0 + $1.price }

        savedByReminders = thisMonth
            .filter { $0.status == .confirmed || $0.status == .completed }
            .reduce(0) { $0 + $1.price } * 0.3
    }

    func weeklyNoShowTrend(appointments: [Appointment]) -> [(week: String, rate: Double)] {
        let calendar = Calendar.current
        let now = Date()
        var trend: [(week: String, rate: Double)] = []

        for weekOffset in (0..<8).reversed() {
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now) else { continue }
            guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { continue }

            let weekAppts = appointments.filter { $0.date >= weekStart && $0.date < weekEnd }
            let weekNoShows = weekAppts.filter { $0.status == .noShow }.count
            let rate = weekAppts.isEmpty ? 0 : Double(weekNoShows) / Double(weekAppts.count) * 100

            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            trend.append((week: formatter.string(from: weekStart), rate: rate))
        }

        return trend
    }

    func topNoShowClients(clients: [Client]) -> [Client] {
        clients
            .filter { $0.noShowCount > 0 }
            .sorted { $0.noShowCount > $1.noShowCount }
            .prefix(5)
            .map { $0 }
    }
}
