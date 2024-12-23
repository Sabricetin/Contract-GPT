import SwiftUI

struct SettingsView: View {
    @AppStorage("OPENAI_API_KEY") private var apiKey = ""
    @State private var showingAPIKeyAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Genel")) {
                    NavigationLink {
                        APISettingsView(apiKey: $apiKey)
                    } label: {
                        Label("API Ayarları", systemImage: "key")
                    }
                    
                    NavigationLink {
                        LanguageSettingsView()
                    } label: {
                        Label("Dil Ayarları", systemImage: "globe")
                    }
                }
                
                Section(header: Text("Hakkında")) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("Hakkında", systemImage: "info.circle")
                    }
                    
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Gizlilik Politikası", systemImage: "hand.raised")
                    }
                    
                    Link(destination: URL(string: "https://github.com/yourusername/ContractGPT")!) {
                        Label("GitHub", systemImage: "link")
                    }
                }
                
                Section(header: Text("Uygulama Bilgileri")) {
                    HStack {
                        Text("Versiyon")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

struct APISettingsView: View {
    @Binding var apiKey: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("OpenAI API Key")) {
                SecureField("API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocapitalization(.none)
                
                Button("API Key'i Kaydet") {
                    dismiss()
                }
                .disabled(apiKey.isEmpty)
            }
            
            Section(header: Text("Bilgi")) {
                Text("API key'inizi OpenAI'dan alabilirsiniz.")
                Link("OpenAI API Keys", destination: URL(string: "https://platform.openai.com/account/api-keys")!)
            }
        }
        .navigationTitle("API Ayarları")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguageSettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "tr"
    
    var body: some View {
        Form {
            Picker("Uygulama Dili", selection: $selectedLanguage) {
                Text("Türkçe").tag("tr")
                Text("English").tag("en")
            }
        }
        .navigationTitle("Dil Ayarları")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("ContractGPT")
                        .font(.title)
                        .bold()
                    
                    Text("Sözleşme Analiz Uygulaması")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section(header: Text("Geliştirici")) {
                Text("Geliştirici Adı")
                Text("developer@email.com")
            }
        }
        .navigationTitle("Hakkında")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Gizlilik Politikası")
                    .font(.title)
                    .bold()
                
                Text("Bu uygulama, sözleşmelerinizi analiz etmek için OpenAI API'sini kullanır. Yüklediğiniz sözleşmeler ve analiz sonuçları yalnızca cihazınızda saklanır ve üçüncü taraflarla paylaşılmaz.")
                
                Text("Veri Toplama")
                    .font(.headline)
                Text("Uygulama, yalnızca analiz için yüklediğiniz sözleşmeleri ve API key'inizi saklar. Bu veriler cihazınızdan dışarı çıkmaz.")
                
                Text("Veri Kullanımı")
                    .font(.headline)
                Text("Toplanan veriler yalnızca sözleşme analizi için kullanılır ve başka amaçlarla kullanılmaz.")
            }
            .padding()
        }
        .navigationTitle("Gizlilik Politikası")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
} 