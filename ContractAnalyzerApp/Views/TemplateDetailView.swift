import SwiftUI

struct TemplateDetailView: View {
    let template: ContractTemplate
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Şablon Başlığı ve Açıklaması
                VStack(alignment: .leading, spacing: 8) {
                    Text(template.name)
                        .font(.title2)
                        .bold()
                    Text(template.description)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Kategori ve Etiketler
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kategori: \(template.category)")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(template.tags, id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Önerilen Maddeler
                if !template.recommendedClauses.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Önerilen Maddeler")
                            .font(.headline)
                        
                        ForEach(template.recommendedClauses, id: \.self) { clause in
                            Text("• \(clause)")
                                .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Uyarılar
                if !template.warnings.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Uyarılar")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        ForEach(template.warnings, id: \.self) { warning in
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(warning)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // İçerik
                VStack(alignment: .leading, spacing: 10) {
                    Text("Şablon İçeriği")
                        .font(.headline)
                    Text(template.content)
                        .font(.body)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Şablon Detayı")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareTemplateView(template: template)
        }
    }
}

struct ShareTemplateView: View {
    let template: ContractTemplate
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(template.content)
                    .padding()
            }
            .navigationTitle("Şablon Paylaş")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationView {
        TemplateDetailView(template: ContractTemplate(
            name: "Örnek Şablon",
            description: "Bu bir örnek şablon açıklamasıdır.",
            content: "Şablon içeriği buraya gelecek...",
            category: "Genel",
            tags: ["Örnek", "Test"],
            recommendedClauses: ["Madde 1", "Madde 2"],
            warnings: ["Dikkat edilmesi gereken nokta"]
        ))
    }
} 