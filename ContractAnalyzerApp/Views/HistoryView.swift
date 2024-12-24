import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import Foundation

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFavoritesOnly = false
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var contractToDelete: Contract.AnalyzedContract?
    @State private var selectedContract: Contract.AnalyzedContract?
    
    // Toast durumları için state'ler
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastModifier.ToastType = .info
    
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
            Group {
                if viewModel.contracts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 70))
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)
                        
                        Text("Henüz Analiz Yok")
                            .font(.title2)
                            .bold()
                        
                        Text("Sözleşmelerinizi analiz etmek için anasayfaya gidin")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
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
            .toast(isPresented: $showToast, message: toastMessage, type: toastType)
            .alert("Analizi Sil", isPresented: $showingDeleteAlert, presenting: contractToDelete) { contract in
                Button("Sil", role: .destructive) {
                    HistoryManager.shared.confirmDelete()
                    contractToDelete = nil
                    toastMessage = "Analiz başarıyla silindi"
                    toastType = .success
                    showToast = true
                }
                Button("İptal", role: .cancel) {
                    HistoryManager.shared.cancelDelete()
                    contractToDelete = nil
                }
            } message: { contract in
                Text("\(contract.fileName) dosyasını silmek istediğinizden emin misiniz?")
            }
        }
        .onAppear {
            // Bildirim dinleyicisini ekle
            NotificationCenter.default.addObserver(
                forName: .contractAnalysisCompleted,
                object: nil,
                queue: .main
            ) { notification in
                if let contract = notification.userInfo?["contract"] as? Contract.AnalyzedContract {
                    selectedContract = contract
                }
            }
        }
        .background(
            NavigationLink(
                destination: selectedContract.map { ContractDetailView(contract: $0) },
                isActive: Binding(
                    get: { selectedContract != nil },
                    set: { if !$0 { selectedContract = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
}

struct ContractHistoryRow: View {
    let contract: Contract.AnalyzedContract
    @ObservedObject private var historyManager = HistoryManager.shared
    @State private var isFavorite: Bool
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastModifier.ToastType = .info
    
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
                    
                    // Favori durumuna göre toast mesajı
                    toastMessage = isFavorite ? "Favorilere eklendi" : "Favorilerden çıkarıldı"
                    toastType = .success
                    showToast = true
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
        .toast(isPresented: $showToast, message: toastMessage, type: toastType)
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
} 
