import Foundation

@Observable
final class FeedbackService {
    var isSubmitting = false
    var submissionResult: Result<Void, Error>?

    private let backendURL: String

    init(backendURL: String) {
        self.backendURL = backendURL
    }

    func submitFeedback(topic: String?, name: String?, email: String, message: String) async {
        guard !email.isEmpty, !message.isEmpty else { return }

        await MainActor.run { isSubmitting = true }

        let body = FeedbackRequest(topic: topic, name: name, email: email, message: message)

        do {
            guard let url = URL(string: backendURL) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                await MainActor.run { submissionResult = .success(()) }
            } else {
                await MainActor.run { submissionResult = .failure(FeedbackError.serverError) }
            }
        } catch {
            await MainActor.run { submissionResult = .failure(error) }
        }

        await MainActor.run { isSubmitting = false }
    }

    enum FeedbackError: LocalizedError {
        case serverError
        var errorDescription: String? { "Server error. Please try again." }
    }
}

struct FeedbackRequest: Codable {
    let topic: String?
    let name: String?
    let email: String
    let message: String
}
