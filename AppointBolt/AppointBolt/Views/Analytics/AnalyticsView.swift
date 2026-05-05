import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query private var appointments: [Appointment]
    @Query private var clients: [Client]
    @State private var noShowRate: Double = 0
    @State private var noShowsThisMonth: Int = 0
    @State private var appointmentsThisMonth: Int = 0
    @State private var totalRevenue: Double = 0
    @State private var lostRevenue: Double = 0
    @State private var savedByReminders: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    noShowRateCard
                    revenueImpactCard
                    topNoShowClientsCard
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .onAppear { calculateMetrics() }
            .onChange(of: appointments.count) { calculateMetrics() }
        }
    }

    private func calculateMetrics() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!

        let thisMonth = appointments.filter { $0.date >= startOfMonth }
        appointmentsThisMonth = thisMonth.count
        noShowsThisMonth = thisMonth.filter { $0.status == .noShow }.count
        noShowRate = appointmentsThisMonth > 0 ? Double(noShowsThisMonth) / Double(appointmentsThisMonth) * 100 : 0

        let completed = appointments.filter { $0.status == .completed }
        let noShows = appointments.filter { $0.status == .noShow }
        totalRevenue = completed.reduce(0) { $0 + $1.price }
        lostRevenue = noShows.reduce(0) { $0 + $1.price }
        savedByReminders = lostRevenue * 0.6
    }

    private var noShowRateCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No-Show Rate")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(String(format: "%.1f%%", noShowRate))
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(noShowRate > 20 ? Color.appDanger : noShowRate > 10 ? Color.appWarning : Color.appSuccess)

            Text("\(noShowsThisMonth) no-shows out of \(appointmentsThisMonth) appointments this month")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(value: noShowRate, total: 50)
                .tint(noShowRate > 20 ? Color.appDanger : noShowRate > 10 ? Color.appWarning : Color.appSuccess)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    private var revenueImpactCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Revenue Impact")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Earned")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.0f", totalRevenue))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appSuccess)
                }

                VStack(alignment: .leading) {
                    Text("Lost to No-Shows")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.0f", lostRevenue))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appDanger)
                }

                VStack(alignment: .leading) {
                    Text("Saved by Reminders")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.0f", savedByReminders))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appPrimary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    private var topNoShowClientsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top No-Show Clients")
                .font(.headline)
                .foregroundStyle(.secondary)

            let topClients = clients.filter { $0.noShowCount > 0 }.sorted { $0.noShowCount > $1.noShowCount }
            if topClients.isEmpty {
                Text("No no-shows recorded yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(topClients.prefix(5)) { client in
                    HStack {
                        Text(client.fullName)
                            .font(.subheadline)
                        Spacer()
                        Text("\(client.noShowCount) no-show\(client.noShowCount > 1 ? "s" : "")")
                            .font(.caption)
                            .foregroundStyle(Color.appDanger)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: [Appointment.self, Client.self], inMemory: true)
}
