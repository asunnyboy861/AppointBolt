import SwiftUI
import SwiftData

struct AddClientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var notes = ""

    var onClientCreated: ((Client) -> Void)?

    init(onClientCreated: ((Client) -> Void)? = nil) {
        self.onClientCreated = onClientCreated
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section("Contact") {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveClient()
                    }
                    .fontWeight(.semibold)
                    .disabled(firstName.isEmpty || phone.isEmpty)
                }
            }
        }
    }

    private func saveClient() {
        let client = Client(firstName: firstName, lastName: lastName, phone: phone, email: email)
        client.notes = notes
        modelContext.insert(client)
        onClientCreated?(client)
        dismiss()
    }
}

#Preview {
    AddClientView()
        .modelContainer(for: [Client.self], inMemory: true)
}
