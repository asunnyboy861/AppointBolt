import SwiftUI
import SwiftData

struct BusinessProfileView: View {
    @Bindable var profile: BusinessProfile

    var body: some View {
        Form {
            Section("Business Info") {
                TextField("Business Name", text: $profile.businessName)
                TextField("Owner Name", text: $profile.ownerName)
                TextField("Phone", text: $profile.phone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $profile.email)
                    .keyboardType(.emailAddress)
                TextField("Address", text: $profile.address, axis: .vertical)
                    .lineLimit(2...4)
            }

            Section("Timezone") {
                Text(profile.timezone)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Business Profile")
    }
}

#Preview {
    NavigationStack {
        BusinessProfileView(profile: BusinessProfile(businessName: "Test", ownerName: "Test"))
    }
    .modelContainer(for: [BusinessProfile.self], inMemory: true)
}
