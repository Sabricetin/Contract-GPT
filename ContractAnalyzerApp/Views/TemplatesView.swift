import SwiftUI

struct TemplatesView: View {
    @StateObject private var viewModel = TemplateViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.templates) { template in
                NavigationLink(destination: TemplateDetailView(template: template)) {
                    TemplateRow(template: template)
                }
            }
        }
        .navigationTitle("Şablonlar")
        .searchable(text: $viewModel.searchText)
    }
}

struct TemplateRow: View {
    let template: ContractTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(template.name)
                .font(.headline)
            Text(template.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                ForEach(template.tags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 8)
    }
} 