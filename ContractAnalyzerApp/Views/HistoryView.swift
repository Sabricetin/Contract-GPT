import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFavoritesOnly = false
    @State private var searchText = ""
    
    var filteredContracts: [Contract.AnalyzedContract] {
        var contracts = viewModel.contracts
        if showingFavoritesOnly {
            contracts = contracts.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            contracts = contracts.filter { contract in
                contract.fileName.localizedCaseInsensitiveContains(searchText)
            }
        }
        return contracts
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredContracts) { contract in
                    NavigationLink(destination: ContractDetailView(contract: contract)) {
                        ContractHistoryRow(contract: contract)
                    }
                }
            }
            .navigationTitle("Analizler")
            .searchable(text: $searchText, prompt: "Sözleşme Ara")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isOn: $showingFavoritesOnly) {
                        Image(systemName: "star.fill")
                    }
                }
            }
        }
    }
}

struct ContractHistoryRow: View {
    let contract: Contract.AnalyzedContract
    @ObservedObject private var historyManager = HistoryManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contract.fileName)
                    .font(.headline)
                Text(contract.analyzedDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                historyManager.toggleFavorite(contract)
            }) {
                Image(systemName: contract.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
} 