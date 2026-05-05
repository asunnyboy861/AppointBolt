import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentPage = 0
    @State private var businessName = ""
    @State private var ownerName = ""
    @State private var businessPhone = ""

    private let pages = [
        OnboardingPage(
            icon: "bolt.fill",
            title: "Stop No-Shows",
            subtitle: "Automated SMS and push reminders ensure your clients never miss an appointment again."
        ),
        OnboardingPage(
            icon: "calendar.badge.clock",
            title: "Simple Scheduling",
            subtitle: "Create appointments in seconds. No complex setup, no steep learning curve."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Track Your Revenue",
            subtitle: "See exactly how much no-shows cost you and how much reminders save you."
        )
    ]

    var body: some View {
        if currentPage < pages.count {
            VStack(spacing: 32) {
                Spacer()

                Image(systemName: pages[currentPage].icon)
                    .font(.system(size: 64))
                    .foregroundStyle(Color.appPrimary)

                Text(pages[currentPage].title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(pages[currentPage].subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.appPrimary : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }

                Button(action: { withAnimation { currentPage += 1 } }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        } else {
            BusinessSetupView(
                businessName: $businessName,
                ownerName: $ownerName,
                businessPhone: $businessPhone,
                onComplete: {
                    let profile = BusinessProfile(businessName: businessName, ownerName: ownerName)
                    profile.phone = businessPhone
                    profile.isOnboarded = true
                    modelContext.insert(profile)
                }
            )
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
}

#Preview {
    OnboardingView()
        .modelContainer(for: [BusinessProfile.self], inMemory: true)
}
