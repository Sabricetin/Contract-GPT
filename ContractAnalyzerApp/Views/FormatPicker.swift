import SwiftUI

struct FormatPicker: View {
    @Binding var selectedFormat: ExportFormat
    
    var body: some View {
        Picker("Format", selection: $selectedFormat) {
            ForEach(ExportFormat.allCases, id: \.self) { format in
                Label(format.rawValue, systemImage: format.icon)
                    .tag(format)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct FormatPickerPreview: View {
    @State private var selectedFormat: ExportFormat = .pdf
    
    var body: some View {
        FormatPicker(selectedFormat: $selectedFormat)
            .padding()
    }
}

#Preview {
    FormatPickerPreview()
} 