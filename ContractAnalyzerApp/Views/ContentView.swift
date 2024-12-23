import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
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
    @StateObject private var documentPicker = DocumentPickerViewModel()
    @State private var showingDocumentPicker = false
    @State private var selectedContract: Contract.AnalyzedContract?
    
    var body: some View {
        NavigationView {
            VStack {
                if documentPicker.isAnalyzing {
                    ProgressView("Sözleşme analiz ediliyor...")
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Sözleşme Analizi")
                            .font(.title)
                            .bold()
                        
                        Text("PDF veya metin dosyası yükleyerek sözleşmenizi analiz edin")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showingDocumentPicker = true
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
                    .padding()
                }
                
                if let error = documentPicker.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("ContractGPT")
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPickerView(viewModel: documentPicker)
            }
            .background(
                NavigationLink(
                    destination: ContractDetailView(contract: selectedContract ?? Contract.AnalyzedContract(
                        fileName: "",
                        analyzedDate: Date(),
                        analysis: Contract.AnalysisResult(
                            summary: "",
                            keyPoints: [],
                            risks: [],
                            recommendations: [],
                            riskAssessment: nil,
                            riskLevel: .medium,
                            formattedRiskScore: "0"
                        ),
                        isFavorite: false
                    )),
                    isActive: Binding(
                        get: { selectedContract != nil },
                        set: { if !$0 { selectedContract = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
            .onChange(of: documentPicker.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    if let lastContract = HistoryManager.shared.contracts.last {
                        selectedContract = lastContract
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 