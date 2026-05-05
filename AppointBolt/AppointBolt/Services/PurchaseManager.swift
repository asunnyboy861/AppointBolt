import Foundation
import StoreKit

@Observable
final class PurchaseManager {
    static let shared = PurchaseManager()

    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isProUser = false
    var isProPlusUser = false
    var isLoading = false

    private var transactionListener: Task<Void, Never>?

    enum ProductID: String {
        case proMonthly = "com.zzoutuo.AppointBolt.pro.monthly"
        case proYearly = "com.zzoutuo.AppointBolt.pro.yearly"
        case proPlusMonthly = "com.zzoutuo.AppointBolt.proplus.monthly"
        case proPlusYearly = "com.zzoutuo.AppointBolt.proplus.yearly"
    }

    init() {
        transactionListener = listenForTransactions()
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        await MainActor.run { isLoading = true }
        do {
            let storeProducts = try await Product.products(for: [
                ProductID.proMonthly.rawValue,
                ProductID.proYearly.rawValue,
                ProductID.proPlusMonthly.rawValue,
                ProductID.proPlusYearly.rawValue
            ])
            await MainActor.run {
                products = storeProducts
                isLoading = false
            }
        } catch {
            await MainActor.run { isLoading = false }
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchaseStatus()
                await transaction.finish()
                return true
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {}
    }

    func updatePurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                await MainActor.run {
                    purchasedProductIDs.insert(transaction.productID)
                    updateTierStatus()
                }
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self?.updatePurchaseStatus()
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified(_ result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let transaction):
            return transaction
        }
    }

    private func updateTierStatus() {
        isProUser = purchasedProductIDs.contains(ProductID.proMonthly.rawValue) ||
                    purchasedProductIDs.contains(ProductID.proYearly.rawValue) ||
                    isProPlusUser
        isProPlusUser = purchasedProductIDs.contains(ProductID.proPlusMonthly.rawValue) ||
                        purchasedProductIDs.contains(ProductID.proPlusYearly.rawValue)
    }

    enum StoreError: Error {
        case failedVerification
    }
}
