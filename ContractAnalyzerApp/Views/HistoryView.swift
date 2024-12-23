import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFavoritesOnly = false
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var contractToDelete: Contract.AnalyzedContract?
    
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
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            contractToDelete = contract
                            showingDeleteAlert = true
                            HistoryManager.shared.tempDeleteContract(contract)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
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
            .alert("Analizi Sil", isPresented: $showingDeleteAlert, presenting: contractToDelete) { contract in
                Button("Sil", role: .destructive) {
                    HistoryManager.shared.confirmDelete()
                    contractToDelete = nil
                }
                Button("İptal", role: .cancel) {
                    HistoryManager.shared.cancelDelete()
                    contractToDelete = nil
                }
            } message: { contract in
                Text("\(contract.fileName) dosyasını silmek istediğinizden emin misiniz?")
            }
        }
    }
}

struct ContractHistoryRow: View {
    let contract: Contract.AnalyzedContract
    @ObservedObject private var historyManager = HistoryManager.shared
    @State private var isFavorite: Bool
    
    init(contract: Contract.AnalyzedContract) {
        self.contract = contract
        _isFavorite = State(initialValue: contract.isFavorite)
    }
    
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
                withAnimation(.spring()) {
                    isFavorite.toggle()
                    historyManager.toggleFavorite(contract)
                }
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.title2)
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
} 