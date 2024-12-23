import SwiftUI

struct TemplateLibraryView: View {
    @StateObject private var viewModel = TemplateViewModel()
    
    var body: some View {
        List(viewModel.templates) { template in
            NavigationLink(destination: TemplateDetailView(template: template)) {
                TemplateRow(template: template)
            }
        }
        .navigationTitle("Şablon Kütüphanesi")
        .searchable(text: $viewModel.searchText)
    }
} 