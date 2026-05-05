import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @State private var selectedTier: Tier = .pro

    enum Tier {
        case pro
        case proPlus
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.appPrimary)
                    .padding(.top, 32)

                Text("Upgrade to Premium")
                    .font(.title)
                    .fontWeight(.bold)

                Text("One no-show saved pays for the entire year")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                tierCard(
                    tier: .pro,
                    title: "Pro",
                    monthlyPrice: "$9.99/mo",
                    yearlyPrice: "$79.99/yr",
                    features: [
                        "SMS reminders (50/month)",
                        "Email reminders",
                        "Custom message templates",
                        "Client confirm/cancel",
                        "Waitlist",
                        "Advanced reports"
                    ]
                )

                tierCard(
                    tier: .proPlus,
                    title: "Pro Plus",
                    monthlyPrice: "$19.99/mo",
                    yearlyPrice: "$159.99/yr",
                    features: [
                        "Everything in Pro",
                        "Unlimited SMS reminders",
                        "Team support (3 staff)",
                        "Online booking page",
                        "No-show follow-up",
                        "Data export (CSV)"
                    ]
                )

                Button(action: {
                    Task { await purchaseManager.restorePurchases() }
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundStyle(Color.appPrimary)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Subscription")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await purchaseManager.loadProducts()
        }
    }

    private func tierCard(tier: Tier, title: String, monthlyPrice: String, yearlyPrice: String, features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                if (tier == .pro && purchaseManager.isProUser) || (tier == .proPlus && purchaseManager.isProPlusUser) {
                    Text("Active")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appSuccess)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 16) {
                Text(monthlyPrice)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(yearlyPrice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appPrimary)
            }

            Divider()

            ForEach(features, id: \.self) { feature in
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(Color.appSuccess)
                    Text(feature)
                        .font(.subheadline)
                }
            }

            if !((tier == .pro && purchaseManager.isProUser) || (tier == .proPlus && purchaseManager.isProPlusUser)) {
                Button(action: {
                    purchaseTier(tier)
                }) {
                    Text("Subscribe")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedTier == tier ? Color.appPrimary : Color.clear, lineWidth: 2)
        )
        .onTapGesture { selectedTier = tier }
    }

    private func purchaseTier(_ tier: Tier) {
        Task {
            let productID: String
            switch tier {
            case .pro: productID = PurchaseManager.ProductID.proYearly.rawValue
            case .proPlus: productID = PurchaseManager.ProductID.proPlusYearly.rawValue
            }
            if let product = purchaseManager.products.first(where: { $0.id == productID }) {
                _ = await purchaseManager.purchase(product)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionView()
    }
}
