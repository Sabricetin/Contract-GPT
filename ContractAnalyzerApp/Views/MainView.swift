import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationView {
                VStack {
                    if let result = viewModel.analysisResult {
                        AnalysisResultView(analysis: result)
                    } else {
                        DocumentPickerView(viewModel: viewModel.documentPickerViewModel)
                    }
                }
                .navigationTitle("Sözleşme Analizi")
            }
            .tabItem {
                Label("Analiz", systemImage: "doc.text.magnifyingglass")
            }
            .tag(0)
            
            NavigationView {
                TemplatesView()
            }
            .tabItem {
                Label("Şablonlar", systemImage: "doc.text")
            }
            .tag(1)
            
            NavigationView {
                HistoryView()
            }
            .tabItem {
                Label("Geçmiş", systemImage: "clock")
            }
            .tag(2)
        }
    }
}

// Preview provider ekleyelim
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 