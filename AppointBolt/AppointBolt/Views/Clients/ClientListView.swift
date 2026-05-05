import SwiftUI
import SwiftData

struct ClientListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Client.firstName) private var clients: [Client]
    @State private var showAddClient = false
    @State private var searchText = ""

    private var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchText) ||
            $0.phone.contains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredClients.isEmpty {
                    EmptyStateView(
                        icon: "person.2",
                        title: "No Clients Yet",
                        subtitle: "Tap + to add your first client"
                    )
                } else {
                    List(filteredClients) { client in
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.appPrimary.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Text(String(client.firstName.prefix(1)))
                                            .font(.headline)
                                            .foregroundStyle(Color.appPrimary)
                                    }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(client.fullName)
                                        .font(.headline)
                                    Text(client.phone)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if client.noShowCount > 0 {
                                    Text("\(client.noShowCount) no-show\(client.noShowCount > 1 ? "s" : "")")
                                        .font(.caption2)
                                        .foregroundStyle(Color.appDanger)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.appDanger.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Clients")
            .searchable(text: $searchText, prompt: "Search clients")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddClient = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddClient) {
                AddClientView()
            }
        }
    }
}

#Preview {
    ClientListView()
        .modelContainer(for: [Client.self], inMemory: true)
}
