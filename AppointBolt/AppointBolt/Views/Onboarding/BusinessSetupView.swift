import SwiftUI

struct BusinessSetupView: View {
    @Binding var businessName: String
    @Binding var ownerName: String
    @Binding var businessPhone: String
    let onComplete: () -> Void

    @State private var notificationGranted = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Set Up Your Business")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This takes 30 seconds. You can always change it later.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Form {
                Section("Business Info") {
                    TextField("Business Name", text: $businessName)
                    TextField("Your Name", text: $ownerName)
                    TextField("Business Phone", text: $businessPhone)
                        .keyboardType(.phonePad)
                }

                Section("Notifications") {
                    HStack {
                        Image(systemName: notificationGranted ? "checkmark.circle.fill" : "exclamationmark.circle")
                            .foregroundStyle(notificationGranted ? Color.appSuccess : Color.appWarning)
                        Text(notificationGranted ? "Notifications Enabled" : "Enable Notifications")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Task {
                            notificationGranted = await NotificationService.shared.requestPermission()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)

            Button(action: {
                guard !businessName.isEmpty, !ownerName.isEmpty else { return }
                onComplete()
            }) {
                Text("Start Using AppointBolt")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(businessName.isEmpty || ownerName.isEmpty ? Color.gray : Color.appPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(businessName.isEmpty || ownerName.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .padding(.top, 32)
    }
}

#Preview {
    BusinessSetupView(
        businessName: .constant(""),
        ownerName: .constant(""),
        businessPhone: .constant(""),
        onComplete: {}
    )
}
