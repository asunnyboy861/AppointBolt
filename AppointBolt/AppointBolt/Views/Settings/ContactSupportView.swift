import SwiftUI

struct ContactSupportView: View {
    @State private var topic = ""
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var feedbackService = FeedbackService(backendURL: "https://feedback-board.iocompile67692.workers.dev")
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Billing", "Account"]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    Text("Select a topic").tag("")
                    ForEach(topics, id: \.self) { Text($0).tag($0) }
                }
            }

            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email (required)", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Message") {
                TextField("How can we help?", text: $message, axis: .vertical)
                    .lineLimit(5...10)
            }

            Section {
                Button(action: submitFeedback) {
                    if feedbackService.isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(email.isEmpty || message.isEmpty ? Color.gray : Color.appPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || feedbackService.isSubmitting)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    message = ""
                    email = ""
                    name = ""
                    topic = ""
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        Task {
            await feedbackService.submitFeedback(topic: topic.isEmpty ? nil : topic, name: name.isEmpty ? nil : name, email: email, message: message)
            await MainActor.run {
                switch feedbackService.submissionResult {
                case .success:
                    alertMessage = "Message sent successfully! We'll get back to you soon."
                case .failure:
                    alertMessage = "Failed to send. Please try again or email us directly."
                case nil:
                    alertMessage = "Something went wrong. Please try again."
                }
                showAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContactSupportView()
    }
}
