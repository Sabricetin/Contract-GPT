import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    @Published var contracts: [Contract.AnalyzedContract] = []
    private let historyManager = HistoryManager.shared
    
    init() {
        // İlk yükleme
        contracts = historyManager.contracts
        
        // HistoryManager'ı dinle
        NotificationCenter.default.addObserver(self,
            selector: #selector(contractsDidChange),
            name: .contractsDidChange,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contractsDidChange() {
        DispatchQueue.main.async {
            self.contracts = self.historyManager.contracts
        }
    }
}

// Notification name extension
extension Notification.Name {
    static let contractsDidChange = Notification.Name("contractsDidChange")
} 