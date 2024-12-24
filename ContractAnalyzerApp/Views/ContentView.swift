import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Anasayfa", systemImage: "house")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("Analizler", systemImage: "list.bullet")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

struct HomeView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFilePicker = false
    @State private var path = NavigationPath()
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("ContractGPT")
                    .font(.largeTitle)
                    .bold()
                
                Text("Yapay Zeka Destekli\nSözleşme Analizi")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("PDF veya metin dosyası yükleyerek sözleşmenizi analiz edin")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingFilePicker = true
                    }) {
                        Label("Sözleşme Yükle", systemImage: "doc.badge.plus")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: UTType.supportedTypes,
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        Task {
                            await viewModel.analyzeDocument(at: url)
                            if let lastContract = HistoryManager.shared.contracts.last {
                                path.append(lastContract)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .navigationDestination(for: Contract.AnalyzedContract.self) { contract in
                ContractDetailView(contract: contract)
            }
        }
    }
}

#Preview {
    ContentView()
} 