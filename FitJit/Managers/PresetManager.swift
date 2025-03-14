import Foundation

class PresetManager: ObservableObject {
    @Published var presets: [Preset] = []
    private let presetsKey = "savedPresets"
    
    init() {
        loadPresets()
    }
    
    func savePreset(_ preset: Preset) {
        presets.append(preset)
        savePresets()
    }
    
    func deletePreset(at offsets: IndexSet) {
        presets.remove(atOffsets: offsets)
        savePresets()
    }
    
    private func savePresets() {
        if let encoded = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(encoded, forKey: presetsKey)
        }
    }
    
    private func loadPresets() {
        if let data = UserDefaults.standard.data(forKey: presetsKey),
           let decoded = try? JSONDecoder().decode([Preset].self, from: data) {
            presets = decoded
        }
    }
}