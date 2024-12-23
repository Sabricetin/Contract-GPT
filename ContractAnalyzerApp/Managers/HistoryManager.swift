import Foundation
import SwiftUI

public class HistoryManager: ObservableObject {
    public static let shared = HistoryManager()
    
    @Published public private(set) var contracts: [Contract.AnalyzedContract] = []
    private let defaults = UserDefaults.standard
    private let contractsKey = "analyzedContracts"
    
    private var tempDeletedContracts: [Contract.AnalyzedContract] = []
    
    private init() {
        loadContracts()
    }
    
    public func saveContract(_ contract: Contract.AnalyzedContract) {
        if !contracts.contains(where: { $0.id == contract.id }) {
            contracts.append(contract)
            saveToDefaults()
            objectWillChange.send()
        }
    }
    
    public func toggleFavorite(_ contract: Contract.AnalyzedContract) {
        if let index = contracts.firstIndex(where: { $0.id == contract.id }) {
            var updatedContract = contracts[index]
            updatedContract.isFavorite.toggle()
            contracts[index] = updatedContract
            saveToDefaults()
            objectWillChange.send()
            NotificationCenter.default.post(name: .contractsDidChange, object: nil)
        }
    }
    
    private func saveToDefaults() {
        if let encoded = try? JSONEncoder().encode(contracts) {
            defaults.set(encoded, forKey: contractsKey)
            defaults.synchronize()
        }
    }
    
    private func loadContracts() {
        if let data = defaults.data(forKey: contractsKey),
           let decoded = try? JSONDecoder().decode([Contract.AnalyzedContract].self, from: data) {
            contracts = decoded
            objectWillChange.send()
        }
    }
    
    public func deleteContract(_ contract: Contract.AnalyzedContract) {
        contracts.removeAll { $0.id == contract.id }
        saveToDefaults()
    }
    
    public func deleteContracts(at offsets: IndexSet) {
        contracts.remove(atOffsets: offsets)
        saveToDefaults()
    }
    
    public func tempDeleteContract(_ contract: Contract.AnalyzedContract) {
        if let index = contracts.firstIndex(where: { $0.id == contract.id }) {
            tempDeletedContracts.append(contracts[index])
            contracts.remove(at: index)
            objectWillChange.send()
        }
    }
    
    public func confirmDelete() {
        tempDeletedContracts.removeAll()
        saveToDefaults()
    }
    
    public func cancelDelete() {
        if let contract = tempDeletedContracts.first {
            contracts.append(contract)
            tempDeletedContracts.removeAll()
            objectWillChange.send()
        }
    }
} 