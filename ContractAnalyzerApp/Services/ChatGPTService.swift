import Foundation

class ChatGPTService {
    static let shared = ChatGPTService()
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    private init(apiKey: String = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "") {
        self.apiKey = apiKey
        print("API Key:", apiKey.prefix(5))
    }
    
    func sendPrompt(_ prompt: String) async throws -> String {
        // API kotası dolduğu için test amaçlı sahte yanıt dönüyoruz
        return """
        Özet:
        Bu sözleşme, bir mobil hizmet abonelik sözleşmesidir.

        Önemli Maddeler:
        1. Hizmet Süresi: 12 ay
        2. Aylık Ücret: 100 TL
        3. İptal Koşulları: 30 gün önceden bildirim

        Riskler:
        1. Otomatik yenileme maddesi
        2. Tek taraflı fiyat değişikliği hakkı
        3. Veri kullanım politikası

        Öneriler:
        1. İptal süresini not edin
        2. Fiyat değişikliklerini takip edin
        3. Veri kullanım politikasını dikkatle okuyun
        """
    }
}

// MARK: - Error Types
enum ChatGPTError: Error {
    case requestFailed
    case invalidResponse
    case missingAPIKey
}

// MARK: - Response Models
struct ChatGPTResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String
} 