import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var showingDocumentPicker = false
    @Published var analysisResult: Contract.AnalysisResult?
    @Published var error: String?
    
    let documentPickerViewModel = DocumentPickerViewModel()
    
    func showDocumentPicker() {
        showingDocumentPicker = true
    }
} 